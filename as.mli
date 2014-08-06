(** Android activity stack *)

(** Type of an activity stack. *)
type t =
  | Any (** Any stack *)
  | AS of Site.t list (** Exact stack *)
  | None (** Undefined *)

(** Test whether two activity stacks are equal. *)
val equal : t -> t -> bool

(** Empty stack. *)
val bot : t

(** Join of two activity stacks. *)
val join : t -> t -> t

(** Build an activity stack from a list. *)
val from_list : Site.t list -> t

(** String representation of an activity stack. *)
val to_string : t -> string
