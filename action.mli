(** Android actions *)

(** Type of an Android action. *)
type t =
  | Call of Call.t * (Global.t -> Global.t)
  | Back of Site.t
  | New of string

(** Total ordering on actions. *)
val compare : t -> t -> int

(** String representation of an action. *)
val to_string : t -> string
