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
  let value = Env.get e v in
  Heap.get_field h value f

let to_string (g, e) =
  "(" ^ Global.to_string g ^ ", " ^ Env.to_string e ^ ")"
