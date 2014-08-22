(** Sets of [next] edges. *)

(** Type of a set of edges. *)
type t

(** Total ordering on set of edges. *)
val compare : t -> t -> int

(** Join of sets of edges. *)
val join : t -> t -> t

(** Empty set. *)
val bot : t

(** Fold on a set of edges. *)
val fold : (Next.t -> 'a -> 'a) -> t -> 'a -> 'a

(** Build a set of edges from a list. *)
val from_list : Next.t list -> t 

(** String representation of a set of edges. *)
val to_string : t -> string
