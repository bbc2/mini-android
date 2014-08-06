type state =
  | Uninit
  | Init
  | Created
  | Active

type t =
  | Any
  | State of state
  | None

let compare = compare

let equal = (=)

let bot = None

let join s1 s2 =
  match (s1, s2) with
  | (_, None) -> s1
  | (None, _) -> s2
  | (State st1, State st2) ->
      if st1 = st2 then
        s1
      else
        Any
  | _ -> Any

let from_state s =
  State s

let string_of_state s =
  match s with
  | Uninit -> "Uninit"
  | Init -> "Init"
  | Created -> "Created"
  | Active -> "Active"

let to_string s =
  match s with
  | Any -> "Any"
  | State st -> string_of_state st
  | None -> "None"
