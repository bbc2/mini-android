(** Activity states *)

(** Type of an activity state. *)
type state =
  | Uninit (** Uninitialized *)
  | Init (** Initialized *)
  | Created
  | Active

(** Type of an abstract state. *)
type t =
  | Any (** Any state *)
  | State of state (** Exact state *)
  | None (** Undefined *)

(** Total ordering on abstract states. *)
val compare : t -> t -> int

(** Test whether two abstract states are equal. *)
val equal : t -> t -> bool

(** Bottom. *)
val bot : t

(** Join of two abstract states. *)
val join : t -> t -> t

(** Build an abstract state from a state. *)
val from_state : state -> t

(** String representation of an abstract state. *)
val to_string : t -> string
