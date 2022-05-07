open! Core

type 'a t =
  { x : 'a
  ; y : 'a
  ; z : 'a
  }
[@@deriving sexp_of]
