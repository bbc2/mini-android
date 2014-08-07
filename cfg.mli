(** Control flow graphs *)

(** Type of a CFG. *)
type t

(** Type of a label. *)
type label = int

(** Type of a field name. *)
type field_name = string

(** Type of a variable name. *)
type var_name = string

(** Type of a method name. *)
type method_name = string

(** Type of a class name. *)
type class_name = string

(** Type of an instruction. *)
type inst =
  | Assign of var_name * string
  | New of var_name * class_name * int
  | Set of var_name * field_name * var_name
  | Get of var_name * var_name * field_name
  | Call of var_name * method_name * (var_name list)

(** Type of an edge in a CFG. *)
type edge = label * inst * label

(** Build a CFG from two labels and a list of edges. *)
val make : label -> label -> edge list -> t

(** Build a CFG from the mini AST of a method body. *)
val from_ast_insts : Lang.Ast.inst list -> t

(** Fold on a CFG given a function for each edge and one for the labels. *)
val fold : (label -> label -> 'a -> 'b) -> (edge -> 'a -> 'a) -> t -> 'a -> 'b

(** String representation of a CFG. *)
val to_string : t -> string 
