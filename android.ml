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
    List.fold_left add_cs [] al
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
        [((s, "~back", []), finish s)]
      else
        []
  | As.AS [] | As.None -> []

let transfer_of_call app g gc transition =
  (* Call args and return value are not taken into account. *)
  let ((s, m, args), update) = transition in
  let e_init = Env.from_list [("this", Value.Sites (Sites.from_list [s]))] in
  let l_init = (g, e_init) in
  let cfg = App.get_method app (Site.get_class s) m in
  let (g_final, _) = Analysis.fixpoint Local.equal (Sem.transfer Api.transfer_exn cfg) l_init in
  let g_updated = update g_final in
  let c_updated = Context.from_global g_updated in
  let gc_with_next = Gcontext.add gc (Context.from_global g) (Global.bot, Nexts.from_list [((s, m, args), c_updated)]) in
  Gcontext.add gc_with_next c_updated (g_updated, Nexts.bot)

let transfer_of_context app c gn gc =
  let (g, _) = gn in
  List.fold_left (transfer_of_call app g) gc ((next_lifecycle g) @ (next_back g))

let transfer app gc =
  Gcontext.fold (transfer_of_context app) gc gc
