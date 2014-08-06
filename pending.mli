(** Android [pending] attribute *)

(** Type of an abstract pending stack. *)
type t

(** Empty stack set. *)
val bot : t

(** Total ordering on stack sets. *)
val compare : t -> t -> int

(** Test whether two stack sets are equal. *)
val equal : t -> t -> bool

(** Join of two stack sets. *)
val join : t -> t -> t

(** Build a stack set from a stack. *)
val from_stack : string list -> t

(** Push an activity on a pending stack. *)
val push : t -> string -> t

(** String representation of a stack set. *)
val to_string : t -> string
