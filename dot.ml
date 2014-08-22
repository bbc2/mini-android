module IdMap = Lib.Map.Make(Context)

type id_map = { map : int IdMap.t; next : int }

let make_id im c = 
  try
    let id = IdMap.find c im.map in
    (im, id)
  with Not_found ->
    let map = IdMap.add c im.next im.map in
    ({ map = map ; next = im.next + 1 }, im.next)

let edges_of_gcontext gc =
  let im_init = { map = IdMap.empty; next = 0 } in
  let append c gn (l, im) =
    let (_, n) = gn in
    let (im', id_src) = make_id im c in
    let append (call, c) (l, im) =
      let (im', id_dst) = make_id im c in
      let s = Printf.sprintf "%d -> %d [label=%S]" id_src id_dst (Call.to_string call) in
      ((s :: l), im') in
    Nexts.fold append n (l, im') in
  Gcontext.fold append gc ([], im_init)

let vertices_of_gcontext_idmap gc im =
  let append c id l =
    let s = Printf.sprintf "%d [label=%S]" id (Global.to_string (fst (Gcontext.get gc c))) in
    s :: l in
  IdMap.fold append im.map []

let from_gcontext gc =
  let (edges, im) = edges_of_gcontext gc in
  let vertices = vertices_of_gcontext_idmap gc im in
  let options = [
    "node [shape=box,fontname=sans,fontsize=12]";
    "edge [fontname=\"sans bold\",fontsize=12]";
  ] in
  let l = options @ vertices @ edges in
  let append s stmt =
    Printf.sprintf "%s%s  %s;" s (if s = "" then "" else "\n") stmt in
  Printf.sprintf "digraph {\n%s\n}" (List.fold_left append "" l)
