let () =
  let app = App.from_ast (Lang.Parser.app Lang.Lexer.read (Lexing.from_channel (open_in Sys.argv.(1)))) in
  let cfg = App.get_method app "MainActivity" "onCreate" in
  print_endline (Cfg.to_string cfg)
