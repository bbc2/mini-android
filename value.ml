type t =
  | None
  | Sites of Sites.t

let equal v1 v2 =
  match (v1, v2) with
  | (Sites ss1, Sites ss2) -> Sites.equal ss1 ss2
  | _ -> v1 = v2

let bot = None

let join v1 v2 =
  match (v1, v2) with
  | (_, None) -> v1
  | (None, _) -> v2
  | (Sites ss1, Sites ss2) -> Sites (Sites.join ss1 ss2)

let get_sites v =
  match v with
  | Sites ss -> ss
  | _ -> Sites.bot

let from_list l =
  Sites (Sites.from_list l)

let to_string v =
  match v with
  | Sites ss -> Sites.to_string ss
  | None -> "None"
