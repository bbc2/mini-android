(** Abstract heap *)

include Lattice.S

(** Join the value associated with a site and a field with a new value to
    update a heap. *)
val add_field : t -> Site.t -> string-> Value.t -> t

(** Set the value associated with a site and a field in a heap. *)
val set_field : t -> Site.t -> string -> Value.t -> t

(** Get the value associated with a site and a field in a heap. *)
val get_field : t -> Site.t -> string -> Value.t

(** Join the value associated with a site to update a heap. *)
val add : t -> Site.t -> Aobject.t -> t

(** Set the object associated with a site in a heap. *)
val set : t -> Site.t -> Aobject.t -> t

(** Get the object associated with a site in a heap. *)
val get : t -> Site.t -> Aobject.t

(** Fold on a heap. *)
val fold : (Site.t -> Aobject.t -> 'a -> 'a) -> t -> 'a -> 'a

(** [filter p h] returns the map with all the bindings in [h] that satisfy
    predicate p. *)
val filter : (Site.t -> Aobject.t -> bool) -> t -> t

(** Build a heap from an association list. *)
val from_list : (Site.t * Aobject.t) list -> t

(** String representation of a heap. *)
val to_string : t -> string
