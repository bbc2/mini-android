exception Method_not_found

type t = string -> string -> string list -> Local.t -> Local.t

let transfer_exn m v args l =
  let ((h, _), e) = l in
  match m with
  | "startActivity" ->
    (* Assumption: each such call is executed at most once. Otherwise, the
       analysis is potentially incorrect. *)
    let arg = match args with
      | [a] -> a
      | _ -> failwith "Api.transfer_exn: Wrong number of arguments for startActivity" in
    let ss = Value.get_sites (Env.get e v) in
    let s = Value.get_str (Env.get e arg) in
    let add_str s p =
      Pending.add p s in
    let pending = (Str.fold add_str s Pending.bot) in
    let update s h = Heap.add h s (Object.bot, Arecord.add_pending Arecord.bot pending) in
    let h_update = Sites.fold update ss Heap.bot in
    ((h_update, As.bot), Env.bot)
  | "addListener" ->
    let arg = match args with
      | [a] -> a
      | _ -> failwith "Api.transfer_exn: Wrong number of arguments for addListener" in
    let ss = Value.get_sites (Env.get e v) in
    let update s h =
      Heap.add h s
        (Object.bot, Arecord.add_listeners Arecord.bot (Value.get_sites (Env.get e arg))) in
    let h_update = Sites.fold update ss Heap.bot in
    ((h_update, As.bot), Env.bot)
  | _ -> raise Method_not_found
