(** Abstract values *)

(** Type of an abstract value. *)
type t =
  | None (** No value defined *)
  | String of string (** Maybe a string *)
  | Sites of Sites.t (** Potential sites *)
  | Pending of Pending.t (** Potential pending stacks *)
  | Any (** Anything *)

(** Tests whether two values are equal. *)
val equal : t -> t -> bool

(** Undefined. *)
val bot : t

(** Join of two values. *)
val join : t -> t -> t

(** Get the set of sites a value can represent. *)
val get_sites : t -> Sites.t

(** Output a string representation of a value. *)
val to_string : t -> string
