(** Global state *)

(** Type of a global state. *)
type t = Heap.t * As.t

(** Total ordering on global states. *)
val compare : t -> t -> int

(** Test whether two global states are equal. *)
val equal : t -> t -> bool

(** Global state with empty heap and empty activity stack. *)
val bot : t

(** Join of two global states. *)
val join : t -> t -> t

(** String representation of a global state. *)
val to_string : t -> string
