type var = string

module LocalMap = Map.Make(struct type t = var let compare = compare end)

type t = Value.t LocalMap.t

let to_string l =
  let append_string (k : var) (v : Value.t) s =
    s ^ "(" ^ k ^ " -> " ^ (Value.to_string v) ^ ")" in
  LocalMap.fold append_string l ""
