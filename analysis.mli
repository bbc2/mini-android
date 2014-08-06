(** Generic analysis tools *)

(** Compute a fixpoint given an equality and a transfer function. *)
val fixpoint : ('a -> 'a -> bool) -> ('a -> 'a) -> 'a -> 'a
