(** Android [pending] attribute *)

(** Type of an abstract pending stack. *)
type t

(** Empty pending stack. *)
val bot : t

(** Total ordering on pending stacks. *)
val compare : t -> t -> int

(** Test whether two pending stacks are equal. *)
val equal : t -> t -> bool

(** Join of two pending stacks. *)
val join : t -> t -> t

(** Push an activity on a pending stack. *)
val add : t -> string -> t

(** Fold on a pending stack. *)
val fold : (string -> 'a -> 'a) -> t -> 'a -> 'a

(** Build a pending stack from a list of class names. *)
val from_list : string list -> t

(** String representation of a pending stack. *)
val to_string : t -> string
