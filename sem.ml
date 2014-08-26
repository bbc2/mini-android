let transfer_of_inst api_exn i l : Local.t =
  let ((h, a), e) = l in
  match i with
  | Cfg.Assign (v, s) ->
    let e_new = Env.from_list [(v, Value.String s)] in
    ((Heap.bot, As.bot), e_new)
  | Cfg.New (v, cl, id) ->
    let e_new = Env.from_list [(v, (Value.Sites (Sites.from_list [Site.make cl id])))] in
    ((Heap.bot, As.bot), e_new)
  | Cfg.Set (v1, f, v2) ->
    let val2 = Env.get e v2 in
    let ss1 = Value.get_sites (Env.get e v1) in
    let update s h = Heap.add_field h s (Field.J f) val2 in
    let h_update = Sites.fold update ss1 Heap.bot in
    ((h_update, As.bot), Env.bot)
  | Cfg.Get (v1, v2, f) ->
    let val_new = Local.get_field l v2 (Field.J f) in
    let e_new = Env.from_list [(v1, val_new)] in
    (Global.bot, e_new)
  | Cfg.Call (v, m, args) ->
    try
      api_exn m v args l
    with Api.Method_not_found -> l

let transfer api_exn cfg l =
  let step e l =
    let (_, i, _) = e in
    Local.join l (transfer_of_inst api_exn i l) in
  Cfg.fold (fun _ _ l -> l) step cfg l
