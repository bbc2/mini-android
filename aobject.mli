(** Android object *)

(** Type of an Android object.  It is an object augmented with an Android
    record. *)
type t = Object.t * Arecord.t

include Lattice.S with type t := t

(** String representation of an Android object. *)
val to_string : t -> string
