type t =
  | J of string
  | Pending
  | Finished
  | State

let compare = compare

let to_string f =
  match f with
  | J s -> s
  | Pending -> "~pending"
  | Finished -> "~finished"
  | State -> "~state"
