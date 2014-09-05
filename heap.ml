module Heap = struct
  module HeapMap = Lib.Map.Make(Site)

  type t = Aobject.t HeapMap.t

  let compare = HeapMap.compare Aobject.compare

  let equal = HeapMap.equal Aobject.equal

  let bot = HeapMap.empty

  let join h1 h2 =
    let union _ option_o1 option_o2 =
      match (option_o1, option_o2) with
      | (None, None) -> None
      | (Some o1, None) -> Some o1
      | (None, Some o2) -> Some o2
      | (Some o1, Some o2) -> Some (Aobject.join o1 o2) in
    HeapMap.merge union h1 h2

  let add h s o =
    join h (HeapMap.singleton s o)

  let set h s o =
    HeapMap.add s o h

  let add_field h s f v =
    join h (HeapMap.singleton s (Object.from_list [(f, v)], Arecord.bot))

  let get h s =
    try
      HeapMap.find s h
    with Not_found -> Aobject.bot

  let set_field h s f v =
    let (o, _) = get h s in
    HeapMap.add s (Object.set o f v, Arecord.bot) h

  let get_field h s f =
    let (o, _) = get h s in
    Object.get o f

  let fold = HeapMap.fold

  let filter = HeapMap.filter

  let from_list = HeapMap.from_list

  let to_string = HeapMap.to_string Site.to_string Aobject.to_string
end

include Lattice.Extend(Heap)
include Heap
