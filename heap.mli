(** Abstract heap *)

(** Type of an abstract heap. *)
type t

(** Test whether two heaps are equal. *)
val equal : t -> t -> bool

(** Empty heap. *)
val bot : t

(** Join of two heaps. *)
val join : t -> t -> t

(** Join the value associated with a site and a field with a new value to
    update a heap. *)
val add_field : t -> Site.t -> Field.t -> Value.t -> t

(** Get the object associated with a site in a heap. *)
val get : t -> Site.t -> Object.t

(** Get the value associated with a site and a field in a heap. *)
val get_field : t -> Site.t -> Field.t -> Value.t

(** Build a heap from an association list. *)
val from_list : (Site.t * Object.t) list -> t

(** String representation of a heap. *)
val to_string : t -> string
