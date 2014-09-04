(** Abstract values *)

(** Type of an abstract value. *)
type t =
  | Bot (** No value defined *)
  | String of Str.t (** Potential string *)
  | Sites of Sites.t (** Potential sites *)
  | Top (** Anything *)

include Lattice.S with type t := t

(** Get the string a value can represent. *)
val get_str : t -> Str.t

(** Get the set of sites a value can represent. *)
val get_sites : t -> Sites.t

(** String representation of a value. *)
val to_string : t -> string
