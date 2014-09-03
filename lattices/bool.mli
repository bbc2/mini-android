(** Abstract boolean lattice *)

(** Type of a boolean. *)
type t =
  | Bot
  | True
  | False
  | Top

include Lattice.S with type t := t

(** String representation of a boolean. *)
val to_string : t -> string
