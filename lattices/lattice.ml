module type Base = sig
  type t
  val compare : t -> t -> int
  val join : t -> t -> t
  val bot : t
end

module type S = sig
  include Base
  val equal : t -> t -> bool
  val le : t -> t -> bool
end

module Extend(B : Base) = struct
  include B

  let equal x y =
    B.compare x y = 0

  let le x y =
    equal (B.join x y) y
end
