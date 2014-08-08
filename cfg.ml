type label = int

type field_name = string

type var_name = string

type method_name = string

type class_name = string

type inst =
  | Assign of var_name * string
  | New of var_name * class_name * int
  | Set of var_name * field_name * var_name
  | Get of var_name * var_name * field_name
  | Call of var_name * method_name * (var_name list)

type edge = label * inst * label

module CfgSet = Lib.Set.Make(struct type t = edge let compare = compare end)

type t = label * CfgSet.t * label

let fold f_cfg f_edge (cfg : t) a_init =
  let (init, cfgset, final) = cfg in
  f_cfg init final (CfgSet.fold f_edge cfgset a_init)

let make init final edges =
  (init, (CfgSet.from_list edges), final)

let inst_from_ast_inst i =
  match i with
  | Lang.Ast.Assign (v, s) -> Assign (v, s)
  | Lang.Ast.New (v, cl, id) -> New (v, cl, id)
  | Lang.Ast.Set (v1, f, v2) -> Set (v1, f, v2)
  | Lang.Ast.Get (v1, v2, f) -> Get (v1, v2, f)
  | Lang.Ast.Call (v, m, args) -> Call (v, m, args)

let from_ast_insts il =
  let init = 0 in
  let rec add_insts il (cfgset, label) =
    match il with
    | [] -> (cfgset, label)
    | i::tl ->
      let next = label + 1 in
      let i' = inst_from_ast_inst i in
      add_insts tl (CfgSet.add (label, i', next) cfgset, label + 1) in
  let (cfgset, final) = add_insts il (CfgSet.empty, init) in
  (init, cfgset, final)

let string_of_inst i =
  let fmt = Printf.sprintf in
  match i with
  | Assign (v, s) -> fmt "%s = \"%s\"" v s
  | New (v, cl, id) -> fmt "%s = new:%d %s" v id cl
  | Set (v1, f, v2) -> fmt "%s.%s = %s" v1 f v2
  | Get (v1, v2, f) -> fmt "%s = %s.%s" v1 v2 f
  | Call (v, m, args) ->
    let arg_str = List.fold_left (fun s a -> s ^ (if s = "" then "" else ", ") ^ a) "" args in
    fmt "%s.%s(%s)" v m arg_str

let string_of_edge e =
  let (i, instr, o) = e in
  Printf.sprintf "(%s, %s, %s)" (string_of_int i) (string_of_inst instr) (string_of_int o)

let string_of_cfgset = CfgSet.to_string string_of_edge

let to_string c =
  let (init, cfgset, final) = c in
  Printf.sprintf "(%s, %s, %s)" (string_of_int init) (string_of_cfgset cfgset) (string_of_int final)
