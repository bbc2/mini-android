(** Lattices *)

module type OrderedType = sig
  (** Type of comparable elements. *)
  type t

  (** Total ordering on elements. *)
  val compare : t -> t -> int
end

module type Base = sig
  (** Type of elements. *)
  type t

  include OrderedType with type t := t

  (** Test whether two elements are equal. *)
  val equal : t -> t -> bool

  (** Join of two elements. *)
  val join : t -> t -> t
end

module type S = sig
  (** Type of lattice elements. *)
  type t

  include Base with type t := t

  (** Bottom element. *)
  val bot : t

  (** Partial order on elements.  [le x y] returns [true] iff [x] is less than
      or equal to [y] with regards to this partial order. *)
  val le : t -> t -> bool
end
