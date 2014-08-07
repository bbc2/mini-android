let () =
  let h0 = Heap.from_list [
      (Site.make "MainActivity" 7,
       Object.from_list [
         (Field.AField "oij",
          Value.Sites (Sites.from_list [
              Site.make "Class1" 13;
              Site.make "Class3" 42]));
         (Field.AField "state",
          Value.State (State.from_state State.Uninit))
       ])] in
  let a0 = As.from_list [] in
  let g0 = (h0, a0) in
  let e0 = Env.from_list [] in
  let l0 = (g0, e0) in
  let cfg = Cfg.make 1 8 [
      (1, Cfg.New ("x", "Class1", 13), 2);
      (2, Cfg.New ("x", "Class2", 17), 3);
      (3, Cfg.New ("y", "Class3", 42), 4);
      (4, Cfg.Set ("x", "f", "y"), 5);
      (5, Cfg.Get ("z", "x", "f"), 6);
      (6, Cfg.Assign ("i", "OtherActivity"), 7);
      (7, Cfg.Call ("z", "startActivity", ["i"]), 8);
    ] in
  print_endline (Local.to_string l0);
  print_endline (Cfg.to_string cfg);
  print_endline (Local.to_string (Analysis.fixpoint Local.equal (Sem.transfer Api.transfer_exn cfg) l0))
