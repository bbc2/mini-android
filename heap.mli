(** Abstract heap *)

(** Type of an abstract heap. *)
type t

(** Total ordering on heaps. *)
val compare : t -> t -> int

(** Test whether two heaps are equal. *)
val equal : t -> t -> bool

(** Empty heap. *)
val bot : t

(** Join of two heaps. *)
val join : t -> t -> t

(** Join the value associated with a site and a field with a new value to
    update a heap. *)
val add_field : t -> Site.t -> Field.t -> Value.t -> t

(** Set the value associated with a site and a field in a heap. *)
val set_field : t -> Site.t -> Field.t -> Value.t -> t

(** Get the value associated with a site and a field in a heap. *)
val get_field : t -> Site.t -> Field.t -> Value.t

(** Set the object associated with a site in a heap. *)
val set : t -> Site.t -> Object.t -> t

(** Get the object associated with a site in a heap. *)
val get : t -> Site.t -> Object.t

(** Fold on a heap. *)
val fold : (Site.t -> Object.t -> 'a -> 'a) -> t -> 'a -> 'a

(** [filter p h] returns the map with all the bindings in [h] that satisfy
    predicate p. *)
val filter : (Site.t -> Object.t -> bool) -> t -> t

(** Build a heap from an association list. *)
val from_list : (Site.t * Object.t) list -> t

(** String representation of a heap. *)
val to_string : t -> string
