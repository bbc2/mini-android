(** Java and Android fields *)

(** Type of a Mini Java field. *)
type t = string

(** Total ordering between field. *)
val compare : t -> t -> int

(** String representation of a field. *)
val to_string : t -> string
