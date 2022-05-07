open! Core

let%expect_test "hello" =
  print_s Cubzzle.Hello.hello_world;
  [%expect {| "Hello, World!" |}]
;;