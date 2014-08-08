type t =
  | J of string
  | Pending
  | State

let compare = compare

let to_string f =
  match f with
  | J s -> s
  | Pending -> "~pending"
  | State -> "~state"
