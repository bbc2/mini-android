type t =
  | Any
  | AS of Site.t list

let equal = (=)

let bot = AS []

let join a1 a2 =
  if equal a1 a2 then
    a1
  else
    Any

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
