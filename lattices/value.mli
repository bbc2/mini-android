(** Abstract values *)

(** Type of an abstract value. *)
type t =
  | None (** No value defined *)
  | String of Str.t (** Potential string *)
  | Sites of Sites.t (** Potential sites *)
  | Any (** Anything *)

(** Total ordering on values. *)
val compare : t -> t -> int

(** Test whether two values are equal. *)
val equal : t -> t -> bool

(** Undefined value. *)
val bot : t

(** Join of two values. *)
val join : t -> t -> t

(** Get the string a value can represent. *)
val get_str : t -> Str.t

(** Get the set of sites a value can represent. *)
val get_sites : t -> Sites.t

(** String representation of a value. *)
val to_string : t -> string