open! Core

(** The pieces that constitues the puzzle. *)
type t [@@deriving enumerate]

(** The number of pieces. In this version of the puzzle, that's 6. *)
val cardinality : int

(** Starting from (0, 0, 0), and following one particular way that
   piece can be positioned, return the list of cubes components that
   the piece occupies in space. Each piece is such that it is composed
   by either 4 or 5 cubes. *)
val components : t -> (int * int * int) list

(** The color chosen when displaying that particular piece. *)
val color : t -> Color.t
