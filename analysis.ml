let fixpoint transfer l0 =
  let rec iter l =
    let l' = transfer l in
    if Local.equal l l' then
      l
    else
      iter l' in
  iter l0

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
  print_endline (Local.to_string (fixpoint (Sem.transfer cfg) l0))
