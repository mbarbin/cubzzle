open! Base

type t =
  { x : int
  ; y : int
  ; z : int
  }
[@@deriving sexp_of]
