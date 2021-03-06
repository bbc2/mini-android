module Arecord = struct
  type t = { state : State.t;
             pending : Pending.t;
             finished : Bool.t;
             listeners : Sites.t }

  let compare a1 a2 =
    let { state = s1; pending = p1; finished = f1; listeners = l1 } = a1 in
    let { state = s2; pending = p2; finished = f2; listeners = l2 } = a2 in
    Lib.(State.compare s1 s2 $ Pending.compare p1 p2 $ Bool.compare f1 f2 $ Sites.compare l1 l2)

  let join a1 a2 =
    { state = State.join a1.state a2.state;
      pending = Pending.join a1.pending a2.pending;
      finished = Bool.join a1.finished a2.finished;
      listeners = Sites.join a1.listeners a2.listeners }

  let bot = { state = State.bot;
              pending = Pending.bot;
              finished = Bool.bot;
              listeners = Sites.bot }

  let get_state a =
    a.state

  let get_pending a =
    a.pending

  let get_finished a =
    a.finished

  let get_listeners a =
    a.listeners

  let set_state a s =
    { a with state = s }

  let set_pending a p =
    { a with pending = p }

  let set_finished a f =
    {  a with finished = f }

  let set_listeners a l =
    { a with listeners = l }

  let add_state a s =
    { a with state = State.join a.state s }

  let add_pending a p =
    { a with pending = Pending.join a.pending p }

  let add_finished a f =
    { a with finished = Bool.join a.finished f }

  let add_listeners a l =
    { a with listeners = Sites.join a.listeners l }

  let to_string a =
    Printf.sprintf "{pending: %s; state: %s; finished: %s; listeners: %s}"
      (Pending.to_string a.pending) (State.to_string a.state)
      (Bool.to_string a.finished) (Sites.to_string a.listeners)

end

include Lattice.Extend(Arecord)
include Arecord
