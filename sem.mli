(** Abstract semantics *)

(** Transfer function for a program with one entry point. *)
val transfer : Api.t -> Cfg.t -> Local.t -> Local.t
