module ObjectMap = Lib.Map.Make(Field)

type t = Value.t ObjectMap.t

let equal = ObjectMap.equal Value.equal

let bot = ObjectMap.empty

let join o1 o2 =
  let union _ option_v1 option_v2 =
    match (option_v1, option_v2) with
    | (None, None) -> None
    | (Some v1, None) -> Some v1
    | (None, Some v2) -> Some v2
    | (Some v1, Some v2) -> Some (Value.join v1 v2) in
  ObjectMap.merge union o1 o2

let get o k =
  try
    ObjectMap.find k o
  with Not_found -> Value.bot

let from_list = ObjectMap.from_list

let to_string o =
  let append_string (k : Field.t) (v : Value.t) s =
    s ^ (if s = "" then "" else ", ") ^ (Field.to_string k) ^ " -> " ^ (Value.to_string v) in
  "[" ^ (ObjectMap.fold append_string o "") ^ "]"
