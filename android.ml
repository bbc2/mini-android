type calls = (Site.t * string * Sites.t list * (Global.t -> Global.t)) list

let lifecycle_update s state g =
  let (h, a) = g in
  let h' = Heap.set_field h s Field.State (Value.State (State.from_list [state])) in
  (h', a)

let lifecycle_calls s st calls =
  match st with
  | State.Uninit -> (s, "<init>", [], lifecycle_update s State.Init)::calls
  | State.Init -> (s, "onCreate", [], lifecycle_update s State.Created)::calls
  | State.Created -> (s, "onResume", [], lifecycle_update s State.Active)::calls
  | State.Active -> (s, "onPause", [], lifecycle_update s State.Created)::calls

let lifecycle g s =
  let (h, _) = g in
  let value = Heap.get_field h s Field.State in
  let state = Value.get_state value in
  State.fold (lifecycle_calls s) state []

let next g =
  let (_, a) = g in
  match a with
  | As.Any -> failwith "Android.next: Activity stack lost"
  | As.AS al ->
    (* Gather potential calls for each activity in the stack *)
    let add_cs cs s =
      cs @ (lifecycle g s) in
    List.fold_left add_cs [] al
  | As.None -> []

let transfer_of_call app g gc call =
  (* Call args and return value are not taken into account. *)
  let (s, m, args, update) = call in
  let e_init = Env.from_list [("this", Value.Sites (Sites.from_list [s]))] in
  let l_init = (g, e_init) in
  let cfg = App.get_method app (Site.get_class s) m in
  let (g_final, _) = Analysis.fixpoint Local.equal (Sem.transfer Api.transfer_exn cfg) l_init in
  let g_updated = update g_final in
  Gcontext.add gc (Context.from_global g_updated) g_updated

let transfer_of_context app c g gc =
  List.fold_left (transfer_of_call app g) gc (next g)

let transfer app gc =
  Gcontext.fold (transfer_of_context app) gc gc
