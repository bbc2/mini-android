(** Android [pending] attribute *)

include Lattice.S

(** Push an activity on a pending stack. *)
val add : t -> string -> t

(** Fold on a pending stack. *)
val fold : (string -> 'a -> 'a) -> t -> 'a -> 'a

(** Build a pending stack from a list of class names. *)
val from_list : string list -> t

(** String representation of a pending stack. *)
val to_string : t -> string
