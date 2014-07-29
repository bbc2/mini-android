type activity_stack =
  | AnyAS
  | AS of Site.t list
  | NoAS

type t = Heap.t * activity_stack

let to_string (h, _) =
  "(" ^ Heap.to_string h ^ ", _)"
