(** Android [pending] attribute *)

(** Type of an abstract pending stack. *)
type t

(** Empty stack set. *)
val bot : t

(** Join of two stack sets. *)
val join : t -> t -> t

(** Build a stack set from a stack. *)
val from_stack : string list -> t

(** Push an activity on a pending stack. *)
val push : t -> string -> t

(** Output a string representation of a stack set. *)
val to_string : t -> string
