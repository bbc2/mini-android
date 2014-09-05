module Global = struct
  type t = Heap.t * As.t

  let compare g1 g2 =
    let (h1, a1) = g1 in
    let (h2, a2) = g2 in
    Lib.(As.compare a1 a2 $ Heap.compare h1 h2)

  let bot = (Heap.bot, As.bot)

  let join g1 g2 =
    let (h1, a1) = g1 in
    let (h2, a2) = g2 in
    (Heap.join h1 h2, As.join a1 a2)

  let to_string (h, a) =
    Printf.sprintf "(%s, %s)" (Heap.to_string h) (As.to_string a)
end

include Lattice.Extend(Global)
include Global
