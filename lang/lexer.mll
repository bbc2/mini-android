{
  open Parser
}

let alpha = ['a' - 'z' 'A' - 'Z']
let space = ['\n' '\r' '\t' ' ']
let printable = [' ' - '~']
let id_char = alpha | ['<' '>']
let str_char = printable # ['"']

rule lexer = parse
  | eof { Eof }
  | space+ { lexer lexbuf }
  | "manifest" { Manifest }
  | "class" { Class }
  | "method" { Method }
  | "new" { New }
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
