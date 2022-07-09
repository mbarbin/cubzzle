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
