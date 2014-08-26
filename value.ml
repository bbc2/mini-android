type t =
  | None
  | String of string
  | Sites of Sites.t
  | Pending of Pending.t
  | Finished of Finished.t
  | State of State.t
  | Any

let compare v1 v2 =
  match (v1, v2) with
  | (Sites ss1, Sites ss2) -> Sites.compare ss1 ss2
  | (Pending p1, Pending p2) -> Pending.compare p1 p2
  | (State s1, State s2) -> State.compare s1 s2
  | _ -> compare v1 v2

let equal v1 v2 =
  compare v1 v2 = 0

let bot = None

let join v1 v2 =
  match (v1, v2) with
  | (_, None) -> v1
  | (None, _) -> v2
  | (Sites ss1, Sites ss2) -> Sites (Sites.join ss1 ss2)
  | (String s1, String s2) -> if s1 = s2 then String s1 else Any
  | (Pending p1, Pending p2) -> Pending (Pending.join p1 p2)
  | (State s1, State s2) -> State (State.join s1 s2)
  | (Finished f1, Finished f2) -> Finished (Finished.join f1 f2)
  | (Sites _, _) | (String _, _) | (Pending _, _)
  | (State _, _) | (Finished _, _)
  | (Any, _) | (_, Any) -> Any

let get_sites v =
  match v with
  | Sites ss -> ss
  | _ -> Sites.bot

let get_finished v =
  match v with
  | Finished f -> f
  | _ -> Finished.bot

let get_pending v =
  match v with
  | Pending p -> p
  | _ -> Pending.bot

let get_state v =
  match v with
  | State s -> s
  | _ -> State.bot

let to_string v =
  match v with
  | None -> "None"
  | String s -> "\"" ^ s ^ "\""
  | Sites ss -> Sites.to_string ss
  | Pending p -> Pending.to_string p
  | Finished f -> Finished.to_string f
  | State s -> State.to_string s
  | Any -> "Any"
