let _ =
  Lang.Parser.app Lang.Lexer.read (Lexing.from_channel (open_in Sys.argv.(1)))
