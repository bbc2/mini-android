exception Method_not_found

exception Wrong_args of int

type t = string -> string -> string list -> Local.t -> Local.t

val transfer_exn : string -> string -> string list -> Local.t -> Local.t
