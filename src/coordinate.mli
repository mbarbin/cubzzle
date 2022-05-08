open! Core

type t =
  { x : int
  ; y : int
  ; z : int
  }
[@@deriving compare, equal, hash, sexp_of]

val add : t -> offset:t -> t
