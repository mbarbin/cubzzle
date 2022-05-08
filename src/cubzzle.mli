open! Core
module Box = Box
module Color = Color
module Z_shape = Z_shape

(** Search a solution for the given goal, and return the filled box if one is found. *)
val solve : shape:Z_shape.Sample.t -> Box.t option

val main : Command.t
