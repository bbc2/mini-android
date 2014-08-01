(** Abstract objects *)

(** Type of an abstract object. *)
type t

(** Test whether two objects are equal. *)
val equal : t -> t -> bool

(** Empty object. *)
val bot : t

(** Join of two objects. *)
val join : t -> t -> t

(** Get the value associated with a field in an object. *)
val get : t -> Field.t -> Value.t

(** Build an object from an association list. *)
val from_list : (Field.t * Value.t) list -> t

(** String representation of an object. *)
val to_string : t -> string
