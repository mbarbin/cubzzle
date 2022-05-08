(* ==============================================================================*)
(*                  JEU D'EMBOITEMENT DE PIECE DE BOIS : boite.ml                *)
(*                        Mathieu BARBIN, Mai 2007                               *)
(* ==============================================================================*)

(* Convention dans l'affichage "texte" des tranches : *)

(* -le point (0,0,0) est en haut a gauche *)
(* -on affiche de haut en bas les tranches pour z croissant *)

(* Relief d'entré : Meme convention que pour l'affichage *)

(* #load "graphics.cma";; *)
open Core
open Graphics

(* ==============================================================================*)
(* LES CONSTANTES DU JEU  : LA TAILLE DE LA BOITE, LES PIECES ET LA FORME VOULUE *)
(* ==============================================================================*)

(* Dimensions de la boite, relief *)

let the_shape = Z_shape.Sample.cube

(* la boite *)
let { Coordinate.x = tx; y = ty; z = tz } = Z_shape.size the_shape

(* les pieces sont donnees sous forme d'une liste de coordonnees *)
(* (x,y,z) reperant dans l'espace les cubes qui constituent la piece *)

let les_pieces = Array.of_list Piece.all
let all = [ 1; 2; 3; 4; 5; 6 ]
let largeur_cube = 60
let pi = Float.acos (-1.)
let theta_cube = pi /. 4.
let p_profil = 0.8
let ouvre_graphe () = open_graph " 1000x620"
let cOO = 500, 300 - (tz * 30)

(* coordonnee d'origine de la boite *)
let cPP = 20, 500

(* coordonnee d'origine des pieces *)

(* ==============================================================================*)
(*                 LA_BOITE ET LE_RELIEF : VARIABLES GLOBALES                    *)
(* ==============================================================================*)

(* type boite, et boite_factory *)

type une_boite =
  { mutable id : int
  ; tab : int array array array
  }

let boite_factory () =
  let t = Array.create ~len:tx [| [||] |] in
  for x = 0 to tx - 1 do
    t.(x) <- Array.create ~len:ty [||];
    for y = 0 to ty - 1 do
      t.(x).(y) <- Array.create ~len:tz 0
    done
  done;
  { id = 0; tab = t }
;;

(* creation des variables globales : la_boite et le_relief *)

let la_boite = boite_factory ()
let le_relief = Z_shape.sections the_shape

(* ==============================================================================*)
(*       OUTIL DE DESSIN / Affichage en perspective                              *)
(* ==============================================================================*)

let ( |*. ) i f = int_of_float (float i *. f)

let findi_piece_by_color color =
  List.find_mapi Piece.all ~f:(fun i piece ->
      if Color.is_rough_match (Piece.color piece) ~possibly_darkened:color
      then Some (i, piece)
      else None)
;;

let enleve_elmt e list =
  let rec f_aux list =
    match list with
    | [] -> []
    | t :: q when t = e -> f_aux q
    | t :: q -> t :: f_aux q
  in
  list := f_aux !list
;;

let draw_poly r =
  let a, b = Graphics.current_point () in
  let x0, y0 = r.(0) in
  Graphics.moveto x0 y0;
  for i = 1 to Array.length r - 1 do
    let x, y = r.(i) in
    Graphics.lineto x y
  done;
  Graphics.lineto x0 y0;
  Graphics.moveto a b
;;

(* on dessine en perspective avec une vue depuis en haut à gauche. *)
(* luminausité différente sur la face haute, et sur la face gauche *)

let draw_cube (x, y) largeur delta_x delta_y coul =
  (* face_avant *)
  set_color (Color.darken coul ~darken_factor:Light);
  fill_poly [| x, y; x + largeur, y; x + largeur, y + largeur; x, y + largeur; x, y |];
  (* contours *)
  set_color (rgb 60 60 60);
  draw_poly [| x, y; x + largeur, y; x + largeur, y + largeur; x, y + largeur; x, y |];
  (* face haute *)
  set_color (Color.darken coul ~darken_factor:Strong);
  fill_poly
    [| x, y + largeur
     ; x + largeur, y + largeur
     ; x + largeur + delta_x, y + largeur + delta_y
     ; x + delta_x, y + largeur + delta_y
     ; x, y + largeur
    |];
  (* contours *)
  set_color (rgb 60 60 60);
  draw_poly
    [| x, y + largeur
     ; x + largeur, y + largeur
     ; x + largeur + delta_x, y + largeur + delta_y
     ; x + delta_x, y + largeur + delta_y
     ; x, y + largeur
    |];
  (* face gauche *)
  set_color (Color.darken coul ~darken_factor:Medium);
  fill_poly
    [| x + largeur, y
     ; x + largeur, y + largeur
     ; x + largeur + delta_x, y + largeur + delta_y
     ; x + largeur + delta_x, y + delta_y
     ; x + largeur, y
    |];
  (* contours *)
  set_color (rgb 60 60 60);
  draw_poly
    [| x + largeur, y
     ; x + largeur, y + largeur
     ; x + largeur + delta_x, y + largeur + delta_y
     ; x + largeur + delta_x, y + delta_y
     ; x + largeur, y
    |]
;;

(*
   set_color black;
   moveto (x+2) (y+2);
   draw_string (string_of_int num); *)

let draw_boite (a, b) list_id =
  let delta_x = largeur_cube |*. p_profil |*. Float.cos theta_cube
  and delta_y = largeur_cube |*. p_profil |*. Float.sin theta_cube in
  clear_graph ();
  for j = 0 to ty - 1 do
    for k = 0 to tz - 1 do
      for i = 0 to tx - 1 do
        let n = la_boite.tab.(i).(j).(k) in
        if n <> 0 && List.mem list_id n ~equal:Int.equal
        then (
          let xM = a - (delta_x * j) + (largeur_cube * i)
          and yM = b - (delta_y * j) + (largeur_cube * k)
          and coul = Piece.color les_pieces.(n - 1) in
          draw_cube (xM, yM) largeur_cube delta_x delta_y coul)
        else ()
      done
    done
  done
;;

let draw_pieces (a, b) =
  let delta_x = largeur_cube / 2 |*. p_profil |*. Float.cos theta_cube
  and delta_y = largeur_cube / 2 |*. p_profil |*. Float.sin theta_cube
  and nb_pieces = Array.length les_pieces in
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
  for i = 0 to nb_pieces - 1 do
    dessine_piece les_pieces.(i) (a, b - (i * (largeur_cube * 13) / 8))
  done
;;

(* ==============================================================================*)
(*            SAUVER LES SOLUTIONS : VARIABLE GLOBALE LES_SOLUTIONS              *)
(* ==============================================================================*)

(* Nombre maximal autorise de solutions : max_sol *)
let max_sol = 50

(* Stocage des solutions *)

type table_solutions =
  { mutable nb : int
  ; sol : une_boite array
  }

let tab_solutions_factory taille =
  let boite_locale = boite_factory () in
  let t_out = Array.create ~len:taille boite_locale in
  for i = 0 to taille - 1 do
    t_out.(i) <- boite_factory ()
  done;
  { nb = 0; sol = t_out }
;;

(* Creation de la variable globale : les_solutions *)

let les_solutions = tab_solutions_factory max_sol

(* ==============================================================================*)
(*      FONCTIONS D'AFFICHAGE PAR TRANCHE DE LA_BOITE, ET LES_SOLUTIONS          *)
(* ==============================================================================*)

(* Affichage par tranche du contenu de la boite *)

let affiche_tranches une_boite =
  for k = 0 to tz - 1 do
    print_string "\n";
    print_string ("Face " ^ string_of_int (k + 1) ^ "\n");
    print_string "\n";
    for j = 0 to ty - 1 do
      for i = 0 to tx - 1 do
        print_string (string_of_int une_boite.tab.(i).(j).(k))
      done;
      print_string "\n"
    done;
    print_string "\n"
  done
;;

(* affichage par tranche de les_solutions *)

let affiche_les_solutions () =
  let n = les_solutions.nb in
  print_string "\n";
  print_string "\n";
  print_string " ==============================\n";
  print_string "|| Resultat de la recherche : ||\n";
  print_string " ==============================\n";
  print_string "\n";
  print_string ("Il y a " ^ string_of_int n ^ " solution");
  if n > 1 then print_string "s" else ();
  print_string " (a rotations pres)\n";
  print_string "\n";
  for i = 0 to n - 1 do
    affiche_tranches les_solutions.sol.(i)
  done
;;

(* ==============================================================================*)
(*      FONCTIONS DE ROTATION DES PIECES DANS L'ESPACE, POUR EMBOITEMENT         *)
(*        3 rotations de base a combiner : selon les 3 axes Ox, Oy,Oz            *)
(* ==============================================================================*)

let identite x = x
let rotx (a, b, c) = a, -c, b
let roty (a, b, c) = c, b, -a
let rotz (a, b, c) = -b, a, c

(* Les fonctions rond et compose3 *)
(* rond calcule les puissances d'une fonction f (une rotation) *)

let rond f n =
  let rec f_aux p =
    match p with
    | 0 -> identite
    | _ ->
      (function
      | x -> f ((f_aux (p - 1)) x))
  in
  f_aux n
;;

let compose3 f1 f2 f3 = function
  | t -> f1 (f2 (f3 t))
;;

(* On peut combiner 3 rotations *)
(* chacune peut etre sur 0, 1/4, 1/2 ou 3/4 de tour *)

(* Convention : On commence par l'axe Oz, puis Oy, et Ox *)
(* On note chaque combinaison de rotation sous la forme d'un triplet *)
(* Par exemple (rx,ry,rz) designe la rotation suivante : *)
(* rz /4 de tour sur Oz, puis ry/4 de tour sur Oy, puis rx/4 de tour sur Ox *)

(* A ne pas confondre avec les triplets designant des coordonnees ! *)

(* On compte donc 4*4*4=64 possibilites, ce qui est redondant. *)
(* Economie de rotations, 24 possiblites dans le cas d'un relief cubique *)

let rot_n i =
  match i with
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
  | _ -> 0, 0, 0
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

let in_borne (a, b, c) =
  0 <= a
  && a < tx
  && 0 <= b
  && b < ty
  && le_relief.(a).(b).bottom <= c
  && c < le_relief.(a).(b).top
;;

(* la case est elle libre dans la_boite ?? *)

let case_libre (a, b, c) =
  if in_borne (a, b, c) then la_boite.tab.(a).(b).(c) = 0 else false
;;

(* Effacer la derniere piece inseree dans la boite *)
(* mis a jour du champ id *)

let effacer_derniere_piece () =
  let n = la_boite.id in
  for i = 0 to tx - 1 do
    for j = 0 to ty - 1 do
      for k = 0 to tz - 1 do
        if la_boite.tab.(i).(j).(k) = n then la_boite.tab.(i).(j).(k) <- 0 else ()
      done
    done
  done;
  print_string ".";
  la_boite.id <- (if n = 0 then 0 else n - 1)
;;

(* On teste : Une insertion est-elle possible ?? *)
(* On donne une piece, une combinaison de rotation *)
(* et une case de depart pour l'insertion *)

let insertion_possible piece (rx, ry, rz) (x0, y0, z0) =
  let frot = compose3 (rond rotx rx) (rond roty ry) (rond rotz rz) in
  let rec f_aux liste_t =
    match liste_t with
    | [] -> true
    | tr :: q ->
      (match frot tr with
      | a, b, c -> case_libre (a + x0, b + y0, c + z0) && f_aux q)
  in
  f_aux (Piece.components piece)
;;

(* Apres avoir effectue le test, on peut inserer *)

let insertion piece (rx, ry, rz) (x0, y0, z0) =
  let n = la_boite.id + 1
  and frot = compose3 (rond rotx rx) (rond roty ry) (rond rotz rz) in
  let rec f_aux liste_t =
    match liste_t with
    | [] -> ()
    | tr :: q ->
      (match frot tr with
      | a, b, c ->
        la_boite.tab.(a + x0).(b + y0).(c + z0) <- n;
        f_aux q)
  in
  f_aux (Piece.components piece);
  draw_boite cOO all;
  la_boite.id <- n
;;

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

let rec emboite_rec liste_pieces =
  match liste_pieces with
  | [] -> raise (Failure "Les pieces sont maintenant emboitees")
  | pc :: q ->
    for x0 = 0 to tx - 1 do
      for y0 = 0 to ty - 1 do
        for z0 = 0 to tz - 1 do
          for n = 1 to 24 do
            if la_boite.tab.(x0).(y0).(z0) = 0
               && insertion_possible pc (rot_n n) (x0, y0, z0)
            then (
              insertion pc (rot_n n) (x0, y0, z0);
              emboite_rec q;
              (* Sort de la boucle avec l'exception ou revient par impossibilite*)
              effacer_derniere_piece ())
            else ()
          done
        done
      done
    done
;;

(* Effacer le contenu de la boite *)

let vider_la_boite () =
  for i = 0 to tx - 1 do
    for j = 0 to ty - 1 do
      for k = 0 to tz - 1 do
        la_boite.tab.(i).(j).(k) <- 0
      done
    done
  done;
  la_boite.id <- 0
;;

let tutoriel () =
  let idc = ref all in
  try
    while true do
      draw_boite cOO !idc;
      draw_pieces cPP;
      moveto 300 570;
      draw_string
        "Cliquer sur une piece pour l'enlever ou la remettre. Appuyer sur une touche \
         pour quitter.";
      let stat = wait_next_event [ Button_down; Key_pressed ] in
      if not (button_down ())
      then failwith "fin"
      else (
        let c = point_color stat.mouse_x stat.mouse_y in
        set_color c;
        match findi_piece_by_color c with
        | None -> ()
        | Some (i, _) ->
          let num = i + 1 in
          if List.mem !idc num ~equal:Int.equal
          then enleve_elmt num idc
          else idc := num :: !idc)
    done
  with
  | _ -> ()
;;

(* Affichage des resultats *)

let emboite liste_pieces =
  try
    vider_la_boite ();
    print_string "\n";
    print_string " Recherche en cours d'execution ";
    print_string "\n";
    ouvre_graphe ();
    emboite_rec liste_pieces;
    print_string "Aucune solution n'a ete trouvee.\n"
  with
  | _ ->
    print_string "\n";
    print_string "\n";
    affiche_tranches la_boite;
    draw_boite cOO all;
    tutoriel ();
    vider_la_boite ()
;;

(* ==============================================================================*)
(*       QUESTION : EST-CE LA SEULE COMBINAISON D'EMBOITEMENT POSSIBLE ?         *)
(* ==============================================================================*)

(* On cherche maintenant a determiner toutes les facons d'emboiter les pieces *)

(* Le principe est exactement le meme, seul le traitement du cas de base change. *)
(* On affiche l'etat de la boite, et on continue la recherche *)

(* On ne gere pas pour l'instant les redondances des solutions *)
(* c'est a dire qu'on trouve plusieurs fois les memes solutions *)
(* ou des solutions en rotation l'une avec l'autre. *)
(* Voir un peu plus loin pour cette question *)

let rec emboite_exhaustif_rec liste_pieces =
  match liste_pieces with
  | [] ->
    print_string "\n";
    print_string "\n";
    affiche_tranches la_boite;
    print_string "===================";
    print_string "\n"
  | pc :: q ->
    for x0 = 0 to tx - 1 do
      for y0 = 0 to ty - 1 do
        for z0 = 0 to tz - 1 do
          for n = 1 to 24 do
            if la_boite.tab.(x0).(y0).(z0) = 0
               && insertion_possible pc (rot_n n) (x0, y0, z0)
            then (
              insertion pc (rot_n n) (x0, y0, z0);
              emboite_exhaustif_rec q;
              (* Sort de la boucle avec l'exception ou revient par impossibilite*)
              effacer_derniere_piece ())
            else ()
          done
        done
      done
    done
;;

let _emboite_exhaustif liste_pieces =
  vider_la_boite ();
  print_string "\n";
  print_string " Recherche en cours d'execution ";
  print_string "\n";
  emboite_exhaustif_rec liste_pieces
;;

(* ==============================================================================*)
(*  RECHERCHE DES SOLUTIONS EN EVITANT LA REDONDANCE DE ROTATION ENTRE SOLUTIONS *)
(* ==============================================================================*)

(* Utilisation de la variable globale : les_solutions *)

(* Principe : *)

(* On effectue une recherche exhaustive des solutions.*)
(* Pour chaque solution trouvee, on verifie si elle n'est *)
(* pas en rotation avec une solution deja trouvee. *)

(* ======================================*)
(*        ROTATION D'UNE SOLUTION        *)
(* ======================================*)

(* Il ne s'agit plus de faire tourner une piece, mais la_boite toute entiere *)
(* le principe est le meme, et la barriere d'abstraction utilise des fonctions *)
(* en commun avec la rotation des pieces. *)

(* Fonctions sur les triplets coordonnees (x,y,z) pour la rotation d'une boite *)

(* identite : deja codee *)

let boite_rotx (a, b, c) = a, -c + tz - 1, b
let boite_roty (a, b, c) = c, b, -a + tx - 1
let boite_rotz (a, b, c) = -b + ty - 1, a, c

let rotation_boite boite_in (rx, ry, rz) =
  let boite_out = boite_factory ()
  and frot = compose3 (rond boite_rotx rx) (rond boite_roty ry) (rond boite_rotz rz) in
  for x = 0 to tx - 1 do
    for y = 0 to ty - 1 do
      for z = 0 to tz - 1 do
        match frot (x, y, z) with
        | a, b, c -> boite_out.tab.(a).(b).(c) <- boite_in.tab.(x).(y).(z)
      done
    done
  done;
  boite_out
;;

(* ======================================*)
(*        COMPARER DEUX SOLUTIONS        *)
(* ======================================*)

type comparaison_2_boites =
  | En_rotation
  | Differentes
[@@deriving equal]

(* Egalite stricte : *)

let egalite_boites boiteA boiteB =
  let accu_bool = ref true in
  for x = 0 to tx - 1 do
    for y = 0 to ty - 1 do
      for z = 0 to tz - 1 do
        accu_bool := !accu_bool && boiteA.tab.(x).(y).(z) = boiteB.tab.(x).(y).(z)
      done
    done
  done;
  !accu_bool
;;

(* Egalite apres rotation de la boite B ?? *)

let compare_boites boiteA boiteB =
  let i = ref 1
  and accu_bool = ref true in
  while !accu_bool && !i < 25 do
    accu_bool := not (egalite_boites boiteA (rotation_boite boiteB (rot_n !i)));
    i := !i + 1
  done;
  match !accu_bool with
  | true -> Differentes
  | false ->
    print_string (" (Rot : " ^ string_of_int (!i - 1) ^ ") ");
    En_rotation
;;

(* ======================================*)
(*    AJOUT D'UNE NOUVELLE SOLUTION      *)
(* ======================================*)

(* Copier le contenu d'un boite.tab dans un autre *)

let copy_tab_1_to_2 t1 t2 =
  for x = 0 to tx - 1 do
    for y = 0 to ty - 1 do
      for z = 0 to tz - 1 do
        t2.(x).(y).(z) <- t1.(x).(y).(z)
      done
    done
  done
;;

(* Comparaison de la nouvelle solution avec toutes les autres *)
(* Si la nouvelle n'est en rotation avec aucune, on l'ajoute *)

let ajoute_solution boiteA =
  let n = les_solutions.nb
  and accu_bool = ref true in
  for i = 0 to n - 1 do
    accu_bool
      := !accu_bool
         &&
         match compare_boites les_solutions.sol.(i) boiteA with
         | Differentes -> true
         | En_rotation -> false
  done;
  match !accu_bool with
  | false -> ()
  | true ->
    copy_tab_1_to_2 boiteA.tab les_solutions.sol.(n).tab;
    les_solutions.nb <- n + 1
;;

(* ======================================*)
(*   RECHERCHE AVEC TEST AVANT AJOUT     *)
(* ======================================*)

(* Recherche Exhaustive avec remplissage de les_solutions si Differentes *)

let rec chercher_les_solutions_rec liste_pieces =
  match liste_pieces with
  | [] ->
    print_string "\n";
    affiche_tranches la_boite;
    print_string
      ("=== Test avec les solutions existantes ( "
      ^ string_of_int les_solutions.nb
      ^ " solutions )");
    ajoute_solution la_boite;
    print_string "===\n";
    print_string "\n"
  | pc :: q ->
    for x0 = 0 to tx - 1 do
      for y0 = 0 to ty - 1 do
        for z0 = 0 to tz - 1 do
          for n = 1 to 24 do
            if la_boite.tab.(x0).(y0).(z0) = 0
               && insertion_possible pc (rot_n n) (x0, y0, z0)
            then (
              insertion pc (rot_n n) (x0, y0, z0);
              chercher_les_solutions_rec q;
              (* Sort de la boucle avec l'exception ou revient par impossibilite*)
              effacer_derniere_piece ())
            else ()
          done
        done
      done
    done
;;

(* Reinitialiser la variable les_solutions pour une nouvelle recherche *)

let efface_les_solutions () = les_solutions.nb <- 0

let _chercher_les_solutions liste_pieces =
  efface_les_solutions ();
  vider_la_boite ();
  print_string "\n";
  print_string " Recherche en cours d'execution ";
  print_string "\n";
  chercher_les_solutions_rec liste_pieces;
  affiche_les_solutions ()
;;

(* ==============================================================================*)
(*                     APPELS DE TEST, APPELS DE RECHERCHE                       *)
(* ==============================================================================*)

(* Pour trouver une solution : *)
let main () = emboite (Array.to_list les_pieces)

(* Pour trouver toutes les solutions exhaustivement avec redondance : *)
(* emboite_exhaustif les_pieces;; *)

(* Pour trouver toutes les solutions sans redondance : *)
(* chercher_les_solutions les_pieces;; *)
