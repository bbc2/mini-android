let () =
  let h0 = Heap.from_list [(17, Object.from_list [(Field.AField "oij", Value.Sites (Sites.from_list [13; 42]))])] in
  let a0 = As.from_list [] in
  let g0 = (h0, a0) in
  let e0 = Env.from_list [] in
  let l0 = (g0, e0) in
  let cfg = Cfg.from_list [
      (1, Cfg.New ("x", 17), 2);
      (2, Cfg.New ("x", 42), 3);
      (3, Cfg.New ("y", 3), 4);
      (4, Cfg.Set ("x", "f", "y"), 5);
      (5, Cfg.Get ("z", "x", "f"), 6);
      (6, Cfg.Assign ("i", "OtherActivity"), 7);
      (7, Cfg.Call ("z", "startActivity", ["i"]), 8);
    ] in
  print_endline (Local.to_string l0);
  print_endline (Cfg.to_string cfg);
  print_endline (Local.to_string (Analysis.fixpoint (Sem.transfer Api.transfer_exn cfg) l0))
