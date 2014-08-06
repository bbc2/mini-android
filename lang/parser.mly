%token Manifest Class Method New
%token LeftPar RightPar LeftCurly RightCurly
%token Eq Dot Semi Comma
%token <string> Id
%token <string> Str
%token Eof

%start <Ast.app> app

%%

app:
| m = manifest cl = class_+ Eof { (m, cl) }

manifest:
| Manifest LeftCurly s = Id RightCurly { s }

class_:
| Class c = Id LeftCurly ml = method_* RightCurly { (c, ml) }

method_:
| Method m = Id LeftPar RightPar (* no arguments, no return value *)
  LeftCurly il = separated_list(Semi, inst) RightCurly { (m, il) }

inst:
| v = Id Eq s = Str { Ast.Assign (v, s) }
| v = Id Eq New c = Id { Ast.New (v, c) }
| v1 = Id Dot f = Id Eq v2 = Id { Ast.Set (v1, f, v2) }
| v1 = Id Eq v2 = Id Dot f = Id { Ast.Get (v1, v2, f) }
| v = Id Dot m = Id
  LeftPar args = separated_list(Comma, Id) RightPar { Ast.Call (v, m, args) }
