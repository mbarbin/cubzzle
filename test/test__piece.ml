open! Base
open! Stdio
open! Cubzzle

let%expect_test "indices" =
  for index = 0 to Piece.cardinality - 1 do
    let piece = Piece.of_index_exn index in
    let index' = Piece.to_index piece in
    assert (Int.equal index index')
  done;
  [%expect {||}];
  Expect_test_helpers_base.require_does_raise [%here] (fun () ->
    ignore (Piece.of_index_exn Piece.cardinality : Piece.t));
  [%expect {| ("Index out of bounds" src/piece.ml:28:45 6) |}];
  ()
;;

let%expect_test "components" =
  let visited_colors = Hash_set.create (module Color) in
  List.iter Piece.all ~f:(fun piece ->
    let color = Piece.color piece in
    (match Hash_set.strict_add visited_colors color with
     | Ok () -> ()
     | Error e -> raise_s [%sexp "Duplicated color", (color : Color.t), (e : Error.t)]);
    let components = Piece.components piece in
    let visited_components = Hash_set.create (module Coordinate) in
    List.iter components ~f:(fun component ->
      match Hash_set.strict_add visited_components component with
      | Ok () -> ()
      | Error e ->
        raise_s [%sexp "Duplicated component", (component : Coordinate.t), (e : Error.t)]);
    let length = List.length components in
    assert (4 <= length && length <= 5));
  [%expect {||}];
  ()
;;
