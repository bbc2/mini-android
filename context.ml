type t = Global.t

let compare = Global.compare

let from_global g =
  let (h, a) = g in
  match a with
  | As.Bot -> Global.bot
  | As.Exact al ->
    let h' = Heap.filter (fun s _ -> List.mem s al) h in
    let add_filtered_object s oa h_prev =
      let (o, a) = oa in
      let oa' = (Object.bot, Arecord.set_pending (Arecord.set_listeners a Sites.bot) Pending.bot) in
      Heap.set h_prev s oa' in
    (Heap.fold add_filtered_object h' Heap.bot, a)
  | As.Top -> (Heap.bot, a)

let to_string = Global.to_string
