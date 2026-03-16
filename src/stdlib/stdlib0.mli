(*_********************************************************************************)
(*_  cubzzle - Solver for a wooden cube puzzle                                    *)
(*_  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

module Array = Array0
module Code_error = Code_error0
module Comparable = Comparable0
module Dyn = Dyn0
module Int = Int0
module List = List0
module Ordering = Ordering0
module Stack = Stack0

val print_dyn : Dyn.t -> unit
val phys_equal : 'a -> 'a -> bool
val require_does_raise : (unit -> 'a) -> unit
