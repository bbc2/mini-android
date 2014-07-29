type label = int

let () =
  let g0 = (Heap.from_list [(17, Object.from_list [(Field.AField "oij", Value.from_list [13; 42])])], Global.AS []) in
  let cfg = Cfg.from_list [(1, Cfg.New ("i", 17), 2); (2, Cfg.Call ("a", "startActivity", ["i"; "this"]), 3)] in
  print_endline (Global.to_string g0);
  print_endline (Cfg.to_string cfg)
