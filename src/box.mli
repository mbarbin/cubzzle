open! Core

(** The enclosing box, defined by its size. It must be exactly big
   enough to hold all the components of the pieces when they're in
   place.

   The box is mutable - one can push and pop pieces from the box. *)
type t

val create : goal:Z_shape.t -> t
val size : t -> Size.t

(** Returns [true] if the given cooridinate is inside the box and
   currently not occupied by any piece. *)
val is_available : t -> Coordinate.t -> bool

val contents : t -> Coordinate.t -> Piece.t option

module Stack : sig
  (** The box acts as a stack of pieces. One can push and pop pieces from the box. *)

  (** Remove the last piece pushed into the box. Does nothing if there
     is no piece in the box. *)
  val pop_piece : t -> unit

  module Push_piece_result : sig
    type t =
      | Inserted
      | Not_available
  end

  (** Attempt to push a piece into the box from a given offset,
     applying a given rotation. If the rotated piece exceeds the box
     boundary, or cannot fit due to another piece, the function
     returns [Not_available] and [t] is unchanged. *)
  val push_piece
    :  t
    -> piece:Piece.t
    -> rotation:Rotation.t
    -> offset:Coordinate.t
    -> Push_piece_result.t
end

(** Print the contents of the box on stdout, layer by layer. This
   starts by z = 0 and goes on for increasing values of z. *)
val print_layers : t -> unit
