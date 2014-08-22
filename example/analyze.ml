let () =
  let app = App.from_ast (Lang.Parser.app Lang.Lexer.read (Lexing.from_channel (open_in Sys.argv.(1)))) in
  let append g l = 
    let gc = Gcontext.from_list [(Context.from_global g, (g, Nexts.bot))] in
    (Analysis.fixpoint Gcontext.equal (Android.transfer app) gc)::l in
  let analysis = List.hd (App.fold_on_init_states append app []) in
  print_endline (Dot.from_gcontext analysis)
