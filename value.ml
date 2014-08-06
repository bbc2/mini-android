type t =
  | None
  | String of string
  | Sites of Sites.t
  | Pending of Pending.t
  | State of State.t
  | Any

let equal v1 v2 =
  match (v1, v2) with
  | (Sites ss1, Sites ss2) -> Sites.equal ss1 ss2
  | (Pending p1, Pending p2) -> Pending.equal p1 p2
  | (State s1, State s2) -> State.equal s1 s2
  | _ -> v1 = v2

let bot = None

let join v1 v2 =
  match (v1, v2) with
  | (_, None) -> v1
  | (None, _) -> v2
  | (Sites ss1, Sites ss2) -> Sites (Sites.join ss1 ss2)
  | (String s1, String s2) -> if s1 = s2 then String s1 else Any
  | (Pending p1, Pending p2) -> Pending (Pending.join p1 p2)
  | (State s1, State s2) -> State (State.join s1 s2)
  | _ -> Any

let get_state v =
  match v with
  | State s -> s
  | _ -> State.bot

let get_sites v =
  match v with
  | Sites ss -> ss
  | _ -> Sites.bot

let to_string v =
  match v with
  | None -> "None"
  | String s -> "\"" ^ s ^ "\""
  | Sites ss -> Sites.to_string ss
  | Pending p -> Pending.to_string p
  | State s -> State.to_string s
  | Any -> "Any"
