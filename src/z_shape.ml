(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t =
  { size : Size.t
  ; bottom : int array array
  ; top : int array array
  }

let to_dyn { size; bottom; top } =
  Dyn.record
    [ "size", size |> Size.to_dyn
    ; "bottom", bottom |> Dyn.array (Dyn.array Dyn.int)
    ; "top", top |> Dyn.array (Dyn.array Dyn.int)
    ]
;;

let number_of_cubes t =
  let count = ref 0 in
  for y = 0 to t.size.y - 1 do
    for x = 0 to t.size.x - 1 do
      count := !count + t.top.(y).(x) - t.bottom.(y).(x)
    done
  done;
  !count
;;

let invariant t =
  assert (t.size.x > 0);
  assert (t.size.y > 0);
  assert (t.size.z > 0);
  assert (Array.length t.bottom = t.size.y);
  assert (Array.length t.top = t.size.y);
  for y = 0 to t.size.y - 1 do
    assert (Array.length t.bottom.(y) = t.size.x);
    assert (Array.length t.top.(y) = t.size.x);
    for x = 0 to t.size.x - 1 do
      assert (0 <= t.bottom.(y).(x));
      assert (t.bottom.(y).(x) <= t.top.(y).(x));
      assert (t.top.(y).(x) <= t.size.z)
    done
  done;
  let count = number_of_cubes t in
  let expected = 27 in
  if count <> expected
  then
    Dyn.raise
      "Z_shape: Unexpected count."
      [ "expected", expected |> Dyn.int; "count", count |> Dyn.int ]
;;

let create ~size ~bottom ~top =
  let t = { size; bottom; top } in
  invariant t;
  t
;;

let size t = t.size

module Z_section = struct
  type t =
    { bottom : int
    ; top : int
    }

  let to_dyn { bottom; top } =
    Dyn.record [ "bottom", bottom |> Dyn.int; "top", top |> Dyn.int ]
  ;;

  let zero = { bottom = 0; top = 0 }
end

let sections t =
  let s = Array.make_matrix ~dimx:t.size.x ~dimy:t.size.y Z_section.zero in
  for x = 0 to t.size.x - 1 do
    for y = 0 to t.size.y - 1 do
      s.(x).(y) <- { bottom = t.bottom.(y).(x); top = t.top.(y).(x) }
    done
  done;
  s
;;

module Sample = struct
  type t =
    | Cube
    | Dog
    | Tower
    | Misc_01
    | Misc_02
    | Misc_03

  let all = [ Cube; Dog; Tower; Misc_01; Misc_02; Misc_03 ]

  let to_string = function
    | Cube -> "Cube"
    | Dog -> "Dog"
    | Tower -> "Tower"
    | Misc_01 -> "Misc_01"
    | Misc_02 -> "Misc_02"
    | Misc_03 -> "Misc_03"
  ;;

  let to_dyn t = Dyn.variant (to_string t) []

  let cube =
    create
      ~size:{ x = 3; y = 3; z = 3 }
      ~bottom:[| [| 0; 0; 0 |]; [| 0; 0; 0 |]; [| 0; 0; 0 |] |]
      ~top:[| [| 3; 3; 3 |]; [| 3; 3; 3 |]; [| 3; 3; 3 |] |]
  ;;

  let dog =
    create
      ~size:{ x = 3; y = 4; z = 5 }
      ~bottom:[| [| 0; 1; 0 |]; [| 1; 1; 1 |]; [| 0; 1; 0 |]; [| 0; 4; 0 |] |]
      ~top:[| [| 3; 3; 3 |]; [| 3; 3; 3 |]; [| 4; 5; 4 |]; [| 0; 5; 0 |] |]
  ;;

  let tower =
    create
      ~size:{ x = 2; y = 2; z = 7 }
      ~bottom:[| [| 0; 0 |]; [| 0; 0 |] |]
      ~top:[| [| 7; 7 |]; [| 7; 6 |] |]
  ;;

  let misc_01 =
    create
      ~size:{ x = 3; y = 5; z = 3 }
      ~bottom:
        [| [| 0; 0; 0 |]; [| 0; 0; 0 |]; [| 0; 0; 0 |]; [| 0; 0; 0 |]; [| 0; 0; 0 |] |]
      ~top:[| [| 0; 2; 0 |]; [| 2; 2; 2 |]; [| 3; 3; 3 |]; [| 3; 3; 2 |]; [| 0; 2; 0 |] |]
  ;;

  let misc_02 =
    create
      ~size:{ x = 4; y = 3; z = 4 }
      ~bottom:[| [| 0; 0; 0; 0 |]; [| 0; 0; 0; 0 |]; [| 0; 0; 0; 0 |] |]
      ~top:[| [| 2; 3; 4; 0 |]; [| 2; 3; 4; 2 |]; [| 3; 0; 2; 2 |] |]
  ;;

  let misc_03 =
    create
      ~size:{ x = 5; y = 2; z = 4 }
      ~bottom:[| [| 0; 0; 0; 0; 0 |]; [| 0; 0; 0; 0; 0 |] |]
      ~top:[| [| 3; 3; 3; 2; 2 |]; [| 3; 4; 3; 2; 2 |] |]
  ;;

  let sample = function
    | Cube -> cube
    | Dog -> dog
    | Tower -> tower
    | Misc_01 -> misc_01
    | Misc_02 -> misc_02
    | Misc_03 -> misc_03
  ;;
end

let sample = Sample.sample
