module SiteSet = Set.Make(struct type t = Site.t let compare = compare end)

type t = SiteSet.t

let equal = SiteSet.equal

let bot = SiteSet.empty

let join = SiteSet.union

let fold = SiteSet.fold

let rec from_list l =
  match l with
  | [] -> SiteSet.empty
  | ss::tl -> SiteSet.add ss (from_list tl)

let to_string ss =
  let append_string site s =
    s ^ (if s = "" then "" else ", ") ^ Site.to_string site in
  "{" ^ (fold append_string ss "") ^ "}"
