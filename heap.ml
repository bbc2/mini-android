module HeapMap = Map.Make(Site)

type t = Object.t HeapMap.t

let equal = HeapMap.equal Object.equal

let bot = HeapMap.empty

let red h =
  if HeapMap.exists (fun _ v -> v = Object.bot) h then
    bot
  else
    h

let join h1 h2 =
  let union _ option_o1 option_o2 =
    match (option_o1, option_o2) with
    | (None, None) -> None
    | (Some o1, None) -> Some o1
    | (None, Some o2) -> Some o2
    | (Some o1, Some o2) -> Some (Object.join o1 o2) in
  HeapMap.merge union h1 h2

let add_field h s f v =
  join h (HeapMap.singleton s (Object.from_list [(f, v)]))

let get h k =
  try
    HeapMap.find k h
  with Not_found -> Object.bot

let get_field h v f =
  let ss = Value.get_sites v in
  let merge s v =
    Value.join v (Object.get (get h s) (Field.JField f)) in
  Sites.fold merge ss Value.bot

let rec from_list l =
  match l with
  | [] -> HeapMap.empty
  | (k, v)::tl -> HeapMap.add k v (from_list tl)

let to_string h =
  let append_string (k : Site.t) (v : Object.t) s =
    s ^ (if s = "" then "" else ", ") ^ (string_of_int k) ^ " -> " ^ (Object.to_string v) in
  "[" ^ (HeapMap.fold append_string h "") ^ "]"
