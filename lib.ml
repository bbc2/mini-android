module Set = struct
  module type S = sig
    include Set.S
    val from_list : elt list -> t
  end

  module Make = functor (Ord : Set.OrderedType) -> struct
    include Set.Make(Ord)

    let rec from_list l =
      match l with
      | [] -> empty
      | e::tl -> add e (from_list tl)
  end
end

module Map = struct
  module type S = sig
    include Map.S
    val from_list : (key * 'a) list -> 'a t
  end

  module Make = functor (Ord : Map.OrderedType) -> struct
    include Map.Make(Ord)

    let rec from_list l =
      match l with
      | [] -> empty
      | (k, v)::tl -> add k v (from_list tl)
  end
end
