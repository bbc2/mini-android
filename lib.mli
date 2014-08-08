(** Library *)

module Set : sig
  module type S = sig
    (** Set module from the standard library.
        @see < http://caml.inria.fr/pub/docs/manual-ocaml/libref/Set.S.html > [Set.S] (caml.inria.fr) *)
    include Set.S

    (** Build a set from a list. *)
    val from_list : elt list -> t

    (** String reprensetation of a map given a [to_string] function for elements. *)
    val to_string : (elt -> string) -> t -> string
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

    (** String representation of a map given [to_string] functions for keys and
        values. *)
    val to_string : (key -> string) -> ('a -> string) -> 'a t -> string
  end

  module Make (Ord : Map.OrderedType) : S with type key = Ord.t
end
