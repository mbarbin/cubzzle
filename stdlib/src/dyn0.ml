(*********************************************************************************)
(*  cubzzle - Solver for a wooden cube puzzle                                    *)
(*  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

include Dyn

let print t = print_string (Dyn.to_string t)

exception E of string * Dyn.t

let () =
  Printexc.register_printer (function
    | E (msg, dyn) -> Some (msg ^ "\n" ^ Dyn.to_string dyn)
    | _ -> None [@coverage off])
;;

let raise msg fields = raise (E (msg, Dyn.record fields))
