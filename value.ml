module SiteSet = Set.Make(struct type t = Site.t let compare = compare end)

type t =
  | Sites of SiteSet.t

let rec siteset_from_list l =
  match l with
  | [] -> SiteSet.empty
  | s::tl -> SiteSet.add s (siteset_from_list tl)

let from_list l =
  Sites (siteset_from_list l)

let to_string v =
  match v with
  | Sites siteset ->
    let append_string site s =
      s ^ (if s = "" then "" else ", ") ^ Site.to_string site in
    "{" ^ (SiteSet.fold append_string siteset "") ^ "}"
