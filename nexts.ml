module NextSet = Lib.Set.Make(Next)

type t = NextSet.t

let compare = NextSet.compare

let join = NextSet.union

let bot = NextSet.empty

let fold = NextSet.fold

let from_list = NextSet.from_list

let to_string = NextSet.to_string Next.to_string
