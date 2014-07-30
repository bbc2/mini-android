type t = Global.t * Env.t

let equal l1 l2 =
  let (g1, e1) = l1 in
  let (g2, e2) = l2 in
  Global.equal g1 g2 && Env.equal e1 e2

let bot = (Global.bot, Env.bot)

let red l =
  let (g, e) = l in
  if Global.equal g Global.bot then
    bot
  else if Env.equal e Env.bot then
    bot
  else l

let join l1 l2 =
  let (g1, e1) = l1 in
  let (g2, e2) = l2 in
  red (Global.join g1 g2, Env.join e1 e2)

let to_string (g, e) =
  "(" ^ Global.to_string g ^ ", " ^ Env.to_string e ^ ")"
