(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = {x: int; y: int; z: int} [@@deriving compare, equal, hash, sexp_of]

let add {x; y; z} ~offset:t = {x= x + t.x; y= y + t.y; z= z + t.z}
