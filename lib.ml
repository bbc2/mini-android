module Set = struct
  module type S = sig
    include Set.S
    val from_list : elt list -> t
    val to_string : (elt -> string) -> t -> string
  end

  module Make = functor (Ord : Set.OrderedType) -> struct
    include Set.Make(Ord)

    let rec from_list l =
      match l with
      | [] -> empty
      | e::tl -> add e (from_list tl)

    let to_string string_of_elt set =
      let append e s =
        Printf.sprintf "%s%s%s" s (if s = "" then "" else ", ") (string_of_elt e) in
      Printf.sprintf "{%s}" (fold append set "")
  end
end

module Map = struct
  module type S = sig
    include Map.S
    val from_list : (key * 'a) list -> 'a t
    val to_string : (key -> string) -> ('a -> string) -> 'a t -> string
  end

  module Make = functor (Ord : Map.OrderedType) -> struct
    include Map.Make(Ord)

    let rec from_list l =
      match l with
      | [] -> empty
      | (k, v)::tl -> add k v (from_list tl)

    let to_string string_of_key string_of_val map =
      let append k v s =
        Printf.sprintf "%s%s%s -> %s"
          s (if s = "" then "" else ", ") (string_of_key k) (string_of_val v) in
      Printf.sprintf "[%s]" (fold append map "")
  end
end

let rec list_compare compare l1 l2 =
  match (l1, l2) with
  | ([], []) -> 0
  | (_::_, []) -> 1
  | ([], _::_) -> -1
  | (h1::t1, h2::t2) ->
      let h = compare h1 h2 in
      if h = 0 then
        list_compare compare t1 t2
      else
        h
