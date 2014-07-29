module HeapMap = Map.Make(Site)

let rec from_list l =
  match l with
  | [] -> HeapMap.empty
  | (k, v)::tl -> HeapMap.add k v (from_list tl)

type t = Object.t HeapMap.t

let to_string h =
  let append_string (k : Site.t) (v : Object.t) s =
    s ^ (if s = "" then "" else ", ") ^ (string_of_int k) ^ " -> " ^ (Object.to_string v) in
  "[" ^ (HeapMap.fold append_string h "") ^ "]"
