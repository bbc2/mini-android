module SSet = Lib.Set.Make(String)

type t = SSet.t

let compare = SSet.compare

let equal = SSet.equal

let bot = SSet.empty

let join = SSet.union

let le = SSet.subset

let fold = SSet.fold

let from_list = SSet.from_list

let to_string = SSet.to_string (fun str -> Printf.sprintf "\"%s\"" str)
