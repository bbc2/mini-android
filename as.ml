type t =
  | Any
  | AS of Site.t list
  | None

let compare = compare

let equal = (=)

let bot = None

let join a1 a2 =
  match (a1, a2) with
  | (_, None) -> a1
  | (None, _) -> a2
  | (AS al1, AS al2) ->
    if equal al1 al2 then
      a1
    else
      Any
  | (Any, _) | (_, Any) -> Any

let from_list l =
  AS l

let to_string a =
  match a with
  | Any -> "Any"
  | AS al ->
    let al_str = List.fold_left
        (fun s o -> s ^ (if s = "" then "" else "; ") ^ (Site.to_string o))
        "" al in
    "[" ^ al_str ^ "]"
  | None -> "None"
