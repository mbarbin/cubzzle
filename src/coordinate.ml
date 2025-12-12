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

let compare t ({ x; y; z } as t2) : Ordering.t =
  if phys_equal t t2
  then Eq
  else (
    match Int.compare t.x x with
    | (Lt | Gt) as r -> r
    | Eq ->
      (match Int.compare t.y y with
       | (Lt | Gt) as r -> r
       | Eq -> Int.compare t.z z))
;;

let equal t1 t2 = Ordering.is_eq (compare t1 t2)
let hash : t -> int = Hashtbl.hash
let add { x; y; z } ~offset:t = { x = x + t.x; y = y + t.y; z = z + t.z }
