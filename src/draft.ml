(* ==============================================================================*)
(*                  JEU D'EMBOITEMENT DE PIECE DE BOIS : boite.ml                *)
(*                        Mathieu BARBIN, Mai 2007                               *)
(* ==============================================================================*)

(* Convention dans l'affichage "texte" des tranches : *)

(* -le point (0,0,0) est en haut a gauche *)
(* -on affiche de haut en bas les tranches pour z croissant *)

(* Relief d'entré : Meme convention que pour l'affichage *)

open! Core

(* ==============================================================================*)
(* LES CONSTANTES DU JEU  : LA TAILLE DE LA BOITE, LES PIECES ET LA FORME VOULUE *)
(* ==============================================================================*)

(* les pieces sont donnees sous forme d'une liste de coordonnees *)
(* (x,y,z) reperant dans l'espace les cubes qui constituent la piece *)

let largeur_cube = 60
let pi = Float.acos (-1.)
let theta_cube = pi /. 4.
let p_profil = 0.8
let cOO box = 500, 300 - ((Box.size box).z * 30)

(* coordonnee d'origine de la boite *)
let cPP = 20, 500

(* ==============================================================================*)
(*       OUTIL DE DESSIN / Affichage en perspective                              *)
(* ==============================================================================*)

let ( |*. ) i f = int_of_float (float i *. f)

let find_piece_by_color color =
  List.find Piece.all ~f:(fun piece ->
      Color.is_rough_match (Piece.color piece) ~possibly_darkened:color)
;;

(* on dessine en perspective avec une vue depuis en haut à gauche. *)
(* luminausité différente sur la face haute, et sur la face gauche *)

let draw_cube (x, y) largeur delta_x delta_y coul =
  (* face_avant *)
  Graphics.set_color (Color.darken coul ~darken_factor:Light);
  Graphics.fill_poly
    [| x, y; x + largeur, y; x + largeur, y + largeur; x, y + largeur; x, y |];
  (* contours *)
  Graphics.set_color (Graphics.rgb 60 60 60);
  Graphics.draw_poly
    [| x, y; x + largeur, y; x + largeur, y + largeur; x, y + largeur; x, y |];
  (* face haute *)
  Graphics.set_color (Color.darken coul ~darken_factor:Strong);
  Graphics.fill_poly
    [| x, y + largeur
     ; x + largeur, y + largeur
     ; x + largeur + delta_x, y + largeur + delta_y
     ; x + delta_x, y + largeur + delta_y
     ; x, y + largeur
    |];
  (* contours *)
  Graphics.set_color (Graphics.rgb 60 60 60);
  Graphics.draw_poly
    [| x, y + largeur
     ; x + largeur, y + largeur
     ; x + largeur + delta_x, y + largeur + delta_y
     ; x + delta_x, y + largeur + delta_y
     ; x, y + largeur
    |];
  (* face gauche *)
  Graphics.set_color (Color.darken coul ~darken_factor:Medium);
  Graphics.fill_poly
    [| x + largeur, y
     ; x + largeur, y + largeur
     ; x + largeur + delta_x, y + largeur + delta_y
     ; x + largeur + delta_x, y + delta_y
     ; x + largeur, y
    |];
  (* contours *)
  Graphics.set_color (Graphics.rgb 60 60 60);
  Graphics.draw_poly
    [| x + largeur, y
     ; x + largeur, y + largeur
     ; x + largeur + delta_x, y + largeur + delta_y
     ; x + largeur + delta_x, y + delta_y
     ; x + largeur, y
    |]
;;

let draw_boite box ~filter:pieces =
  let delta_x = largeur_cube |*. p_profil |*. Float.cos theta_cube
  and delta_y = largeur_cube |*. p_profil |*. Float.sin theta_cube in
  let a, b = cOO box in
  let size = Box.size box in
  for j = 0 to size.y - 1 do
    for k = 0 to size.z - 1 do
      for i = 0 to size.x - 1 do
        match Box.contents box { x = i; y = j; z = k } with
        | None -> ()
        | Some piece ->
          if List.mem pieces piece ~equal:Piece.equal
          then (
            let xM = a - (delta_x * j) + (largeur_cube * i)
            and yM = b - (delta_y * j) + (largeur_cube * k)
            and coul = Piece.color piece in
            draw_cube (xM, yM) largeur_cube delta_x delta_y coul)
      done
    done
  done
;;

let draw_pieces (a, b) =
  let delta_x = largeur_cube / 2 |*. p_profil |*. Float.cos theta_cube
  and delta_y = largeur_cube / 2 |*. p_profil |*. Float.sin theta_cube in
  let dessine_piece piece (a, b) =
    let color = Piece.color piece in
    let rec f_aux liste_t =
      match liste_t with
      | [] -> ()
      | (i, j, k) :: q ->
        let xM = a - (delta_x * j) + (largeur_cube / 2 * i)
        and yM = b - (delta_y * j) + (largeur_cube / 2 * k) in
        draw_cube (xM, yM) (largeur_cube / 2) delta_x delta_y color;
        f_aux q
    in
    f_aux (Piece.components piece)
  in
  List.iteri Piece.all ~f:(fun i piece ->
      dessine_piece piece (a, b - (i * (largeur_cube * 13) / 8)))
;;

(* ==============================================================================*)
(*                     INSERER, EFFACER DES PIECES DANS LA_BOITE                 *)
(* ==============================================================================*)

(* Dans la_boite: *)

(* On va inserer des pieces dans la boite *)
(* Lorsqu'on insere la premiere piece, on donne la valeur 1 a toutes les cases *)
(* de la_boite qui deviennent occupees par cette piece. *)
(* Lorsqu'on insere la deuxieme piece, on donne la valeur 2 a toutes les cases *)
(* de la_boite qui deviennent occupees par cette piece, et ainsi de suite *)

(* Le champ id de la_boite sert a retenir la valeur de la derniere piece inseree *)

(* Une seule operation d'effacement est possible dans la_boite, *)
(* c'est d'effacer la derniere piece inseree, a la maniere d'une pile. *)

(* On insere tuojours une piece a partir d'une case de depart, (x0,y0,z0) *)

(* Verification de l'appartenance d'une case (a,b,c) dans le relief *)

(* la case est elle libre dans la_boite ?? *)

(* ==============================================================================*)
(* VIF DU SUJET : TROUVER UNE COMBINAISON D'EMBOITEMENT DES PIECES DANS LA_BOITE *)
(* ==============================================================================*)

(* Principe recursif : *)
(* On insere dans la_boite les pieces de la liste passee en argument *)

(* Cas de base : *)

(* la liste est vide, on a insere toutes les pieces *)
(* Dans ce cas, on leve une exception pour sortir des appels recursif *)
(* la_boite contient toutes les pieces, et on peut l'afficher par tranche *)

(* La liste n'est pas vide : *)

(* Il faut essayer d'inserer la premiere piece de la liste, en trouvant *)
(* une case de depart opportune, et une rotation opportune *)
(* Si aucune place ne convient, la fonctions s'arrette en rendant unit *)

(* Si on trouve une place pour l'insertion, alors on effectue cette insertion *)
(* et on rappelle la fonction avec la queue de la liste.*)
(* Rappelons que la_boite qui est une variable globale, change au fur et a mesure *)

(* En effectuant l'appel recursif, 2 cas peuvent se presenter : *)

(* le cas de base : une exception, on a trouve une combinaison d'emboitement *)
(* On est sorti de la fonction, le probleme est resolu. *)

(* un unit, signifiant qu'avec un tel etat de la boite, il est impossible *)
(* d'emboiter le reste des pieces. *)
(* Il faut donc revenir en arriere, effacer la derniere piece inseree *)
(* et trouver une autre facon de l'inserer qui sera compatible avec *)
(* l'insertion du reste des pieces de la queue. *)
(* Pour ce faire, on balaye toutes les possibilites d'insertion des pieces *)
(* a chaque etape. *)

let rec emboite_rec return box = function
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
              Graphics.clear_graph ();
              draw_boite box Piece.all;
              emboite_rec return box q;
              Box.Stack.pop_piece box
          done
        done
      done
    done
;;

let tutoriel box =
  let idc = ref Piece.all in
  with_return (fun return ->
      while true do
        Graphics.clear_graph ();
        draw_boite box !idc;
        draw_pieces cPP;
        Graphics.moveto 300 570;
        Graphics.draw_string
          "Cliquer sur une piece pour l'enlever ou la remettre. Appuyer sur une touche \
           pour quitter.";
        let stat = Graphics.wait_next_event [ Button_down; Key_pressed ] in
        if not (Graphics.button_down ())
        then return.return ()
        else (
          let c = Graphics.point_color stat.mouse_x stat.mouse_y in
          match find_piece_by_color c with
          | None -> ()
          | Some piece ->
            if List.mem !idc piece ~equal:Piece.equal
            then idc := List.filter !idc ~f:(fun i -> not (Piece.equal i piece))
            else idc := piece :: !idc)
      done)
;;

(* Affichage des resultats *)

let emboite box liste_pieces =
  Graphics.open_graph " 1000x620";
  match
    with_return (fun return ->
        emboite_rec return box liste_pieces;
        false)
  with
  | false -> print_string "Aucune solution n'a ete trouvee.\n"
  | true ->
    print_string "\n";
    print_string "\n";
    Box.print_layers box;
    tutoriel box
;;

(* ==============================================================================*)
(*                     APPELS DE TEST, APPELS DE RECHERCHE                       *)
(* ==============================================================================*)

let main () = emboite (Box.create ~goal:Z_shape.Sample.cube) Piece.all
