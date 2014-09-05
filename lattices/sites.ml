module SiteSet = Lib.Set.Make(Site)

type t = SiteSet.t

let compare = SiteSet.compare

let equal = SiteSet.equal

let bot = SiteSet.empty

let join = SiteSet.union

let le = SiteSet.subset

let fold = SiteSet.fold

let from_list = SiteSet.from_list

let to_string = SiteSet.to_string Site.to_string
