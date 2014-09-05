(** Android [state] attribute *)

(** Type of an activity state. *)
type state =
  | Uninit (** Uninitialized *)
  | Init (** Initialized *)
  | Created
  | Visible
  | Active
  | Stopped
  | Destroyed

include Lattice.S

(** Fold on states. *)
val fold : (state -> 'a -> 'a) -> t -> 'a -> 'a

(** Build an abstract state from a state. *)
val from_list : state list -> t

(** String representation of an abstract state. *)
val to_string : t -> string
