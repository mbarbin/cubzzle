(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "find" =
  let r = List.find [ 0; 1; 2; 3 ] ~f:(fun i -> Ordering.is_eq (Int.compare i 2)) in
  Dyn.print (Dyn.option Dyn.int r);
  [%expect {| Some 2 |}];
  ()
;;
