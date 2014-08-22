module GMap = Lib.Map.Make(Context)

type t = (Global.t * Nexts.t) GMap.t

(* The next set is not taken into account. *)
let equal gc1 gc2 =
  let global_equal v1 v2 =
    let (g1, _) = v1 in
    let (g2, _) = v2 in
    Global.equal g1 g2 in
  GMap.equal global_equal gc1 gc2

let join gc1 gc2 =
  let union _ option_gn1 option_gn2 =
    match (option_gn1, option_gn2) with
    | (None, None) -> None
    | (Some gn1, None) -> Some gn1
    | (None, Some gn2) -> Some gn2
    | (Some (g1, n1), Some (g2, n2)) -> Some (Global.join g1 g2, Nexts.join n1 n2) in
  GMap.merge union gc1 gc2

let add gc c (g, n) =
  join gc (GMap.singleton c (g, n))

let get gc c =
  try
    GMap.find c gc
  with Not_found -> (Global.bot, Nexts.bot)

let fold = GMap.fold

let from_list = GMap.from_list

let string_of_global_next gn =
  let (g, n) = gn in
  Printf.sprintf "(%s, %s)" (Global.to_string g) (Nexts.to_string n)

let to_string =
  GMap.to_string Context.to_string string_of_global_next
