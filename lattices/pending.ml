module PSet = Lib.Set.Make(String)

type t = PSet.t

let compare = PSet.compare

let equal = PSet.equal

let bot = PSet.empty

let join = PSet.union

let le = PSet.subset

let add p c =
  PSet.add c p

let fold = PSet.fold

let from_list = PSet.from_list

let to_string = PSet.to_string (fun s -> s)
