(** Abstract string *)

include Lattice.S

(** Fold on potential strings. *)
val fold : (string -> 'a -> 'a) -> t -> 'a -> 'a

(** Build a string from a list of potential concrete strings. *)
val from_list : string list -> t

(** String representation of an abstract string. *)
val to_string : t -> string
