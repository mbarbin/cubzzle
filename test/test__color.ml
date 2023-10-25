open! Base
open! Stdio
open! Cubzzle

let%expect_test "darken" =
  let color = Graphics.rgb 25 50 100 in
  let darken ~darken_factor =
    print_s [%sexp (Color.to_rgb (Color.darken color ~darken_factor) : int * int * int)]
  in
  darken ~darken_factor:None;
  [%expect {| (25 50 100) |}];
  darken ~darken_factor:Light;
  [%expect {| (20 40 80) |}];
  darken ~darken_factor:Medium;
  [%expect {| (17 35 70) |}];
  darken ~darken_factor:Strong;
  [%expect {| (15 30 60) |}];
  ()
;;

let%expect_test "invariant" =
  List.iteri Color.pieces ~f:(fun i1 c1 ->
    List.iter Color.Darken_factor.all ~f:(fun darken_factor ->
      let possibly_darkened = Color.darken c1 ~darken_factor in
      assert (Color.is_rough_match c1 ~possibly_darkened));
    List.iteri Color.pieces ~f:(fun i2 c2 ->
      if i1 <> i2
      then (
        assert (not (Color.is_rough_match c1 ~possibly_darkened:c2));
        assert (not (Color.is_rough_match c2 ~possibly_darkened:c1)))));
  [%expect {||}];
  ()
;;
