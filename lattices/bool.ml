module Bool = struct
  type t =
    | Bot
    | True
    | False
    | Top

  let bot = Bot

  let compare = Pervasives.compare

  let join f1 f2 =
    match (f1, f2) with
    | (Bot, v) | (v, Bot) -> v
    | (True, True) | (False, False) -> f1
    | (True, False) | (False, True) | (Top, _) | (_, Top) -> Top

  let to_string f =
    match f with
    | Bot -> "Bot"
    | True -> "True"
    | False -> "False"
    | Top -> "Top"
end

include Lattice.Extend(Bool)
include Bool
