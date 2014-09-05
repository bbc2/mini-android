(** Local state *)

(** Type of a local abstract state. *)
type t = Global.t * Env.t

include Lattice.S with type t := t

(** Get potential values for a field access in the given state. *)
val get_field : t -> Env.var -> string -> Value.t

(** String representation of a local state. *)
val to_string : t -> string
