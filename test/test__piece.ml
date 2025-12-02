(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "indices" =
  for index = 0 to Piece.cardinality - 1 do
    let piece = Piece.of_index_exn index in
    let index' = Piece.to_index piece in
    assert (Int.equal index index')
  done;
  [%expect {||}];
  require_does_raise (fun () : Piece.t -> Piece.of_index_exn Piece.cardinality);
  [%expect
    {|
    ("Piece: Index out of bounds.",
     { index = 6; lower_bound = 0; upper_bound = 5 })
    |}];
  ()
;;

module Color_table = Hashtbl.Make (Color)
module Coordinate_table = Hashtbl.Make (Coordinate)

let%expect_test "components" =
  let visited_colors = Color_table.create (List.length Piece.all) in
  List.iter Piece.all ~f:(fun piece ->
    let color = Piece.color piece in
    if Color_table.mem visited_colors color
    then
      Code_error.raise
        "Duplicated color."
        [ "color", color |> Color.to_dyn ] [@coverage off]
    else Color_table.add visited_colors color ();
    let components = Piece.components piece in
    let length = List.length components in
    assert (4 <= length && length <= 5);
    let visited_components = Coordinate_table.create length in
    List.iter components ~f:(fun component ->
      if Coordinate_table.mem visited_components component
      then
        Code_error.raise
          "Duplicated component."
          [ "component", component |> Coordinate.to_dyn ] [@coverage off]
      else Coordinate_table.add visited_components component ()));
  [%expect {||}];
  ()
;;
