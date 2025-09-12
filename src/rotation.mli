(*_********************************************************************************)
(*_  cubzzle - Solver for a wooden cube puzzle                                    *)
(*_  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** Encoding ways of rotating a piece in space. *)

type t [@@deriving sexp_of]

(** The number of different rotations. *)
val cardinality : int

(** Rotations are ordered and indexed. The index may serve as efficient encoding. *)

(** [to_index t] returns the [index] of [t] in the total code set. It is
    guaranteed that [0 <= index < cardinality]. *)
val to_index : t -> int

(** [of_index index] returns the code at the given index. Indices are expected
    to verify [0 <= index < cardinality]. An invalid index will cause the
    function to raise. *)
val of_index_exn : int -> t

(** Apply the given rotation to a set of coordinates. *)
val apply : t -> Coordinate.t -> Coordinate.t
