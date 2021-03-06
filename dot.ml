module IdMap = Lib.Map.Make(Context)

type id_map = { map : int IdMap.t; next : int }

let make_id im c =
  try
    let id = IdMap.find c im.map in
    (im, id)
  with Not_found ->
    let map = IdMap.add c im.next im.map in
    ({ map = map ; next = im.next + 1 }, im.next)

let record_of_set fold string_of_elt set =
  let append e s =
    Printf.sprintf "%s%s%s" (string_of_elt e) (if s = "" then "" else ", ") s in
  Printf.sprintf "(%s)" (fold append set "")

let record_of_sites = record_of_set Sites.fold Site.to_string

let record_of_pending = record_of_set Pending.fold (fun s -> s)

let record_of_value v =
  match v with
  | Value.Bot | Value.Top | Value.String _ -> Value.to_string v
  | Value.Sites ss -> record_of_sites ss

let record_of_object o =
  let append f v s =
    Printf.sprintf "{%s|%s}%s%s" f (record_of_value v) (if s = "" then "" else "|") s in
  Printf.sprintf "%s" (Object.fold append o "")

let record_of_arecord a =
  Printf.sprintf "{~state|%s}|{~pending|%s}|{~finished|%s}|{~listeners|%s}"
    (State.to_string (Arecord.get_state a))
    (record_of_pending (Arecord.get_pending a))
    (Bool.to_string (Arecord.get_finished a))
    (record_of_sites (Arecord.get_listeners a))

let record_of_aobject oa =
  let (o, a) = oa in
  let orec =
    if Object.equal o Object.bot then
      ""
    else
      Printf.sprintf "|%s" (record_of_object o) in
  Printf.sprintf "%s%s" (record_of_arecord a) orec

let record_of_heap h =
  let append site oa s =
    Printf.sprintf "{{%s}|{%s}}%s%s"
      (Site.to_string site) (record_of_aobject oa) (if s = "" then "" else "|") s in
  Printf.sprintf "%s" (Heap.fold append h "")

let record_of_as a =
  let str = match a with
    | As.Bot | As.Top -> As.to_string a
    | As.Exact al ->
      let append s site =
        Printf.sprintf "%s%s%s" s (if s = "" then "" else " :: ") (Site.to_string site) in
      List.fold_left append "" al in
  Printf.sprintf "stack = %s" str

let record_of_global g =
  let (h, a) = g in
  Printf.sprintf "{%s|%s}" (record_of_as a) (record_of_heap h)

let edges_of_gcontext gc =
  let im_init = { map = IdMap.empty; next = 0 } in
  let append c gn (l, im) =
    let (_, n) = gn in
    let (im', id_src) = make_id im c in
    let append (action, c) (l, im) =
      let (im', id_dst) = make_id im c in
      let s = Printf.sprintf "%d -> %d [label=%S]" id_src id_dst (Action.to_string action) in
      ((s :: l), im') in
    Nexts.fold append n (l, im') in
  Gcontext.fold append gc ([], im_init)

let vertices_of_gcontext_idmap gc im =
  let append c id l =
    let s = Printf.sprintf "%d [label=%S]" id (record_of_global (fst (Gcontext.get gc c))) in
    s :: l in
  IdMap.fold append im.map []

let from_gcontext gc =
  let (edges, im) = edges_of_gcontext gc in
  let vertices = vertices_of_gcontext_idmap gc im in
  let options = [
    "node [shape=Mrecord,fontname=sans,fontsize=10,style=filled,fillcolor=\"#EAEAEA\"]";
    "edge [fontname=sans,fontsize=10]";
  ] in
  let l = options @ vertices @ edges in
  let append s stmt =
    Printf.sprintf "%s%s  %s;" s (if s = "" then "" else "\n") stmt in
  Printf.sprintf "digraph {\n%s\n}" (List.fold_left append "" l)
