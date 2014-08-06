module SiteSet = Lib.Set.Make(Site)

type t = SiteSet.t

let compare = SiteSet.compare

let equal = SiteSet.equal

let bot = SiteSet.empty

let join = SiteSet.union

let fold = SiteSet.fold

let rec from_list = SiteSet.from_list

let to_string ss =
  let append_string site s =
    s ^ (if s = "" then "" else ", ") ^ Site.to_string site in
  "{" ^ (fold append_string ss "") ^ "}"
