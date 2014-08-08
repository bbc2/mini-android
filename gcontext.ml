module GMap = Lib.Map.Make(Context)

type t = Global.t GMap.t

let equal = GMap.equal Global.equal

let join gc1 gc2 =
  let union _ option_g1 option_g2 =
    match (option_g1, option_g2) with
    | (None, None) -> None
    | (Some g1, None) -> Some g1
    | (None, Some g2) -> Some g2
    | (Some g1, Some g2) -> Some (Global.join g1 g2) in
  GMap.merge union gc1 gc2

let add gc c g =
  join gc (GMap.singleton c g)

let fold = GMap.fold

let from_list = GMap.from_list

let to_string = GMap.to_string Context.to_string Global.to_string
