(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let raw_components =
  [| [ 0, 0, 0; 1, 0, 0; 1, 0, 1; 2, 0, 0; 2, 1, 0 ]
   ; [ 0, 0, 0; 1, 0, 0; 1, 1, 0; 1, 0, 1; 2, 1, 0 ]
   ; [ 0, 0, 0; 1, 0, 0; 2, 0, 0; 1, 1, 0; 1, 1, 1 ]
   ; [ 0, 0, 0; 1, 0, 0; 1, 1, 0; 1, 1, 1 ]
   ; [ 0, 0, 0; 1, 0, 0; 1, 0, 1; 2, 0, 0 ]
   ; [ 0, 0, 0; 1, 0, 0; 2, 0, 0; 2, 0, 1 ]
  |]
  |> Array.map ~f:(List.map ~f:(fun (x, y, z) -> { Coordinate.x; y; z }))
;;

let cardinality = Array.length raw_components

module Index = struct
  type t = int

  let equal = Int.equal
  let all = List.init cardinality ~f:Fun.id
end

type t = Index of Index.t

let equal (Index i1) (Index i2) = Index.equal i1 i2
let all = List.map Index.all ~f:(fun i -> Index i)
let to_index (Index index) = index

let check_index_exn index =
  if not (0 <= index && index < cardinality)
  then
    Dyn.raise
      "Piece: Index out of bounds."
      [ "index", index |> Dyn.int
      ; "lower_bound", 0 |> Dyn.int
      ; "upper_bound", cardinality - 1 |> Dyn.int
      ]
;;

let of_index_exn index =
  check_index_exn index;
  Index index
;;

let components (Index i) = raw_components.(i)

let color =
  let colors = Array.of_list Color.pieces in
  assert (Array.length colors >= cardinality);
  fun (Index i) -> colors.(i)
;;
