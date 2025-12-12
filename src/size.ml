(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t =
  { x : int
  ; y : int
  ; z : int
  }

let to_dyn { x; y; z } =
  Dyn.record [ "x", x |> Dyn.int; "y", y |> Dyn.int; "z", z |> Dyn.int ]
;;
