open! Core

(** The enclosing box, defined by its size. It must be exactly big
   enough to hold all the components of the pieces when they're in
   place. *)
type t

val create : size:Size.t -> t
val size : t -> Size.t
