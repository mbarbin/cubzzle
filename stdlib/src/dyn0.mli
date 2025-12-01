(*_********************************************************************************)
(*_  cubzzle - Solver for a wooden cube puzzle                                    *)
(*_  SPDX-FileCopyrightText: 2022-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** {1 Including dune's Dyn module}

    This module is designed to shadow dune's [Dyn] module. As such it re-exports
    its original interface. *)

include module type of struct
  include Dyn
end

(** {1 Expect test helpers} *)

(** Print the expression on [stdout] for use in expect tests. *)
val print : Dyn.t -> unit

(** {1 Canonical Internal Error}

    This part of the api allows for raising internal errors. The exception that
    is raised is registered to the [Printexc] however it is not designed to be
    caught explicitely. You may think of it like a customizable
    [Invalid_argument] exception that allows to embed dynamic context in an
    ergonomic fashion. *)

exception E of string * Dyn.t

val raise : string -> (string * Dyn.t) list -> _
