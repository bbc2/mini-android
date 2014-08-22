(** Android semantic edges *)

(** Type of an edge. *)
type t = Call.t * Context.t

(** Total ordering on edges. *)
val compare : t -> t -> int

(** String representation of an edge. *)
val to_string : t -> string
