type var = string

module EnvMap = Lib.Map.Make(struct type t = var let compare = compare end)

type t = Value.t EnvMap.t

let equal = EnvMap.equal Value.equal

let bot = EnvMap.empty

let join e1 e2 =
  let union _ option_v1 option_v2 =
    match (option_v1, option_v2) with
    | (None, None) -> None
    | (Some v1, None) -> Some v1
    | (None, Some v2) -> Some v2
    | (Some v1, Some v2) -> Some (Value.join v1 v2) in
  EnvMap.merge union e1 e2

let get e k =
  try
    EnvMap.find k e
  with Not_found -> Value.bot

let from_list = EnvMap.from_list

let to_string e =
  let append_string (k : var) (v : Value.t) s =
    s ^ (if s = "" then "" else ", ") ^ k ^ " -> " ^ (Value.to_string v) in
  "[" ^ (EnvMap.fold append_string e "") ^ "]"
