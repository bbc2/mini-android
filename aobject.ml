module Aobject = struct
  type t = Object.t * Arecord.t

  let compare oa1 oa2 =
    let (o1, a1) = oa1 in
    let (o2, a2) = oa2 in
    let o = Object.compare o1 o2 in
    if o = 0 then
      Arecord.compare a1 a2
    else
      o

  let join oa1 oa2 =
    let (o1, a1) = oa1 in
    let (o2, a2) = oa2 in
    (Object.join o1 o2, Arecord.join a1 a2)

  let bot = (Object.bot, Arecord.bot)

  let to_string oa =
    let (o, a) = oa in
    Printf.sprintf "(%s, %s)" (Object.to_string  o) (Arecord.to_string a)
end

include Aobject
include Lattice.Extend(Aobject)
