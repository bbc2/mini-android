(** Allocation sites *)

(** Type of an allocation site. *)
type t = int

(** Total ordering between sites. *)
val compare : t -> t -> int

(** String representation of a site. *)
val to_string : t -> string
