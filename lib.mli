(** Library *)

module Set : sig
  module type S = sig
    (** Set module from the standard library.
        @see < http://caml.inria.fr/pub/docs/manual-ocaml/libref/Set.S.html > [Set.S] (caml.inria.fr) *)
    include Set.S

    (** Build a set from a list. *)
    val from_list : elt list -> t
  end

  module Make (Ord : Set.OrderedType) : S with type elt = Ord.t
end

module Map : sig
  module type S = sig
    (** Map module from the standard library.
        @see < http://caml.inria.fr/pub/docs/manual-ocaml/libref/Map.S.html > [Map.S] (caml.inria.fr) *)
    include Map.S

    (** Build a map from an association list. *)
    val from_list : (key * 'a) list -> 'a t
  end

  module Make (Ord : Map.OrderedType) : S with type key = Ord.t
end
