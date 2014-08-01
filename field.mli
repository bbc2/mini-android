(** Java and Android fields *)

(** Type of a field. *)
type t =
  | JField of string (** Java field *)
  | AField of string (** Android field *)

(** Total ordering between field. *)
val compare : t -> t -> int

(** Output a string representation of a field. *)
val to_string : t -> string
