open! Base

let raw_components =
  [| [ 0, 0, 0; 1, 0, 0; 1, 0, 1; 2, 0, 0; 2, 1, 0 ]
   ; [ 0, 0, 0; 1, 0, 0; 1, 1, 0; 1, 0, 1; 2, 1, 0 ]
   ; [ 0, 0, 0; 1, 0, 0; 2, 0, 0; 1, 1, 0; 1, 1, 1 ]
   ; [ 0, 0, 0; 1, 0, 0; 1, 1, 0; 1, 1, 1 ]
   ; [ 0, 0, 0; 1, 0, 0; 1, 0, 1; 2, 0, 0 ]
   ; [ 0, 0, 0; 1, 0, 0; 2, 0, 0; 2, 0, 1 ]
  |]
  |> Array.map ~f:(List.map ~f:(fun (x, y, z) -> { Coordinate.x; y; z }))
;;

let cardinality = Array.length raw_components

module Index = struct
  type t = int [@@deriving equal]

  let all = List.init cardinality ~f:Fn.id
end

type t = Index of Index.t [@@deriving equal, enumerate]

let to_index (Index index) = index

let of_index_exn index =
  if not (0 <= index && index < cardinality)
  then raise_s [%sexp "Index out of bounds", [%here], (index : int)];
  Index index
;;

let components (Index i) = raw_components.(i)

let color =
  let colors = Array.of_list Color.pieces in
  assert (Array.length colors >= cardinality);
  fun (Index i) -> colors.(i)
;;
