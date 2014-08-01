type t = Global.t * Env.t

let equal l1 l2 =
  let (g1, e1) = l1 in
  let (g2, e2) = l2 in
  Global.equal g1 g2 && Env.equal e1 e2

let bot = (Global.bot, Env.bot)

let join l1 l2 =
  let (g1, e1) = l1 in
  let (g2, e2) = l2 in
  (Global.join g1 g2, Env.join e1 e2)

let get_field l v f =
  let ((h, _), e) = l in
  let ss = Value.get_sites (Env.get e v) in
  let merge s v =
    Value.join v (Heap.get_field h s f) in
  Sites.fold merge ss Value.bot

let to_string (g, e) =
  "(" ^ Global.to_string g ^ ", " ^ Env.to_string e ^ ")"
