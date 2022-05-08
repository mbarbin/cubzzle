open! Core

type t =
  { x : int
  ; y : int
  ; z : int
  }
[@@deriving sexp_of]

let add { x; y; z } ~offset:t = { x = x + t.x; y = y + t.y; z = z + t.z }
