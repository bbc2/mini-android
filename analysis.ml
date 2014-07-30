type label = int

let fixpoint transfer l0 =
  let rec iter l =
    let l' = transfer l in
    if Local.equal l l' then
      l
    else
      iter l' in
  iter l0

let transfer_of i l : Local.t =
  let ((h, a), e) = l in
  match i with
  | Cfg.New (v, s) ->
    let e_new = Env.EnvMap.singleton v (Value.Sites (Value.SiteSet.singleton s)) in
    ((Heap.bot, As.bot), e_new)
  | Cfg.Set (v1, f, v2) ->
    let val1 = Env.get e v1 in
    let val2 = Env.get e v2 in
    begin
      match val1 with
      | Value.None -> Local.bot
      | Value.Sites ss1 ->
        let update s h =
          Heap.HeapMap.add s (Object.ObjectMap.singleton (Field.JField f) val2) h in
        let h_update = Value.SiteSet.fold update ss1 Heap.bot in
        ((h_update, As.bot), Env.bot)
    end
  | Cfg.Get (v1, v2, f) ->
    let val2 = Env.get e v2 in
    begin
      match val2 with
      | Value.None -> Local.bot
      | Value.Sites ss2 ->
        let join s v =
          Value.join v (Object.get (Heap.get h s) (Field.JField f)) in
        let val_update = Value.SiteSet.fold join ss2 Value.bot in
        let e_update = Env.EnvMap.singleton v1 val_update in
        (Global.bot, e_update)
    end
  | _ -> Local.bot (* incorrect *)

let transfer cfg l =
  let step e l =
    let (_, i, _) = e in
    Local.join l (transfer_of i l) in
  Cfg.fold step cfg l

let _ =
  let g0 = (Heap.from_list [(17, Object.from_list [(Field.AField "oij", Value.from_list [13; 42])])], As.AS []) in
  let e0 = Env.from_list [] in
  let l0 = (g0, e0) in
  let cfg = Cfg.from_list [
      (1, Cfg.New ("x", 17), 2);
      (2, Cfg.New ("x", 42), 3);
      (3, Cfg.New ("y", 3), 4);
      (4, Cfg.Set ("x", "f", "y"), 5);
      (5, Cfg.Get ("z", "x", "f"), 6);
    ] in
  print_endline (Local.to_string l0);
  print_endline (Cfg.to_string cfg);
  print_endline (Local.to_string (fixpoint (transfer cfg) l0))
