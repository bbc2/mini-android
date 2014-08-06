(** Android application *)

(** Type of an Android application. *)
type t

(** Manifest of an application. *)
type manifest

(** Classes of an application. *)
type classes

(** Methods of a class. *)
type methods

(** Build a manifest from a string. *)
val manifest_from_string : string -> manifest

(** Build a class from a list of methods. *)
val methods_from_list : (string * Cfg.t) list -> methods

(** Build a set of classes for an app from a list of classes. *)
val classes_from_list : (string * methods) list -> classes

(** Build an app from a manifest and classes. *)
val make : manifest -> classes -> t

(** Get CFG associated with a class and a method in an application. *)
val get_method : t -> string -> string -> Cfg.t
