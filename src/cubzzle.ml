open! Core
module Box = Box
module Color = Color
module Z_shape = Z_shape

let pi = Float.acos (-1.)
let cube_width = 60

(* The angle used in the perspective between horizontal and diagonal cube edges. *)
let theta_cube = pi /. 4.

(* The length of the diagonal edge of the cubes seen in perspective. *)
let p_profile = 0.8

(* We draw the puzzle pieces to the left column of the window, and the
   box in the middle. *)
let box_offsets box = 500, 300 - ((Box.size box).z * 30)
let pieces_left_column_offsets = 20, 500

(* scale an int by a float. *)
let ( |*. ) i f = int_of_float (float i *. f)

(* Draw 3 faces of a cube in perspective to immitate some basic 3D view. *)
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

(* Draw the box in the center of the window. Only draw the pieces present in [shown_pieces]. *)
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
          if List.mem shown_pieces piece ~equal:Piece.equal
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

(* Run a brute force search to try and insert all puzzle pieces into the box. *)
let rec search return box ~draw_box_during_search = function
  | [] -> return.return true
  | piece :: q ->
    let size = Box.size box in
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
                draw_box box ~shown_pieces:Piece.all);
              search return box q ~draw_box_during_search;
              Box.Stack.pop_piece box
          done
        done
      done
    done

(* If a solution is found, it will be in the box by the time this function returns. *)
and has_solution box ~draw_box_during_search =
  with_return (fun return ->
      search return box Piece.all ~draw_box_during_search;
      false)
;;

let solve ~shape =
  let box = Box.create ~goal:(Z_shape.sample shape) in
  match has_solution box ~draw_box_during_search:false with
  | false -> None
  | true -> Some box
;;

(* User UI which allows pieces to be taken out and put back to view how they fit. *)
let interactive_view box =
  let find_piece_by_color color =
    (* The user may click on any cube faces, which are darkened differently. *)
    List.find Piece.all ~f:(fun piece ->
        Color.is_rough_match (Piece.color piece) ~possibly_darkened:color)
  in
  let shown_pieces = ref Piece.all in
  with_return (fun return ->
      while true do
        Graphics.clear_graph ();
        draw_box box ~shown_pieces:!shown_pieces;
        draw_pieces ();
        Graphics.moveto 300 570;
        Graphics.draw_string
          "Click on a piece to take it out or put it back. Press any key to quit.";
        let stat = Graphics.wait_next_event [ Button_down; Key_pressed ] in
        if not (Graphics.button_down ())
        then return.return ()
        else (
          let c = Graphics.point_color stat.mouse_x stat.mouse_y in
          match find_piece_by_color c with
          | None -> ()
          | Some piece ->
            shown_pieces
              := if List.mem !shown_pieces piece ~equal:Piece.equal
                 then List.filter !shown_pieces ~f:(fun i -> not (Piece.equal i piece))
                 else piece :: !shown_pieces)
      done)
;;

let run_cmd =
  Command.basic
    ~summary:"run the solver"
    (let%map_open.Command goal =
       flag
         "shape"
         (optional_with_default
            Z_shape.Sample.Cube
            (Arg_type.enumerated_sexpable (module Z_shape.Sample)))
         ~doc:"SHAPE which shape to solve"
       >>| Z_shape.sample
     in
     fun () ->
       let box = Box.create ~goal in
       Graphics.open_graph " 1000x620";
       match has_solution box ~draw_box_during_search:true with
       | false -> print_string "No solution found.\n"
       | true ->
         Box.print_floors box;
         Out_channel.flush stdout;
         interactive_view box)
;;

let main = Command.group ~summary:"cube puzzle solver" [ "run", run_cmd ]
