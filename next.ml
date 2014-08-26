type t = Action.t * Context.t

let compare n1 n2 =
  let (a1, c1) = n1 in
  let (a2, c2) = n2 in
  let c = Action.compare a1 a2 in
  if c = 0 then
    Context.compare c1 c2
  else
    c

let to_string n =
  let (a, c) = n in
  Printf.sprintf "(%s, %s)" (Action.to_string a) (Context.to_string c)

