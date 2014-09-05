module Value = struct
  type t =
    | Bot
    | String of Str.t
    | Sites of Sites.t
    | Top

  let compare v1 v2 =
    match (v1, v2) with
    | (Sites ss1, Sites ss2) -> Sites.compare ss1 ss2
    | (String s1, String s2) -> Str.compare s1 s2
    | (Bot, _) | (String _, _) | (Sites _, _) | (Top, _) -> Pervasives.compare v1 v2

  let bot = Bot

  let join v1 v2 =
    match (v1, v2) with
    | (_, Bot) -> v1
    | (Bot, _) -> v2
    | (Sites ss1, Sites ss2) -> Sites (Sites.join ss1 ss2)
    | (String s1, String s2) -> String (Str.join s1 s2)
    | (Sites _, _) | (String _, _)
    | (Top, _) -> Top

  let get_str s =
    match s with
    | String s -> s
    | _ -> Str.bot

  let get_sites v =
    match v with
    | Sites ss -> ss
    | _ -> Sites.bot

  let to_string v =
    match v with
    | Bot -> "Bot"
    | String s -> Str.to_string s
    | Sites ss -> Sites.to_string ss
    | Top -> "Top"
end

include Lattice.Extend(Value)
include Value
