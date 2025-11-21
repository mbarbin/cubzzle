(*_********************************************************************************)
(*_  cubzzle - Solver for a wooden cube puzzle                                    *)
(*_  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

type t [@@deriving sexp_of]
(** Defines the shape that must be assembled, from the heights (z axis) where
    the pieces start (bottom) and where they end (top). All proposed shapes are
    such that there is no hole in the middle of a z section, so this
    representation is suitable. *)

val create : size:Size.t -> bottom:int array array -> top:int array array -> t
(** [bottom] and [top] are expected to index by y first -- such as in
    [arr.(y).(x)]. *)

val size : t -> Size.t

module Sample : sig
  type t = Cube | Dog | Tower | Misc_01 | Misc_02 | Misc_03
  [@@deriving enumerate, sexp_of]

  val to_string : t -> string
end

val sample : Sample.t -> t

module Z_section : sig
  type t = {bottom : int; top : int} [@@deriving sexp_of]
end

val sections : t -> Z_section.t array array
(** Return an array of sections, indexed by x first then y. *)
