(** Global state *)

(** Type of a global state. *)
type t = Heap.t * As.t

include Lattice.S with type t := t

(** String representation of a global state. *)
val to_string : t -> string
