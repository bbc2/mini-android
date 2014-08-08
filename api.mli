(** Android API methods *)

(** Exception raised by [transfer_exn] when a method does not exist. *)
exception Method_not_found

(** Exception raised by [transfer_exn] when the number of arguments is not the
    one expected by the API method. *)
exception Wrong_args of int

(** Type of an API. *)
type t = string -> string -> string list -> Local.t -> Local.t

(** The API itself. *)
val transfer_exn : t
