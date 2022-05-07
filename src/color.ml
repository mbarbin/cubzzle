open! Core

type t = Graphics.color

let pieces = Graphics.[ blue; yellow; red; cyan; green; magenta ]

module Darken_factor = struct
  type t = int

  let denominator = 10
  let strong = 6
  let medium = 7
  let light = 8
  let all = [ strong; medium; light ]
end

let darken t (darken_factor : Darken_factor.t) =
  let scale i =
    int_of_float
      (float_of_int i
      *. (float_of_int darken_factor /. float_of_int Darken_factor.denominator))
  in
  let r, g, b = t / (256 * 256), t / 256 mod 256, t mod 256 in
  Graphics.rgb (scale r) (scale g) (scale b)
;;

let is_rough_match t1 ~possibly_darkened:t2 =
  if t1 = t2
  then true
  else
    with_return (fun r ->
        List.iter Darken_factor.all ~f:(fun darken_factor ->
            if t2 = darken t1 darken_factor then r.return true);
        false)
;;
