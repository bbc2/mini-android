type t = string * int
let compare = compare

let make m l =
  (m, l)

let get_class s =
  let (m, _) = s in m

let to_string s =
  let (m, l) = s in
  Printf.sprintf "%s:%d" m l
