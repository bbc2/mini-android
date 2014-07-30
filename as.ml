type t =
  | Any
  | AS of Site.t list
  | None

let equal = (=)

let bot = None

let join a1 a2 =
  match (a1, a2) with
  | (None, _) -> a2
  | (_, None) -> a1
  | _ ->
    if equal a1 a2 then
      a1
    else
      Any

let to_string a =
  match a with
  | Any -> "Any"
  | AS al ->
    let al_str = List.fold_left
        (fun s o -> s ^ (if s = "" then "" else "; ") ^ (Site.to_string o))
        "" al in
    "[" ^ al_str ^ "]"
  | None -> "None"
