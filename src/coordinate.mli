(*_********************************************************************************)
(*_  cubzzle - Solver for a wooden cube puzzle                                    *)
(*_  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

type t =
  { x : int
  ; y : int
  ; z : int
  }

val equal : t -> t -> bool
val compare : t -> t -> Ordering.t
val hash : t -> int
val to_dyn : t -> Dyn.t
val add : t -> offset:t -> t
