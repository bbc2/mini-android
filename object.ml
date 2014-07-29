module ObjectMap = Map.Make(Field)

type t = Value.t ObjectMap.t
let compare = compare

let rec from_list l =
  match l with
  | [] -> ObjectMap.empty
  | (k, v)::tl -> ObjectMap.add k v (from_list tl)

let to_string o =
  let append_string (k : Field.t) (v : Value.t) s =
    s ^ (if s = "" then "" else ", ") ^ (Field.to_string k) ^ " -> " ^ (Value.to_string v) in
  "[" ^ (ObjectMap.fold append_string o "") ^ "]"
