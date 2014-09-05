(** Android fields *)

(** Type of an Android record. *)
type t = {
  state : State.t; (** [state] field *)
  pending : Pending.t; (** [pending] field *)
  finished : Bool.t; (** [finished] field *)
  listeners : Sites.t (** [listeners] field *)
}

include Lattice.S with type t := t

val get_state : t -> State.t

val get_pending : t -> Pending.t

val get_finished : t -> Bool.t

val get_listeners : t -> Sites.t

val set_state : t -> State.t -> t

val set_pending : t -> Pending.t -> t

val set_finished : t -> Bool.t -> t

val set_listeners : t -> Sites.t -> t

(** Same as [set_state] but join instead of overriding. *)
val add_state : t -> State.t -> t

(** Same as [set_pending] but join instead of overriding. *)
val add_pending : t -> Pending.t -> t

(** Same as [set_finished] but join instead of overriding. *)
val add_finished : t -> Bool.t -> t

(** Same as [set_listeners] but join instead of overriding. *)
val add_listeners : t -> Sites.t -> t

(** String representation of a record. *)
val to_string : t -> string
