(** Sets of sites *)

(** Type of a set of sites. *)
type t

include Lattice.S with type t := t

(** Build data from a set of sites. *)
val fold : (Site.t -> 'a -> 'a) -> t -> 'a -> 'a

(** Build set of sites from a list. *)
val from_list : Site.t list -> t

(** String representation of an environment. *)
val to_string : t -> string
