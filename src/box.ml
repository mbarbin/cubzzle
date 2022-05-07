open! Core

type t = { size : Size.t } [@@deriving fields]

let create ~size = { size }
