{
  open Parser
  open Lexing

  let next_line lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <-
      { pos with pos_bol = lexbuf.lex_curr_pos;
                 pos_lnum = pos.pos_lnum + 1
      }
}

let alpha = ['a' - 'z' 'A' - 'Z']
let space = ['\t' ' ']
let newline = '\n' | '\r' | "\r\n"
let printable = [' ' - '~']
let id_char = alpha | ['<' '>']
let str_char = printable # ['"']

rule read = parse
  | eof { Eof }
  | space+ { read lexbuf }
  | newline { next_line lexbuf; read lexbuf }
  | "manifest" { Manifest }
  | "class" { Class }
  | "method" { Method }
  | "new" { New (lexbuf.lex_curr_p.pos_lnum) }
  | "=" { Eq }
  | "." { Dot }
  | ";" { Semi }
  | "," { Comma }
  | "(" { LeftPar }
  | ")" { RightPar }
  | "{" { LeftCurly }
  | "}" { RightCurly }
  | id_char+ as str { Id str }
  | "\"" (str_char* as str) "\"" { Str str }
