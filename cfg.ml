type label = int

type field = string

type var = string

type meth = string

type cl = string

type inst =
  | Assign of var * string
  | New of var * cl * int
  | Set of var * field * var
  | Get of var * var * field
  | Call of var * meth * (var list)

type edge = label * inst * label

module CfgSet = Set.Make(struct type t = edge let compare = compare end)

type t = label * CfgSet.t * label

let rec cfgset_of_list l =
  match l with
  | [] -> CfgSet.empty
  | cfg::tl -> CfgSet.add cfg (cfgset_of_list tl)

let fold f cfg =
  let (_, cfgset, _) = cfg in
  CfgSet.fold f cfgset

let make init final edges =
  match edges with
  | [] -> failwith "CFG cannot be empty"
  | _ -> (init, (cfgset_of_list edges), final)

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
  "(" ^ (string_of_int i) ^ ", " ^ (string_of_inst instr) ^ ", " ^ (string_of_int o) ^ ")"

let string_of_cfgset cfgset =
  let append_string e s =
    s ^ (if s = "" then "" else ", ") ^ string_of_edge e in
  "{" ^ (CfgSet.fold append_string cfgset "") ^ "}"

let to_string c =
  let (init, cfgset, final) = c in
  Printf.sprintf "(%s, %s, %s)" (string_of_int init) (string_of_cfgset cfgset) (string_of_int final)
