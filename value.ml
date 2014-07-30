module SiteSet = Set.Make(struct type t = Site.t let compare = compare end)

type t =
  | None
  | Sites of SiteSet.t

let equal v1 v2 =
  match (v1, v2) with
  | (Sites ss1, Sites ss2) -> SiteSet.equal ss1 ss2
  | _ -> v1 = v2

let bot = None

let join v1 v2 =
  match (v1, v2) with
  | (_, None) -> v1
  | (None, _) -> v2
  | (Sites ss1, Sites ss2) -> Sites (SiteSet.union ss1 ss2)

let rec siteset_from_list l =
  match l with
  | [] -> SiteSet.empty
  | ss::tl -> SiteSet.add ss (siteset_from_list tl)

let from_list l =
  Sites (siteset_from_list l)

let to_string v =
  match v with
  | Sites siteset ->
    let append_string site s =
      s ^ (if s = "" then "" else ", ") ^ Site.to_string site in
    "{" ^ (SiteSet.fold append_string siteset "") ^ "}"
  | None -> "None"
