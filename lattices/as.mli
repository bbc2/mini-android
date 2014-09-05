(** Android activity stack *)

(** Type of an activity stack. *)
type t =
  | Bot (** Undefined *)
  | Exact of Site.t list (** Stack without duplicates *)
  | Top (** Any stack *)

include Lattice.S with type t := t

(** Push an activity on a stack. *)
val push : t -> Site.t -> t

(** Build an activity stack from a list. *)
val from_list : Site.t list -> t

(** String representation of an activity stack. *)
val to_string : t -> string
