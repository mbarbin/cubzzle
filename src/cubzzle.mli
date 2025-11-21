(*_********************************************************************************)
(*_  cubzzle - Solver for a wooden cube puzzle                                    *)
(*_  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

module Box = Box
module Color = Color
module Coordinate = Coordinate
module Piece = Piece
module Rotation = Rotation
module Size = Size
module Z_shape = Z_shape

val solve :
  shape:Z_shape.Sample.t -> draw_box_during_search:bool -> Box.t option
(** Search a solution for the given goal, and return the filled box if one is
    found. *)

val main : unit Command.t
