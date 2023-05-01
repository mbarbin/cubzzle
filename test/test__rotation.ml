open! Core
open! Cubzzle

let%expect_test "indices" =
  for index = 0 to Rotation.cardinality - 1 do
    let rotation = Rotation.of_index_exn index in
    let index' = Rotation.to_index rotation in
    assert (Int.equal index index')
  done;
  [%expect {||}];
  Expect_test_helpers_core.require_does_raise [%here] (fun () ->
    ignore (Rotation.of_index_exn Rotation.cardinality : Rotation.t));
  [%expect {| ("Index out of bounds" src/rotation.ml:61:45 24) |}];
  ()
;;

let%expect_test "sexp_of_t" =
  let rotation = Rotation.of_index_exn 0 in
  print_s [%sexp (rotation : Rotation.t)];
  [%expect {| ((rz 0) (ry 0) (rx 0)) |}]
;;

let%expect_test "zero invariant" =
  let zero = { Coordinate.x = 0; y = 0; z = 0 } in
  for index = 0 to Rotation.cardinality - 1 do
    let rotation = Rotation.of_index_exn index in
    assert (Coordinate.equal (Rotation.apply rotation zero) zero)
  done;
  [%expect {||}];
  ()
;;
