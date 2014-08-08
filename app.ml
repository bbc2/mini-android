type manifest = string

module MethMap = Lib.Map.Make(String)

type methods = Cfg.t MethMap.t

module ClassMap = Lib.Map.Make(String)

type classes = methods ClassMap.t

type t = manifest * classes

module InitSet = Lib.Set.Make(Global)

let get_init_states app =
  let (manif, c) = app in
  let s_m = Site.make manif 0 in
  let h0 = Heap.from_list [
      (s_m, Object.from_list [
          (Field.AField "state", Value.State (State.from_list [State.Uninit]))
        ])] in
  let g0 = (h0, As.from_list []) in
  InitSet.singleton g0

let fold_on_init_states = InitSet.fold

let manifest_from_string s =
  s

let rec methods_from_list = MethMap.from_list

let classes_from_list = ClassMap.from_list

let make m c =
  if ClassMap.mem m c then
    (m, c)
  else
    failwith "App.make: The class declared in the manifest cannot be found in the app classes."

let rec methods_from_class cl =
  match cl with
  | [] -> MethMap.empty
  | (name, m)::tl ->
    let cfg = Cfg.from_ast_insts m in
    MethMap.add name cfg (methods_from_class tl)

let rec classes_from_prog prog =
  match prog with
  | [] -> ClassMap.empty
  | (name, c)::tl ->
    let methmap = methods_from_class c in
    ClassMap.add name methmap (classes_from_prog tl)

let from_ast a =
  let (manif, prog) = a in
  make manif (classes_from_prog prog)

let get_method app c m =
  let (_, classmap) = app in
  let methmap = try ClassMap.find c classmap
    with Not_found -> failwith (Printf.sprintf "App.get_method: Class %s not found" c) in
  try MethMap.find m methmap
  with Not_found -> Cfg.make 0 0 []
