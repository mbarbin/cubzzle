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

let%expect_test "inverse" =
  for x = 0 to 2 do
    for y = 0 to 2 do
      for z = 0 to 2 do
        let c = { Coordinate.x; y; z } in
        for rotation = 0 to Rotation.cardinality - 1 do
          let rotation = Rotation.of_index_exn rotation in
          let c' = Rotation.apply rotation c in
          match Rotation.inverse rotation with
          | None -> print_s [%sexp "Inverse not available", { rotation : Rotation.t }]
          | Some inverse ->
            let c'' = Rotation.apply inverse c' in
            if not (Coordinate.equal c c'')
            then
              print_s
                [%sexp
                  "Unexpected rotation sequence"
                  , { c : Coordinate.t
                    ; c' : Coordinate.t
                    ; c'' : Coordinate.t
                    ; rotation : Rotation.t
                    ; inverse : Rotation.t
                    }]
        done
      done
    done
  done;
  [%expect {||}];
  ()
;;
