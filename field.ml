type t = JField of string | AField of string

let compare = compare

let to_string f =
  match f with
  | JField j -> "j:" ^ j
  | AField a -> "a:" ^ a
