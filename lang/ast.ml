type manifest = string

type class_name = string

type method_name = string

type field_name = string

type var_name = string

type args = var_name list

type label = int

type inst =
  | Assign of var_name * string
  | New of var_name * class_name * label
  | Set of var_name * field_name * var_name
  | Get of var_name * var_name * field_name
  | Call of var_name * method_name * args

type method_ = method_name * inst list

type class_ = class_name * method_ list

type prog = class_ list

type app = manifest * prog
