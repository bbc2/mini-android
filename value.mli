(** Abstract values *)

(** Type of an abstract value. *)
type t =
  | None (** No value defined *)
  | String of string (** Maybe a string *)
  | Sites of Sites.t (** Potential sites *)
  | Pending of Pending.t (** Potential pending stacks *)
  | Finished of Bool.t (** Potential finished field *)
  | State of State.t (** Potential states *)
  | Any (** Anything *)

(** Total ordering on values. *)
val compare : t -> t -> int

(** Test whether two values are equal. *)
val equal : t -> t -> bool

(** Undefined value. *)
val bot : t

(** Join of two values. *)
val join : t -> t -> t

(** Get the set of sites a value can represent. *)
val get_sites : t -> Sites.t

(** Get the abstract [pending] field a value can represent. *)
val get_pending : t -> Pending.t

(** Get the abstract [finished] field a value can represent. *)
val get_finished : t -> Bool.t

(** Get the abstract state a value can represent. *)
val get_state : t -> State.t

(** String representation of a value. *)
val to_string : t -> string
