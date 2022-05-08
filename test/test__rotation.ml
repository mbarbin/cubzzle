open! Core
open! Cubzzle

let%expect_test "indices" =
  for index = 0 to Rotation.cardinality - 1 do
    let rotation = Rotation.of_index_exn index in
    let index' = Rotation.to_index rotation in
    assert (Int.equal index index')
  done;
  [%expect {||}]
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
