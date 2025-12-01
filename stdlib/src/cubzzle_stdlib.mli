(*_********************************************************************************)
(*_  cubzzle - Solver for a wooden cube puzzle                                    *)
(*_  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** Extending [Stdlib] for use in the project. *)

module Dyn = Dyn0
module Ordering = Ordering

val phys_equal : 'a -> 'a -> bool
val require_does_raise : (unit -> 'a) -> unit

module Comparable : sig
  module type S = sig
    type t

    val compare : t -> t -> Ordering.t
  end
end

module Array : sig
  include module type of struct
    include Stdlib.ArrayLabels
  end

  val create : len:int -> 'a -> 'a t
end

module Int : sig
  include module type of struct
    include Stdlib.Int
  end

  val compare : t -> t -> Ordering.t
end

module List : sig
  include module type of struct
    include Stdlib.ListLabels
  end

  val find : 'a t -> f:('a -> bool) -> 'a option
  val init : int -> f:(int -> 'a) -> 'a t
  val iter : 'a t -> f:('a -> unit) -> unit
  val sort : (module Comparable.S with type t = 'a) -> 'a t -> 'a t
end

module Stack : sig
  include module type of struct
    include Stdlib.Stack
  end

  val pop : 'a t -> 'a option
  val push : 'a t -> 'a -> unit
end
