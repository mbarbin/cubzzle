(*_********************************************************************************)
(*_  cubzzle - Solver for a wooden cube puzzle                                    *)
(*_  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** The pieces that constitutes the puzzle. *)
type t [@@deriving equal, enumerate]

val cardinality : int
(** The number of pieces. In this version of the puzzle, that's 6. *)

(** Pieces are ordered and indexed. The index may serve as efficient encoding.
*)

val to_index : t -> int
(** [to_index t] returns the [index] of [t] in the total code set. It is
    guaranteed that [0 <= index < cardinality]. *)

val of_index_exn : int -> t
(** [of_index index] returns the code at the given index. Indices are expected
    to verify [0 <= index < cardinality]. An invalid index will cause the
    function to raise. *)

val components : t -> Coordinate.t list
(** Starting from (0, 0, 0), and following one particular way that piece can be
    positioned, return the list of cubes components that the piece occupies in
    space. Each piece is such that it is composed by either 4 or 5 cubes. *)

val color : t -> Color.t
(** The color chosen when displaying that particular piece. *)
