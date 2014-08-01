(** Local state *)

(** Type of a local abstract state. *)
type t = Global.t * Env.t

(** Tests whether two environments are equal. *)
val equal : t -> t -> bool

(** Bottom. *)
val bot : t

(** Join of two local states. *)
val join : t -> t -> t

(** Get potential values for a field access in the given state. *)
val get_field : t -> Env.var -> Field.t -> Value.t

(** Output a string representation of a local state. *)
val to_string : t -> string
