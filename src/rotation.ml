type t = int

module Description = struct
  (* A rotation is described by the decomposition of its 3 rotations components,
     along the axes Oz, Oy and Ox.

     The value associated with each axes represents the number of quarter turns
     to apply, which may be 0, 1, 2 or 3. *)
  type t =
    { rz : int
    ; ry : int
    ; rx : int
    }
  [@@deriving sexp_of]
end

(* Given that each axes can take 4 values, and there are 3 axes, the total
   number of expanded combination is 4^3=64. In practice it is enough to
   restrict the set of rotations to the following 24 to avoid redundancy. *)
let rot_n = function
  | 1 -> 0, 0, 0
  | 2 -> 1, 0, 0
  | 3 -> 2, 0, 0
  | 4 -> 3, 0, 0
  | 5 -> 0, 0, 1
  | 6 -> 0, 1, 1
  | 7 -> 0, 2, 1
  | 8 -> 0, 3, 1
  | 9 -> 0, 0, 2
  | 10 -> 1, 0, 2
  | 11 -> 2, 0, 2
  | 12 -> 3, 0, 2
  | 13 -> 0, 0, 3
  | 14 -> 0, 1, 3
  | 15 -> 0, 2, 3
  | 16 -> 0, 3, 3
  | 17 -> 1, 0, 1
  | 18 -> 1, 1, 1
  | 19 -> 1, 2, 1
  | 20 -> 1, 3, 1
  | 21 -> 1, 0, 3
  | 22 -> 1, 1, 3
  | 23 -> 1, 2, 3
  | 24 -> 1, 3, 3
  | index -> raise_s [%sexp "Index out of bounds", [%here], (index : int)]
;;

let description t =
  let rz, ry, rx = rot_n (t + 1) in
  { Description.rz; ry; rx }
;;

let sexp_of_t t = [%sexp (description t : Description.t)]
let cardinality = 24
let to_index t = t

let of_index_exn index =
  if not (0 <= index && index < cardinality)
  then raise_s [%sexp "Index out of bounds", { index : int; cardinality : int }];
  index
;;

let rx { Coordinate.x; y; z } = { Coordinate.x; y = -z; z = y }
let ry { Coordinate.x; y; z } = { Coordinate.x = z; y; z = -x }
let rz { Coordinate.x; y; z } = { Coordinate.x = -y; y = x; z }
let rec apply_n f n x = if n <= 0 then x else apply_n f (Int.pred n) (f x)

let apply t coordinate =
  let d = description t in
  coordinate |> apply_n rz d.rz |> apply_n ry d.ry |> apply_n rx d.rx
;;
