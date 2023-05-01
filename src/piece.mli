open! Core

(** The pieces that constitues the puzzle. *)
type t [@@deriving equal, enumerate]

(** The number of pieces. In this version of the puzzle, that's 6. *)
val cardinality : int

(** Pieces are ordered and indexed. The index may serve as efficient encoding. *)

(** [to_index t] returns the [index] of [t] in the total code set. It is
    guaranteed that [0 <= index < cardinality]. *)
val to_index : t -> int

(** [of_index index] returns the code at the given index. Indices are expected
    to verify [0 <= index < cardinality]. An invalid index will cause the
    function to raise. *)
val of_index_exn : int -> t

(** Starting from (0, 0, 0), and following one particular way that piece can be
    positioned, return the list of cubes components that the piece occupies in
    space. Each piece is such that it is composed by either 4 or 5 cubes. *)
val components : t -> Coordinate.t list

(** The color chosen when displaying that particular piece. *)
val color : t -> Color.t
