(** Allocation sites *)

(** Type of an allocation site. *)
type t

(** Total ordering between sites. *)
val compare : t -> t -> int

(** Build a site from a class name and a label. *)
val make : string -> int -> t

(** Get the class a site instanciates. *)
val get_class : t -> string

(** String representation of a site. *)
val to_string : t -> string
