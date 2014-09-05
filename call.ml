type t = Site.t * string * Value.t list

let compare c1 c2 =
  let (s1, m1, args1) = c1 in
  let (s2, m2, args2) = c2 in
  Lib.(Site.compare s1 s2 $ list_compare Value.compare args1 args2)

let to_string c =
  let (s, m, args) = c in
  let append s arg =
    Printf.sprintf "%s%s%s" s (if s = "" then "" else ", ") (Value.to_string arg) in
  Printf.sprintf "%s.%s(%s)" (Site.to_string s) m (List.fold_left append "" args)
