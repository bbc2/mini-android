(** Abstract boolean lattice *)

(** Type of a boolean. *)
type t =
  | Bot
  | True
  | False
  | Top

(** Total ordering on booleans. *)
val compare : t -> t -> int

(** Test whether two booleans are equal. *)
val equal : t -> t -> bool

(** Bottom boolean *)
val bot : t

(** Join of two booleans. *)
val join : t -> t -> t

(** Less or equal relation on booleans. *)
val le : t -> t -> bool

(** String representation of a boolean. *)
val to_string : t -> string
