type call = Sites.t * string * string * Sites.t list
module CallSet = Lib.Set.Make(struct type t = call let compare = compare end)

let lifecycle s st =
  let cl = Site.get_class s in
  let ss = Sites.from_list [s] in
  let csl = match st with
    | State.Uninit -> [(ss, cl, "<init>", [])]
    | State.Init -> [(ss, cl, "onCreate", [])]
    | State.Created -> [(ss, cl, "onResume", [])]
    | State.Active -> [(ss, cl, "onPause", [])] in
  CallSet.from_list csl

let next_lifecycle s state =
  match state with
  | State.Any -> failwith "Activity state lost"
  | State.State st ->
    lifecycle s st
  | State.None -> CallSet.empty

let next g =
  let (h, a) = g in
  match a with
  | As.Any -> failwith "Activity stack lost"
  | As.AS al ->
    let next_lifecycle cs s =
      let value = Heap.get_field h s (Field.AField "state") in
      let state = Value.get_state value in
      CallSet.union cs (next_lifecycle s state) in
    List.fold_left next_lifecycle CallSet.empty al
  | As.None -> CallSet.empty

let update m g =
  g

let transfer_of_call app g call gc =
  (* Call args and return value are not taken into accounct. *)
  let (s, cl, m, _) = call in
  let e_init = Env.from_list [("this", Value.Sites s)] in
  let l_init = (g, e_init) in
  let cfg = App.get_method app cl m in
  let (g_final, _) = Analysis.fixpoint Local.equal (Sem.transfer Api.transfer_exn cfg) l_init in
  let g_updated = update m g_final in
  Gcontext.add gc (Context.from_global g_updated) g_updated

let transfer_of_context app c g gc =
  CallSet.fold (transfer_of_call app g) (next g) gc

let transfer app gc =
  Gcontext.fold (transfer_of_context app) gc gc
