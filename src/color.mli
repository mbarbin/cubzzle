open! Core

type t = Graphics.color [@@deriving compare, equal, hash, sexp_of]

(** The color chosen when displaying the puzzle pieces. *)
val pieces : t list

val to_rgb : t -> int * int * int

module Darken_factor : sig
  (** A factor to darken a color. There's 3 different factors that we use here
      depending of how much we want to darken the color. The stronger factor
      leads to the color that is the darkest. *)
  type t =
    | None
    | Light
    | Medium
    | Strong
  [@@deriving enumerate]
end

val darken : t -> darken_factor:Darken_factor.t -> t

(** [is_rough_match t1 ~possibly_darkened:t2] returns [true] if [t1] and [t2]
    are the same colors, or if [t2] is a darkened version of [t1] using one of
    the [Darken_factor.t] in use. *)
val is_rough_match : t -> possibly_darkened:t -> bool
