let _ =
  Lang.Parser.app Lang.Lexer.lexer (Lexing.from_channel (open_in Sys.argv.(1)))
