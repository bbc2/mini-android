(** Lattices *)

module type Base = sig
  (** Type of elements. *)
  type t

  (** Total ordering on elements. *)
  val compare : t -> t -> int

  (** Join of two elements. *)
  val join : t -> t -> t

  (** Bottom element. *)
  val bot : t
end

module type S = sig
  include Base

  (** Test whether two elements are equal. *)
  val equal : t -> t -> bool

  (** Partial order on elements.  [le x y] returns [true] iff [x] is less than
      or equal to [y] with regards to this partial order. *)
  val le : t -> t -> bool
end

(** Derive [equal] and [le] functions from a [Base] *)
module Extend : functor (B : Base) -> (S with type t := B.t)
