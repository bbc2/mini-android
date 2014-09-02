type calls = (Site.t * string * Sites.t list * (Global.t -> Global.t)) list

let lifecycle_update s state g =
  let (h, a) = g in
  let h' = Heap.set_field h s Field.State (Value.State (State.from_list [state])) in
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
  if Finished.le f Finished.True then
    List.filter (fun ((_, m, _), _) -> List.mem m ["onPause"; "onStop"; "onDestroy"]) calls
  else
    calls

let lifecycle g s =
  let (h, _) = g in
  let state = Value.get_state (Heap.get_field h s Field.State) in
  let pending = Value.get_pending (Heap.get_field h s Field.Pending) in
  let finished = Value.get_finished (Heap.get_field h s Field.Finished) in
  filter_finished finished
    (filter_pending pending
       (State.fold (lifecycle_calls s) state []))

let next_lifecycle g =
  let (_, a) = g in
  match a with
  | As.Any -> failwith "Android.next_lifecycle: Activity stack lost"
  | As.AS al ->
    (* Gather potential lifecycle calls for each activity in the stack *)
    let add_cs cs s =
      cs @ (lifecycle g s) in
    List.map (fun (c, a) -> Action.Call (c, a)) (List.fold_left add_cs [] al)
  | As.None -> []

let finish s g =
  let (h, a) = g in
  let h' = Heap.set_field h s Field.Finished (Value.Finished Finished.True) in
  (h', a)

let next_back g =
  let (h, a) = g in
  match a with
  | As.Any -> failwith "Android.next_back: Activity stack lost"
  | As.AS (s :: _) ->
    let state = Value.get_state (Heap.get_field h s Field.State) in
    if State.le (State.from_list [State.Active]) state then
      [Action.Back s]
    else
      []
  | As.AS [] | As.None -> []

let next_new g =
  let (h, a) = g in
  match a with
  | As.Any -> failwith "Android.next_new: Activity stack lost"
  | As.AS (s :: _) ->
    let state = Value.get_state (Heap.get_field h s Field.State) in
    let pending = Value.get_pending (Heap.get_field h s Field.Pending) in
    if State.le (State.from_list [State.Stopped]) state
    || State.le (State.from_list [State.Visible]) state then
      let add_cs cl cs =
        (Action.New cl) :: cs in
      Pending.fold add_cs pending []
    else
      []
  | As.AS [] | As.None -> []

let new_activity cl g =
  let (h, a) = g in
  let s = Site.make cl 0 in
  let o = Object.from_list [
      (Field.State, Value.State (State.from_list [State.Uninit]));
      (Field.Pending, Value.Pending (Pending.from_list []));
      (Field.Finished, Value.Finished (Finished.False))
    ] in
  let h_new = Heap.add h s o in
  let a_new = As.push a s in
  (h_new, a_new)

let next_click g =
  let (h, a) = g in
  match a with
  | As.Any -> failwith "Android.next_click: Activity stack lost"
  | As.AS (s :: _) ->
      let state = Value.get_state (Heap.get_field h s Field.State) in
      if State.le (State.from_list [State.Active]) state then
        let listeners = Value.get_sites (Heap.get_field h s Field.Listeners) in
        let arg = Value.Sites (Sites.from_list [s]) in
        let add_action listener actions =
          (Action.Call ((listener, "onClick", [arg]), fun i -> i)) :: actions in
        Sites.fold add_action listeners []
      else
        []
  | As.AS [] | As.None -> []

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
