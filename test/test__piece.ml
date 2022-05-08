open! Core
open! Cubzzle

let%expect_test "indices" =
  for index = 0 to Piece.cardinality - 1 do
    let piece = Piece.of_index_exn index in
    let index' = Piece.to_index piece in
    assert (Int.equal index index')
  done;
  [%expect {||}]
;;

let%expect_test "components" =
  let colors = Hash_set.create (module Color) in
  List.iter Piece.all ~f:(fun piece ->
      let color = Piece.color piece in
      let () =
        if Hash_set.mem colors color
        then raise_s [%sexp "Duplicated color", (color : Color.t)]
        else Hash_set.add colors color
      in
      let components = Piece.components piece in
      let hset = Hash_set.create (module Coordinate) in
      List.iter components ~f:(fun component ->
          if Hash_set.mem hset component
          then raise_s [%sexp "Duplicated component", (component : Coordinate.t)]
          else Hash_set.add hset component);
      let length = List.length components in
      assert (4 <= length && length <= 5));
  [%expect {||}];
  ()
;;
