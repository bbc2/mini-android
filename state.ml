type state =
  | Uninit
  | Init
  | Created
  | Active

module StateSet = Lib.Set.Make(struct type t = state let compare = compare end)

type t = StateSet.t

let compare = StateSet.compare

let equal = StateSet.equal

let bot = StateSet.empty

let join = StateSet.union

let fold = StateSet.fold

let from_list = StateSet.from_list

let string_of_state s =
  match s with
  | Uninit -> "Uninit"
  | Init -> "Init"
  | Created -> "Created"
  | Active -> "Active"

let to_string ss =
  let append_string state s =
    Printf.sprintf "%s%s%s" s (if s = "" then "" else ", ") (string_of_state state) in
  Printf.sprintf "{%s}" (StateSet.fold append_string ss "")
