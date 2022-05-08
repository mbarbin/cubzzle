open! Core

type t =
  { x : int
  ; y : int
  ; z : int
  }
[@@deriving sexp_of]

val add : t -> offset:t -> t
