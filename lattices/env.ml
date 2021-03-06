module Env = struct
  type var = string

  module EnvMap = Lib.Map.Make(struct type t = var let compare = String.compare end)

  type t = Value.t EnvMap.t

  let compare = EnvMap.compare Value.compare

  let equal = EnvMap.equal Value.equal

  let bot = EnvMap.empty

  let join e1 e2 =
    let union _ option_v1 option_v2 =
      match (option_v1, option_v2) with
      | (None, None) -> None
      | (Some v1, None) -> Some v1
      | (None, Some v2) -> Some v2
      | (Some v1, Some v2) -> Some (Value.join v1 v2) in
    EnvMap.merge union e1 e2

  let get e k =
    try
      EnvMap.find k e
    with Not_found -> Value.bot

  let from_list = EnvMap.from_list

  let to_string = EnvMap.to_string (fun var -> var) Value.to_string
end

include Lattice.Extend(Env)
include Env
