(*_********************************************************************************)
(*_  cubzzle - Solver for a wooden cube puzzle                                    *)
(*_  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** Defines the shape that must be assembled, from the heights (z axis) where
    the pieces start (bottom) and where they end (top). All proposed shapes are
    such that there is no hole in the middle of a z section, so this
    representation is suitable. *)
type t

val to_dyn : t -> Dyn.t

(** [bottom] and [top] are expected to index by y first -- such as in [arr.(y).(x)]. *)
val create : size:Size.t -> bottom:int array array -> top:int array array -> t

val size : t -> Size.t

module Sample : sig
  type t =
    | Cube
    | Dog
    | Tower
    | Misc_01
    | Misc_02
    | Misc_03

  val to_dyn : t -> Dyn.t
  val all : t list
  val to_string : t -> string
end

val sample : Sample.t -> t

module Z_section : sig
  type t =
    { bottom : int
    ; top : int
    }

  val to_dyn : t -> Dyn.t
end

(** Return an array of sections, indexed by x first then y. *)
val sections : t -> Z_section.t array array
