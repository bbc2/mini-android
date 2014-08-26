(** Call instances *)

(** Type of a call. *)
type t = Site.t * string * Value.t list

(** Total ordering on calls. *)
val compare : t -> t -> int

(** String representation of a call. *)
val to_string : t -> string
