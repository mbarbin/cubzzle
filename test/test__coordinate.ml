(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "equal" =
  assert (Coordinate.equal { x = 0; y = 1; z = 2 } { x = 0; y = 1; z = 2 });
  assert (not (Coordinate.equal { x = 0; y = 1; z = 2 } { x = 0; y = 1; z = 4 }));
  ()
;;

let%expect_test "compare" =
  let ts =
    List.sort
      (module Coordinate)
      [ { x = 1; y = 1; z = 2 }
      ; { x = 1; y = 1; z = 3 }
      ; { x = 0; y = 2; z = 3 }
      ; { x = 1; y = 4; z = 3 }
      ; { x = 1; y = 2; z = 3 }
      ]
  in
  print_dyn (Dyn.list Coordinate.to_dyn ts);
  [%expect
    {|
    [ { x = 0; y = 2; z = 3 }
    ; { x = 1; y = 1; z = 2 }
    ; { x = 1; y = 1; z = 3 }
    ; { x = 1; y = 2; z = 3 }
    ; { x = 1; y = 4; z = 3 }
    ]
    |}];
  ()
;;
