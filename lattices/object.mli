(** Abstract objects *)

include Lattice.S

(** Set the value associated with a field in an object. *)
val set : t -> string -> Value.t -> t

(** Get the value associated with a field in an object. *)
val get : t -> string -> Value.t

(** [filter p o] returns the map with all the bindings in [o] that satisfy
    predicate p. *)
val filter : (string -> Value.t -> bool) -> t -> t

(** Fold on an object. *)
val fold : (string -> Value.t -> 'a -> 'a) -> t -> 'a -> 'a

(** Build an object from an association list. *)
val from_list : (string * Value.t) list -> t

(** String representation of an object. *)
val to_string : t -> string
