module As = struct
  type t =
    | Bot
    | Exact of Site.t list
    | Top

  let compare a1 a2 =
    match (a1, a2) with
    | (Exact al1, Exact al2) -> Lib.list_compare Site.compare al1 al2
    | (Bot, _) | (Exact _, _) | (Top, _) -> Pervasives.compare a1 a2
  
  let equal a1 a2 =
    compare a1 a2 = 0

  let bot = Bot

  let join a1 a2 =
    match (a1, a2) with
    | (_, Bot) -> a1
    | (Bot, _) -> a2
    | (Exact _, Exact _) -> if equal a1 a2 then a1 else Top
    | (Top, _) | (_, Top) -> Top

  let push a s =
    match a with
    | Bot -> Exact [s]
    | Exact al ->
      if List.mem s al then
        Top (* potentially infinite stack *)
      else
        Exact (s :: al)
    | Top -> Top

  let from_list = List.fold_left push Bot

  let to_string a =
    match a with
    | Bot -> "Bot"
    | Exact al ->
      let al_str = List.fold_left
          (fun s o -> s ^ (if s = "" then "" else "; ") ^ (Site.to_string o))
          "" al in
      "[" ^ al_str ^ "]"
    | Top -> "Top"
end

include Lattice.Extend(As)
include As
