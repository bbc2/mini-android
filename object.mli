(** Abstract objects *)

(** Type of an abstract object. *)
type t

(** Total ordering on objects. *)
val compare : t -> t -> int

(** Test whether two objects are equal. *)
val equal : t -> t -> bool

(** Empty object. *)
val bot : t

(** Join of two objects. *)
val join : t -> t -> t

(** Set the value associated with a field in an object. *)
val set : t -> Field.t -> Value.t -> t

(** Get the value associated with a field in an object. *)
val get : t -> Field.t -> Value.t

(** [filter p o] returns the map with all the bindings in [o] that satisfy
    predicate p. *)
val filter : (Field.t -> Value.t -> bool) -> t -> t

(** Fold on an object. *)
val fold : (Field.t -> Value.t -> 'a -> 'a) -> t -> 'a -> 'a

(** Build an object from an association list. *)
val from_list : (Field.t * Value.t) list -> t

(** String representation of an object. *)
val to_string : t -> string
