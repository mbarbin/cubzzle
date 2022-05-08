open! Core

let raw_components =
  [| [ 0, 0, 0; 1, 0, 0; 1, 0, 1; 2, 0, 0; 2, 1, 0 ]
   ; [ 0, 0, 0; 1, 0, 0; 1, 1, 0; 1, 0, 1; 2, 1, 0 ]
   ; [ 0, 0, 0; 1, 0, 0; 2, 0, 0; 1, 1, 0; 1, 1, 1 ]
   ; [ 0, 0, 0; 1, 0, 0; 1, 1, 0; 1, 1, 1 ]
   ; [ 0, 0, 0; 1, 0, 0; 1, 0, 1; 2, 0, 0 ]
   ; [ 0, 0, 0; 1, 0, 0; 2, 0, 0; 2, 0, 1 ]
  |]
;;

let cardinality = Array.length raw_components

module Index = struct
  type t = int

  let all = List.init cardinality ~f:Fn.id
end

type t = Index of Index.t [@@deriving enumerate]

let components (Index i) = raw_components.(i)

let color =
  let colors = Array.of_list Color.pieces in
  assert (Array.length colors >= cardinality);
  fun (Index i) -> colors.(i)
;;
