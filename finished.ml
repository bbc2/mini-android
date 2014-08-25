type t =
  | None
  | True
  | False
  | Any

let bot = None

let compare = compare

let equal f1 f2 =
  compare f1 f2 = 0

let join f1 f2 =
  match (f1, f2) with
  | (None, v) | (v, None) -> v
  | (True, True) | (False, False) -> f1
  | (True, False) | (False, True) | (Any, _) | (_, Any) -> Any

let le f1 f2 =
  equal (join f1 f2) f2

let to_string f =
  match f with
  | None -> "None"
  | True -> "True"
  | False -> "False"
  | Any -> "Any"
