(** Abstract environments *)

(** Type of an abstract environment. *)
type t

(** Type of a variable name. *)
type var = string

(** Test if two environments are equal. *)
val equal : t -> t -> bool

(** Empty environment, with all variables having [Value.bot] as abstract value. *)
val bot : t

(** Join of two environments. *)
val join : t -> t -> t

(** Get abstract value for a specific variable in the provided environment. *)
val get : t -> var -> Value.t

(** Build an enviromnent from an association list. *)
val from_list : (var * Value.t) list -> t

(** String representation of an environment. *)
val to_string : t -> string
