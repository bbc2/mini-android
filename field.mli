(** Java and Android fields *)

(** Type of a field. *)
type t =
  | J of string (** Mini Java field *)
  | Pending (** Android [pending] field *)
  | Finished (** Android [finished] field *)
  | Listeners (** Android [listeners] field *)
  | State (** Android [state] field *)

(** Total ordering between field. *)
val compare : t -> t -> int

(** String representation of a field. *)
val to_string : t -> string
