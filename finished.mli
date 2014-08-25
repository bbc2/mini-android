(** Android [finished] field *)

(** Type of an abstract [finished] value. *)
type t =
  | None (** Undefined. *)
  | True
  | False
  | Any

(** Total ordering on [finished] value. *)
val compare : t -> t -> int

(** Test whetehr two [finished] values are equal. *)
val equal : t -> t -> bool

(** Undefined [finished] field. *)
val bot : t

(** Join of two [finished] values. *)
val join : t -> t -> t

(** Less or equal relation on [finished] values. *)
val le : t -> t -> bool

(** String representation of a [finished] value. *)
val to_string : t -> string
