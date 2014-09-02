type t =
  | Bot
  | True
  | False
  | Top

let bot = Bot

let compare = compare

let equal f1 f2 =
  compare f1 f2 = 0

let join f1 f2 =
  match (f1, f2) with
  | (Bot, v) | (v, Bot) -> v
  | (True, True) | (False, False) -> f1
  | (True, False) | (False, True) | (Top, _) | (_, Top) -> Top

let le f1 f2 =
  equal (join f1 f2) f2

let to_string f =
  match f with
  | Bot -> "Bot"
  | True -> "True"
  | False -> "False"
  | Top -> "Top"
