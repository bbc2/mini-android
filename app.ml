type manifest = string

module MethMap = Map.Make(String)

type methods = Cfg.t MethMap.t

module ClassMap = Map.Make(String)

type classes = methods ClassMap.t

type t = manifest * classes

module InitSet = Set.Make(Global)

let get_init_states app =
  let (manif, c) = app in
  let s_m = Site.make manif 0 in
  let h0 = Heap.from_list [
      (s_m, Object.from_list [
          (Field.AField "state", Value.State (State.from_state State.Uninit))
        ])] in
  let g0 = (h0, As.from_list []) in
  InitSet.singleton g0

let fold_on_init_states = InitSet.fold

let manifest_from_string s =
  s

let rec methods_from_list l =
  match l with
  | [] -> MethMap.empty
  | (m, cfg)::tl -> MethMap.add m cfg (methods_from_list tl)

let rec classes_from_list l =
  match l with
  | [] -> ClassMap.empty
  | (c, methmap)::tl -> ClassMap.add c methmap (classes_from_list tl)

let make m c =
  if ClassMap.mem m c then
    (m, c)
  else
    failwith "App.make: The class declared in the manifest cannot be found in the app classes."

let get_method app c m =
  let (manif, classmap) = app in
  let methmap = ClassMap.find c classmap in
  MethMap.find m methmap
