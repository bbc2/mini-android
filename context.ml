(* Only the activity stack is taken into account. *)

type t = Global.t

let compare = compare

let from_global g =
  let (_, a) = g in
  (Heap.bot, a)

let to_string = Global.to_string
