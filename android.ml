type calls = (Site.t * string * Sites.t list * (Global.t -> Global.t)) list

let lifecycle_update s state g =
  let (h, a) = g in
  let (o, arec) = Heap.get h s in
  let h' = Heap.set h s (o, Arecord.set_state arec (State.from_list [state])) in
  (h', a)

let lifecycle_calls s st calls =
  let nexts = match st with
    | State.Uninit -> [((s, "<init>", []), lifecycle_update s State.Init)]
    | State.Init -> [((s, "onCreate", []), lifecycle_update s State.Created)]
    | State.Created -> [((s, "onStart", []), lifecycle_update s State.Visible)]
    | State.Visible -> [((s, "onResume", []), lifecycle_update s State.Active);
                        ((s, "onStop", []), lifecycle_update s State.Stopped)]
    | State.Active -> [((s, "onPause", []), lifecycle_update s State.Visible)]
    | State.Stopped -> [((s, "onRestart", []), lifecycle_update s State.Created);
                        ((s, "onDestroy", []), lifecycle_update s State.Destroyed)]
    | State.Destroyed -> [] in
  nexts @ calls

let filter_pending p calls =
  calls

let filter_finished f calls =
  if Bool.le f Bool.True then
    List.filter (fun ((_, m, _), _) -> List.mem m ["onPause"; "onStop"; "onDestroy"]) calls
  else
    calls

let lifecycle g s =
  let (h, _) = g in
  let (_, arec) = Heap.get h s in
  let state = Arecord.get_state arec in
  let pending = Arecord.get_pending arec in
  let finished = Arecord.get_finished arec in
  filter_finished finished
    (filter_pending pending
       (State.fold (lifecycle_calls s) state []))

let next_lifecycle g =
  let (_, a) = g in
  match a with
  | As.Bot -> []
  | As.Exact al ->
    (* Gather potential lifecycle calls for each activity in the stack *)
    let add_cs cs s =
      cs @ (lifecycle g s) in
    List.map (fun (c, a) -> Action.Call (c, a)) (List.fold_left add_cs [] al)
  | As.Top -> failwith "Android.next_lifecycle: Activity stack lost"

let finish s g =
  let (h, a) = g in
  let (o, arec) = Heap.get h s in
  let h' = Heap.set h s (o, Arecord.set_finished arec Bool.True) in
  (h', a)

let next_back g =
  let (h, a) = g in
  match a with
  | As.Bot | As.Exact [] -> []
  | As.Exact (s :: _) ->
    let (_, arec) = Heap.get h s in
    let state = Arecord.get_state arec in
    if State.le (State.from_list [State.Active]) state then
      [Action.Back s]
    else
      []
  | As.Top -> failwith "Android.next_back: Activity stack lost"

let next_new g =
  let (h, a) = g in
  match a with
  | As.Bot | As.Exact [] -> []
  | As.Exact (s :: _) ->
    let (_, arec) = Heap.get h s in
    let state = Arecord.get_state arec in
    let pending = Arecord.get_pending arec in
    if State.le (State.from_list [State.Stopped]) state
    || State.le (State.from_list [State.Visible]) state then
      let add_cs cl cs =
        (Action.New cl) :: cs in
      Pending.fold add_cs pending []
    else
      []
  | As.Top -> failwith "Android.next_new: Activity stack lost"

let new_activity cl g =
  let (h, a) = g in
  let s = Site.make cl 0 in
  let oa = (Object.bot, { Arecord.state = State.from_list [State.Uninit];
                          Arecord.pending = Pending.bot;
                          Arecord.finished = Bool.False;
                          Arecord.listeners = Sites.bot }) in
  let h_new = Heap.add h s oa in
  let a_new = As.push a s in
  (h_new, a_new)

let next_click g =
  let (h, a) = g in
  match a with
  | As.Bot | As.Exact [] -> []
  | As.Exact (s :: _) ->
    let (_, arec) = Heap.get h s in
    let state = Arecord.get_state arec in
    if State.le (State.from_list [State.Active]) state then
      let listeners = Arecord.get_listeners arec in
      let arg = Value.Sites (Sites.from_list [s]) in
      let add_action listener actions =
        (Action.Call ((listener, "onClick", [arg]), fun i -> i)) :: actions in
      Sites.fold add_action listeners []
    else
      []
  | As.Top -> failwith "Android.next_click: Activity stack lost"

let transfer_of_call app g gc action =
  let g' = match action with
    | Action.Call ((s, m, args), update) ->
      (* Return value is not taken into account. *)
      let (params, cfg) = App.get_method app (Site.get_class s) m in
      let e = Env.from_list (("this", Value.Sites (Sites.from_list [s]))
                             :: (List.combine params args)) in
      let l = (g, e) in
      let (g', _) = Analysis.fixpoint Local.equal (Sem.transfer Api.transfer_exn cfg) l in
      update g'
    | Action.Back s -> finish s g
    | Action.New cl -> new_activity cl g in
  let c' = Context.from_global g' in
  let gc_with_next = Gcontext.add gc (Context.from_global g) (Global.bot, Nexts.from_list [(action, c')]) in
  Gcontext.add gc_with_next c' (g', Nexts.bot)

let next g =
  (next_lifecycle g) @ (next_back g) @ (next_new g) @ (next_click g)

let transfer_of_context app c gn gc =
  let (g, _) = gn in
  List.fold_left (transfer_of_call app g) gc (next g)

let transfer app gc =
  Gcontext.fold (transfer_of_context app) gc gc
