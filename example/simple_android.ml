let () =
  let s_ma = Site.make "MainActivity" 0 in
  let o_ma = Object.from_list [
      (Field.AField "state", Value.State (State.State State.Uninit))
    ] in
  let h = Heap.from_list [(s_ma, o_ma)] in
  let a = As.from_list [s_ma] in
  let g = (h, a) in
  let gc = Gcontext.from_list [(Context.from_global g, g)] in
  let ma_init_cfg = Cfg.from_list [
      (1, Cfg.New ("x", "Class1", 1), 2);
      (2, Cfg.Set ("this", "f", "x"), 3);
    ] in
  let app = App.make (App.manifest_from_string "MainActivity")
      (App.classes_from_list [("MainActivity", App.methods_from_list [("<init>", ma_init_cfg)])]) in
  print_endline (Gcontext.to_string gc);
  print_endline (Gcontext.to_string (Analysis.fixpoint Gcontext.equal (Android.transfer app) gc))
