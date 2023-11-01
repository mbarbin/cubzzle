module Box = Box
module Color = Color
module Coordinate = Coordinate
module Piece = Piece
module Rotation = Rotation
module Size = Size
module Z_shape = Z_shape

let pi = Float.acos (-1.)
let cube_width = 60

(* The angle used in the perspective between horizontal and diagonal cube edges. *)
let theta_cube = pi /. 4.

(* The length of the diagonal edge of the cubes seen in perspective. *)
let p_profile = 0.8

(* We draw the puzzle pieces to the left column of the window, and the box in
   the middle. *)
let box_offsets box = 500, 300 - ((Box.size box).z * 30)
let pieces_left_column_offsets = 20, 500

(* Scale an int by a float. *)
let ( |*. ) i f = Int.of_float (Float.of_int i *. f)

(* Draw 3 faces of a cube in perspective to imitate some basic 3D view. *)
let draw_cube (x, y) ~width ~delta_x ~delta_y ~color =
  let draw_face ~darken_factor points =
    (* Inner face. *)
    Graphics.set_color (Color.darken color ~darken_factor);
    Graphics.fill_poly points;
    (* Outline. *)
    Graphics.set_color (Graphics.rgb 60 60 60);
    Graphics.draw_poly points
  in
  (* Front face. *)
  draw_face
    ~darken_factor:Light
    [| x, y; x + width, y; x + width, y + width; x, y + width; x, y |];
  (* Upper face. *)
  draw_face
    ~darken_factor:Strong
    [| x, y + width
     ; x + width, y + width
     ; x + width + delta_x, y + width + delta_y
     ; x + delta_x, y + width + delta_y
     ; x, y + width
    |];
  (* Left face. *)
  draw_face
    ~darken_factor:Medium
    [| x + width, y
     ; x + width, y + width
     ; x + width + delta_x, y + width + delta_y
     ; x + width + delta_x, y + delta_y
     ; x + width, y
    |]
;;

module Shown_pieces : sig
  (* A mutable type to indicated which pieces are to be shown in the main drawing area. *)
  type t

  val all : unit -> t
  val mem : t -> Piece.t -> bool

  (* The UI allows for the user to click on pieces to switch between displaying
     or not displaying them. *)
  val toggle : t -> Piece.t -> unit
end = struct
  type t = bool array

  let all () = Array.create ~len:Piece.cardinality true
  let mem t piece = t.(Piece.to_index piece)

  let toggle t piece =
    let index = Piece.to_index piece in
    t.(index) <- not t.(index)
  ;;
end

(* Draw the box in the center of the window. Only draw the pieces present in
   [shown_pieces]. *)
let draw_box box ~shown_pieces =
  let delta_x = cube_width |*. p_profile |*. Float.cos theta_cube
  and delta_y = cube_width |*. p_profile |*. Float.sin theta_cube in
  let a, b = box_offsets box in
  let size = Box.size box in
  for j = 0 to size.y - 1 do
    for k = 0 to size.z - 1 do
      for i = 0 to size.x - 1 do
        match Box.contents box { x = i; y = j; z = k } with
        | None -> ()
        | Some piece ->
          if Shown_pieces.mem shown_pieces piece
          then (
            let xM = a - (delta_x * j) + (cube_width * i)
            and yM = b - (delta_y * j) + (cube_width * k)
            and color = Piece.color piece in
            draw_cube (xM, yM) ~width:cube_width ~delta_x ~delta_y ~color)
      done
    done
  done
;;

(* Draw all the pieces available to the left column of the window. *)
let draw_pieces () =
  let a, b = pieces_left_column_offsets in
  let delta_x = cube_width / 2 |*. p_profile |*. Float.cos theta_cube
  and delta_y = cube_width / 2 |*. p_profile |*. Float.sin theta_cube in
  let aux piece (a, b) =
    let color = Piece.color piece in
    List.iter (Piece.components piece) ~f:(fun { x = i; y = j; z = k } ->
      let xM = a - (delta_x * j) + (cube_width / 2 * i)
      and yM = b - (delta_y * j) + (cube_width / 2 * k) in
      draw_cube (xM, yM) ~width:(cube_width / 2) ~delta_x ~delta_y ~color)
  in
  List.iteri Piece.all ~f:(fun i piece -> aux piece (a, b - (i * (cube_width * 13) / 8)))
;;

(* Run a brute force search to try and insert all puzzle pieces into the box. If
   a solution is found, it will be in the box by the time this function returns. *)
let solve ~shape ~draw_box_during_search =
  let box = Box.create ~goal:(Z_shape.sample shape) in
  let size = Box.size box in
  let shown_pieces = Shown_pieces.all () in
  let rec aux (return : _ With_return.return) = function
    | [] -> return.return box
    | piece :: q ->
      for x0 = 0 to size.x - 1 do
        for y0 = 0 to size.y - 1 do
          for z0 = 0 to size.z - 1 do
            let offset = { Coordinate.x = x0; y = y0; z = z0 } in
            for rotation = 0 to Rotation.cardinality - 1 do
              let rotation = Rotation.of_index_exn rotation in
              match Box.Stack.push_piece box ~piece ~rotation ~offset with
              | Not_available -> ()
              | Inserted ->
                if draw_box_during_search
                then (
                  Graphics.clear_graph ();
                  draw_box box ~shown_pieces);
                aux return q;
                Box.Stack.pop_piece box
            done
          done
        done
      done
  in
  With_return.with_return_option (fun return -> aux return Piece.all)
;;

(* User UI which allows pieces to be taken out and put back to view how they
   fit. *)
let interactive_view box =
  let find_piece_by_color color =
    (* The user may click on any cube faces, which are darkened differently. *)
    List.find Piece.all ~f:(fun piece ->
      Color.is_rough_match (Piece.color piece) ~possibly_darkened:color)
  in
  let shown_pieces = Shown_pieces.all () in
  With_return.with_return (fun return ->
    while true do
      Graphics.clear_graph ();
      draw_box box ~shown_pieces;
      draw_pieces ();
      Graphics.moveto 300 570;
      Graphics.draw_string
        "Click on a piece to take it out or put it back. Press any key to quit.";
      let stat = Graphics.wait_next_event [ Button_down; Key_pressed ] in
      if not (Graphics.button_down ())
      then return.return ()
      else (
        match Graphics.point_color stat.mouse_x stat.mouse_y |> find_piece_by_color with
        | None -> ()
        | Some piece -> Shown_pieces.toggle shown_pieces piece)
    done)
;;

let run_cmd =
  let open Stdio in
  Command.basic
    ~summary:"run the solver"
    (let%map_open.Command shape =
       flag
         "shape"
         (optional_with_default
            Z_shape.Sample.Cube
            (Arg_type.enumerated_sexpable (module Z_shape.Sample)))
         ~doc:"SHAPE which shape to solve (default Cube)"
     and draw_box_during_search =
       flag
         "draw-box-during-search"
         (optional_with_default false bool)
         ~doc:"bool whether to draw incrementally during search (default false)"
     in
     fun () ->
       try
         Graphics.open_graph " 1000x620";
         Graphics.set_window_title "cubzzle";
         match solve ~shape ~draw_box_during_search with
         | None -> print_string "No solution found.\n"
         | Some box ->
           Box.print_floors box;
           Out_channel.flush stdout;
           interactive_view box
       with
       | Graphics.Graphic_failure _ -> ())
;;

let main = Command.group ~summary:"cube puzzle solver" [ "run", run_cmd ]
