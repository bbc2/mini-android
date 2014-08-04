module PStack = struct type t = string list let compare = compare end
module PSet = Set.Make(PStack)

type t =
  | PSet of PSet.t
  | Any

let max_stack_size = 2

let equal p1 p2 =
  match (p1, p2) with
  | (PSet ps1, PSet ps2) ->
      PSet.equal ps1 ps2
  | _ -> p1 = p2

let bot = PSet PSet.empty

let join p1 p2 =
  match (p1, p2) with
  | (PSet ps1, PSet ps2) ->
    PSet (PSet.union ps1 ps2)
  | _ -> Any

let from_stack l =
  if List.length l > max_stack_size then
    Any
  else
    PSet (PSet.singleton l)

let push p c =
  match p with
  | Any -> Any
  | PSet pset ->
    let push_stack pstack p = join p (from_stack (c::pstack)) in
    PSet.fold push_stack pset (PSet PSet.empty)

let string_of_pstack pstack =
  let append_string s c =
    s ^ (if s = "" then "" else "; ") ^ c in
  "[" ^ (List.fold_left append_string "" pstack) ^ "]"

let to_string p =
  match p with
  | Any -> "Any"
  | PSet pset ->
    let append_string pstack s =
      s ^ (if s = "" then "" else ", ") ^ (string_of_pstack pstack) in
    "{" ^ (PSet.fold append_string pset "") ^ "}"
