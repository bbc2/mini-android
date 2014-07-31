(** Allocation sites *)

(** Type of an allocation site. *)
type t = int

(** Total ordering between sites. *)
val compare : t -> t -> int

(** Output a string representation of a site. *)
val to_string : t -> string
