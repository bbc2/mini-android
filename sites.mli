(** Sets of sites *)

(** Type of a set of sites. *)
type t

(** Tests whether two sets of sites are equal. *)
val equal : t -> t -> bool

(** Empty set. *)
val bot : t

(** Join of two sets of sites. *)
val join : t -> t -> t

(** Build data from a set of sites. *)
val fold : (Site.t -> 'a -> 'a) -> t -> 'a -> 'a

(** Build set of sites from a list. *)
val from_list : Site.t list -> t

(** Output a string representation of an environment. *)
val to_string : t -> string
