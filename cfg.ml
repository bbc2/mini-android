type label = int
type field = string
type var = string
type meth = string
type inst =
  | New of var * Site.t
  | Set of var * field * var
  | Get of var * var * field
  | Call of var * meth * (var list)

type edge = label * inst * label
module CfgSet = Set.Make(struct type t = edge let compare = compare end)

type t = label * CfgSet.t

let rec cfgset_of_list l =
  match l with
  | [] -> CfgSet.empty
  | cfg::tl -> CfgSet.add cfg (cfgset_of_list tl)

let fold f cfg =
  let (_, cfgset) = cfg in
  CfgSet.fold f cfgset

let from_list l =
  match l with
  | [] -> failwith "CFG cannot be empty"
  | (i, _, _)::_ -> (i, (cfgset_of_list l))

let string_of_inst i =
  match i with
  | New (v, s) -> v ^ " = new:" ^ (Site.to_string s)
  | Set (v1, f, v2) -> v1 ^ "." ^ f ^ " = " ^ v2
  | Get (v1, v2, f) -> v1 ^ " = " ^ v2 ^ "." ^ f
  | Call (v, m, args) ->
    let arg_str = List.fold_left (fun s a -> s ^ (if s = "" then "" else ", ") ^ a) "" args in
    v ^ "." ^ m ^ "(" ^ arg_str ^ ")"

let string_of_edge e =
  let (i, instr, o) = e in
  "(" ^ (string_of_int i) ^ ", " ^ (string_of_inst instr) ^ ", " ^ (string_of_int o) ^ ")"

let string_of_cfgset cfgset =
  let append_string e s =
    s ^ (if s = "" then "" else ", ") ^ string_of_edge e in
  "{" ^ (CfgSet.fold append_string cfgset "") ^ "}"

let to_string c =
  let (init, cfgset) = c in
  "(" ^ (string_of_int init) ^ ", " ^ (string_of_cfgset cfgset) ^ ")"
