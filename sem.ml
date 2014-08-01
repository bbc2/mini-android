exception Wrong_args of int

let check_args_exn n l =
  if n <> List.length l then
    raise (Wrong_args n)

let transfer_of_api_exn m v args l =
  let ((h, _), e) = l in
  match m with
  | "startActivity" ->
    (* Assumption: only one such call per callback. Otherwise, the analysis is
       potentially incorrect. *)
    let arg = match args with
      | [a] -> a
      | _ -> raise (Wrong_args (List.length args)) in
    let ss = Value.get_sites (Env.get e v) in
    let pstack = match Env.get e arg with
      | Value.String s -> [s]
      | _ -> [] in
    let pending = Value.Pending (Pending.from_stack pstack) in
    let update s h = Heap.add_field h s (Field.AField "pending") pending in
    let h_update = Sites.fold update ss Heap.bot in
    ((h_update, As.bot), Env.bot)
  | _ -> raise Not_found

let transfer_of_inst i l : Local.t =
  let ((h, a), e) = l in
  match i with
  | Cfg.Assign (v, s) ->
    let e_new = Env.from_list [(v, Value.String s)] in
    ((Heap.bot, As.bot), e_new)
  | Cfg.New (v, s) ->
    let e_new = Env.from_list [(v, (Value.from_list [s]))] in
    ((Heap.bot, As.bot), e_new)
  | Cfg.Set (v1, f, v2) ->
    let val2 = Env.get e v2 in
    let ss1 = Value.get_sites (Env.get e v1) in
    let update s h = Heap.add_field h s (Field.JField f) val2 in
    let h_update = Sites.fold update ss1 Heap.bot in
    ((h_update, As.bot), Env.bot)
  | Cfg.Get (v1, v2, f) ->
    let val_new = Local.get_field l v2 (Field.JField f) in
    let e_new = Env.from_list [(v1, val_new)] in
    (Global.bot, e_new)
  | Cfg.Call (v, m, args) ->
    try
      transfer_of_api_exn m v args l
    with
    | Wrong_args n -> failwith (Printf.sprintf "Wrong number of args for %s: %d instead of %d" m n (List.length args))
    | Not_found -> l

let transfer cfg l =
  let step e l =
    let (_, i, _) = e in
    Local.red (Local.join l (transfer_of_inst i l)) in
  Cfg.fold step cfg l
