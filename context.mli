(** Contexts *)

(** Type of a context. *)
type t

(** Total ordering on contexts. *)
val compare : t -> t -> int

(** Determine what context a global state belongs to. *)
val from_global : Global.t -> t

(** String representation of a context. *)
val to_string : t -> string
