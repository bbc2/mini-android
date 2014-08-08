exception Method_not_found
exception Wrong_args of int

type t = string -> string -> string list -> Local.t -> Local.t

let transfer_exn m v args l =
  let ((h, _), e) = l in
  match m with
  | "startActivity" ->
    (* Assumption: only one such call per callback. Otherwise, the analysis is
       potentially incorrect. *)
    let arg = match args with
      | [a] -> a
      | _ -> raise (Wrong_args (List.length args)) in
    let ss = Value.get_sites (Env.get e v) in
    let pstack = match Env.get e arg with
      | Value.String s -> [s]
      | _ -> [] in
    let pending = Value.Pending (Pending.from_stack pstack) in
    let update s h = Heap.add_field h s Field.Pending pending in
    let h_update = Sites.fold update ss Heap.bot in
    ((h_update, As.bot), Env.bot)
  | _ -> raise Method_not_found
