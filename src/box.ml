(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t =
  { size: Size.t
  ; z_sections: Z_shape.Z_section.t array array
  ; contents: Piece.t option array array array
  ; piece_stack: Piece.t Stack.t }

let size t = t.size

let create ~goal:z_shape =
  let size = Z_shape.size z_shape in
  let contents = Array.make_matrix ~dimx:size.x ~dimy:size.y [||] in
  for i = 0 to size.x - 1 do
    for j = 0 to size.y - 1 do
      contents.(i).(j) <- Array.create ~len:size.z None
    done
  done ;
  { size
  ; z_sections= Z_shape.sections z_shape
  ; contents
  ; piece_stack= Stack.create () }

let in_bound t {Coordinate.x; y; z} =
  0 <= x && x < t.size.x && 0 <= y && y < t.size.y
  && t.z_sections.(x).(y).bottom <= z
  && z < t.z_sections.(x).(y).top

let is_available t ({Coordinate.x; y; z} as c) =
  in_bound t c && Option.is_none t.contents.(x).(y).(z)

let contents t ({Coordinate.x; y; z} as c) =
  if in_bound t c then t.contents.(x).(y).(z) else None

module Stack = struct
  let pop_piece t =
    match Stack.pop t.piece_stack with
    | None ->
        ()
    | Some piece ->
        for i = 0 to t.size.x - 1 do
          for j = 0 to t.size.y - 1 do
            for k = 0 to t.size.z - 1 do
              match t.contents.(i).(j).(k) with
              | None ->
                  ()
              | Some p ->
                  if Piece.equal piece p then t.contents.(i).(j).(k) <- None
            done
          done
        done

  module Push_piece_result = struct
    type t = Inserted | Not_available
  end

  let insertion_is_possible t ~piece ~rotation ~offset =
    List.for_all (Piece.components piece) ~f:(fun component ->
        let rotated = Rotation.apply rotation component in
        is_available t (Coordinate.add rotated ~offset) )

  let push_piece t ~piece ~rotation ~offset =
    match insertion_is_possible t ~piece ~rotation ~offset with
    | false ->
        Push_piece_result.Not_available
    | true ->
        List.iter (Piece.components piece) ~f:(fun component ->
            match
              Rotation.apply rotation component |> Coordinate.add ~offset
            with
            | {x; y; z} ->
                t.contents.(x).(y).(z) <- Some piece ) ;
        Stack.push t.piece_stack piece ;
        Push_piece_result.Inserted
end

let print_floors t =
  let open Stdio in
  for k = t.size.z - 1 downto 0 do
    print_string "\n" ;
    print_string ("Floor " ^ Int.to_string (k + 1) ^ "\n") ;
    print_string "\n" ;
    for j = 0 to t.size.y - 1 do
      for i = 0 to t.size.x - 1 do
        let value =
          match t.contents.(i).(j).(k) with
          | None ->
              "0"
          | Some piece ->
              Int.to_string (Piece.to_index piece + 1)
        in
        print_string value
      done ;
      print_string "\n"
    done ;
    print_string "\n"
  done
