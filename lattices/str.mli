(** Abstract string *)

(** Type of a string. *)
type t

(** Bottom string. *)
val bot : t

(** Total ordering on strings. *)
val compare : t -> t -> int

(** Test whether two strings are equal. *)
val equal : t -> t -> bool

(** Join of two strings. *)
val join : t -> t -> t

(** Fold on a string. *)
val fold : (string -> 'a -> 'a) -> t -> 'a -> 'a

(** Build a string from a list of potential concrete strings. *)
val from_list : string list -> t

(** String representation of an abstract string. *)
val to_string : t -> string
