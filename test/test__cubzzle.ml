open! Core
open! Cubzzle

let%expect_test "solve" =
  List.iter Z_shape.Sample.all ~f:(fun shape ->
    print_endline
      (sprintf
         "============== %s =============="
         (Sexp.to_string [%sexp (shape : Z_shape.Sample.t)]));
    match Cubzzle.solve ~shape ~draw_box_during_search:false with
    | None -> print_endline "No solution"
    | Some box -> Box.print_floors box);
  [%expect
    {|
    ============== Cube ==============

    Floor 3

    666
    522
    223


    Floor 2

    516
    533
    423


    Floor 1

    111
    541
    443

    ============== Dog ==============

    Floor 5

    000
    000
    030
    030


    Floor 4

    000
    000
    333
    000


    Floor 3

    115
    644
    624
    000


    Floor 2

    155
    142
    622
    000


    Floor 1

    105
    000
    602
    000

    ============== Tower ==============

    Floor 7

    15
    10


    Floor 6

    55
    11


    Floor 5

    25
    16


    Floor 4

    22
    26


    Floor 3

    36
    26


    Floor 2

    33
    43


    Floor 1

    34
    44

    ============== Misc_01 ==============

    Floor 3

    000
    000
    522
    220
    000


    Floor 2

    030
    566
    516
    526
    040


    Floor 1

    030
    333
    111
    441
    040

    ============== Misc_02 ==============

    Floor 4

    0010
    0010
    0000


    Floor 3

    0110
    0320
    6000


    Floor 2

    3510
    3322
    6024


    Floor 1

    5550
    6344
    6024

    ============== Misc_03 ==============

    Floor 4

    00000
    05000


    Floor 3

    11200
    55500


    Floor 2

    12234
    12634


    Floor 1

    12333
    66644 |}]
;;
