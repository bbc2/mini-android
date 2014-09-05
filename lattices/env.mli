(** Abstract environments *)

include Lattice.S

(** Type of a variable name. *)
type var = string

(** Get abstract value for a specific variable in the provided environment. *)
val get : t -> var -> Value.t

(** Build an enviromnent from an association list. *)
val from_list : (var * Value.t) list -> t

(** String representation of an environment. *)
val to_string : t -> string
