(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

include Stdlib.ListLabels

let find t ~f = find_opt ~f t
let init len ~f = init ~len ~f
let iter t ~f = iter ~f t

let sort (type a) (module M : Comparable0.S with type t = a) t =
  let cmp a b = Ordering.to_int (M.compare a b) in
  sort t ~cmp
;;
