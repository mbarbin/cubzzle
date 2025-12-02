(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Code_error = Code_error
module Dyn = Dyn
module Ordering = Ordering

let print pp = Format.printf "%a@." Pp.to_fmt pp
let print_dyn dyn = print (Dyn.pp dyn)
let phys_equal a b = a == b

module Comparable = struct
  module type S = sig
    type t

    val compare : t -> t -> Ordering.t
  end
end

module Array = struct
  include Stdlib.ArrayLabels

  let create ~len a = make len a
end

module Int = struct
  include Stdlib.Int

  let compare a b = Ordering.of_int (Int.compare a b)
end

module List = struct
  include Stdlib.ListLabels

  let find t ~f = find_opt ~f t
  let init len ~f = init ~len ~f
  let iter t ~f = iter ~f t

  let sort (type a) (module M : Comparable.S with type t = a) t =
    let cmp a b = Ordering.to_int (M.compare a b) in
    sort t ~cmp
  ;;
end

module Stack = struct
  include Stdlib.Stack

  let pop = pop_opt
  let push t a = push a t
end

let require_does_raise f =
  match f () with
  | _ -> Code_error.raise "Did not raise." []
  | exception e -> print_endline (Printexc.to_string e)
;;
