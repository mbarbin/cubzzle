(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = int [@@deriving compare, equal, hash, sexp_of]

let pieces = Graphics.[ blue; yellow; red; cyan; green; magenta ]

module Darken_factor = struct
  type t = None | Light | Medium | Strong [@@deriving enumerate]
end

let to_rgb t = (t / (256 * 256), t / 256 % 256, t % 256)

let darken t ~darken_factor =
  let scale i =
    i
    * (match (darken_factor : Darken_factor.t) with
      | None -> 10
      | Light -> 8
      | Medium -> 7
      | Strong -> 6)
    / 10
  in
  let r, g, b = to_rgb t in
  Graphics.rgb (scale r) (scale g) (scale b)

let is_rough_match t1 ~possibly_darkened:t2 =
  List.exists Darken_factor.all ~f:(fun darken_factor ->
      t2 = darken t1 ~darken_factor)
