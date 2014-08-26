type t =
  | Call of Call.t * (Global.t -> Global.t)
  | Back of Site.t

let compare a1 a2 =
  match (a1, a2) with
  | (Call (c1, _), Call (c2, _)) -> Call.compare c1 c2
  | (Back s1, Back s2) -> Site.compare s1 s2
  | (Call _, Back _) -> -1
  | (Back _, Call _) -> 1

let to_string a =
  match a with
  | Call (c, _) -> Call.to_string c
  | Back s -> "~back"
