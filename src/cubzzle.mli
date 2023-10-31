module Box = Box
module Color = Color
module Coordinate = Coordinate
module Piece = Piece
module Rotation = Rotation
module Size = Size
module Z_shape = Z_shape

(** Search a solution for the given goal, and return the filled box if one is found. *)
val solve : shape:Z_shape.Sample.t -> draw_box_during_search:bool -> Box.t option

val main : Command.t
