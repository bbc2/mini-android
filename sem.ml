let rec transfer cfg l =
  let step e l =
    let (_, i, _) = e in
    Local.red (Local.join l (transfer_of_inst i l)) in
  Cfg.fold step cfg l

and transfer_of_inst i l : Local.t =
  let ((h, a), e) = l in
  match i with
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
    let val_new = Local.get_field l v2 f in
    let e_new = Env.from_list [(v1, val_new)] in
    (Global.bot, e_new)
  | Cfg.Call (v, m, args) ->
      try
        transfer_of_api_exn m v args l
      with Not_found ->
        l

and transfer_of_api_exn m v args l =
  match m with
  | "startActivity" ->
      transfer (Cfg.from_list []) l
  | _ -> raise Not_found
