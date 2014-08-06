(** G-lattice *)

(** Type of a G-lattice. *)
type t

(** Test whether two G-lattices are equal. *)
val equal : t -> t -> bool

(** Join of two G-lattices. *)
val join : t -> t -> t

(** Join the global state associated with a context and global state to update
    a G-lattice. *)
val add : t -> Context.t -> Global.t -> t

(** Build data from a G-lattice. *)
val fold : (Context.t -> Global.t -> 'a -> 'a) -> t -> 'a -> 'a

(** Build a G-lattice from an association list. *)
val from_list : (Context.t * Global.t) list -> t

(** String representation of a G-lattice. *)
val to_string : t -> string
