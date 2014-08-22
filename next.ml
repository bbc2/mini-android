type t = Call.t * Context.t

let compare n1 n2 =
  let (call1, c1) = n1 in
  let (call2, c2) = n2 in
  let c = Call.compare call1 call2 in
  if c = 0 then
    Context.compare c1 c2
  else
    c

let to_string n =
  let (call, c) = n in
  Printf.sprintf "(%s, %s)" (Call.to_string call) (Context.to_string c)

