(** Abstract values *)

(** Type of an abstract value. *)
type t =
  | None (** No value defined *)
  | String of string (** Maybe a string *)
  | Sites of Sites.t (** Potential sites *)
  | Pending of Pending.t (** Potential pending stacks *)
  | State of State.t (** Potential states *)
  | Any (** Anything *)

(** Test whether two values are equal. *)
val equal : t -> t -> bool

(** Undefined value. *)
val bot : t

(** Join of two values. *)
val join : t -> t -> t

(** Get the abstract state a value can represent. *)
val get_state : t -> State.t

(** Get the set of sites a value can represent. *)
val get_sites : t -> Sites.t

(** String representation of a value. *)
val to_string : t -> string
