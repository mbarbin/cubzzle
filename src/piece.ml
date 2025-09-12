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
  type t = int [@@deriving equal]

  let all = List.init cardinality ~f:Fn.id
end

type t = Index of Index.t [@@deriving equal, enumerate]

let to_index (Index index) = index

exception
  Index_out_of_bounds of
    { index : int
    ; lower_bound : int
    ; upper_bound : int
    }

let () =
  Sexplib0.Sexp_conv.Exn_converter.add
    [%extension_constructor Index_out_of_bounds]
    (function
    | Index_out_of_bounds { index; lower_bound; upper_bound } ->
      List
        [ Atom "Piece.Index_out_of_bounds"
        ; List [ Atom "index"; Atom (Int.to_string index) ]
        ; List [ Atom "lower_bound"; Atom (Int.to_string lower_bound) ]
        ; List [ Atom "upper_bound"; Atom (Int.to_string upper_bound) ]
        ]
    | _ -> assert false)
;;

let check_index_exn index =
  if not (0 <= index && index < cardinality)
  then
    raise
      (Index_out_of_bounds { index : int; lower_bound = 0; upper_bound = cardinality - 1 })
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
