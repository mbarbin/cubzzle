open! Core
open! Cubzzle

let%expect_test "create" =
  (match
     Z_shape.create
       ~size:{ x = 3; y = 3; z = 3 }
       ~bottom:[| [| 0; 0; 0 |]; [| 0; 0; 0 |]; [| 0; 0; 0 |] |]
       ~top:[| [| 3; 3; 3 |]; [| 3; 3; 3 |]; [| 3; 3; 2 |] |]
   with
   | exception _ -> ()
   | t -> print_s [%sexp "Unexpected t", (t : Z_shape.t)]);
  [%expect {||}]
;;

let%expect_test "samples" =
  List.iter Z_shape.Sample.all ~f:(fun sample ->
    let z_shape = Z_shape.sample sample in
    let sections = Z_shape.sections z_shape in
    print_s
      [%sexp
        { sample : Z_shape.Sample.t
        ; z_shape : Z_shape.t
        ; sections : Z_shape.Z_section.t array array
        }]);
  [%expect
    {|
    ((sample Cube)
     (z_shape
      ((size ((x 3) (y 3) (z 3))) (bottom ((0 0 0) (0 0 0) (0 0 0)))
       (top ((3 3 3) (3 3 3) (3 3 3)))))
     (sections
      ((((bottom 0) (top 3)) ((bottom 0) (top 3)) ((bottom 0) (top 3)))
       (((bottom 0) (top 3)) ((bottom 0) (top 3)) ((bottom 0) (top 3)))
       (((bottom 0) (top 3)) ((bottom 0) (top 3)) ((bottom 0) (top 3))))))
    ((sample Dog)
     (z_shape
      ((size ((x 3) (y 4) (z 5))) (bottom ((0 1 0) (1 1 1) (0 1 0) (0 4 0)))
       (top ((3 3 3) (3 3 3) (4 5 4) (0 5 0)))))
     (sections
      ((((bottom 0) (top 3)) ((bottom 1) (top 3)) ((bottom 0) (top 4))
        ((bottom 0) (top 0)))
       (((bottom 1) (top 3)) ((bottom 1) (top 3)) ((bottom 1) (top 5))
        ((bottom 4) (top 5)))
       (((bottom 0) (top 3)) ((bottom 1) (top 3)) ((bottom 0) (top 4))
        ((bottom 0) (top 0))))))
    ((sample Tower)
     (z_shape
      ((size ((x 2) (y 2) (z 7))) (bottom ((0 0) (0 0))) (top ((7 7) (7 6)))))
     (sections
      ((((bottom 0) (top 7)) ((bottom 0) (top 7)))
       (((bottom 0) (top 7)) ((bottom 0) (top 6))))))
    ((sample Misc_01)
     (z_shape
      ((size ((x 3) (y 5) (z 3)))
       (bottom ((0 0 0) (0 0 0) (0 0 0) (0 0 0) (0 0 0)))
       (top ((0 2 0) (2 2 2) (3 3 3) (3 3 2) (0 2 0)))))
     (sections
      ((((bottom 0) (top 0)) ((bottom 0) (top 2)) ((bottom 0) (top 3))
        ((bottom 0) (top 3)) ((bottom 0) (top 0)))
       (((bottom 0) (top 2)) ((bottom 0) (top 2)) ((bottom 0) (top 3))
        ((bottom 0) (top 3)) ((bottom 0) (top 2)))
       (((bottom 0) (top 0)) ((bottom 0) (top 2)) ((bottom 0) (top 3))
        ((bottom 0) (top 2)) ((bottom 0) (top 0))))))
    ((sample Misc_02)
     (z_shape
      ((size ((x 4) (y 3) (z 4))) (bottom ((0 0 0 0) (0 0 0 0) (0 0 0 0)))
       (top ((2 3 4 0) (2 3 4 2) (3 0 2 2)))))
     (sections
      ((((bottom 0) (top 2)) ((bottom 0) (top 2)) ((bottom 0) (top 3)))
       (((bottom 0) (top 3)) ((bottom 0) (top 3)) ((bottom 0) (top 0)))
       (((bottom 0) (top 4)) ((bottom 0) (top 4)) ((bottom 0) (top 2)))
       (((bottom 0) (top 0)) ((bottom 0) (top 2)) ((bottom 0) (top 2))))))
    ((sample Misc_03)
     (z_shape
      ((size ((x 5) (y 2) (z 4))) (bottom ((0 0 0 0 0) (0 0 0 0 0)))
       (top ((3 3 3 2 2) (3 4 3 2 2)))))
     (sections
      ((((bottom 0) (top 3)) ((bottom 0) (top 3)))
       (((bottom 0) (top 3)) ((bottom 0) (top 4)))
       (((bottom 0) (top 3)) ((bottom 0) (top 3)))
       (((bottom 0) (top 2)) ((bottom 0) (top 2)))
       (((bottom 0) (top 2)) ((bottom 0) (top 2)))))) |}]
;;
