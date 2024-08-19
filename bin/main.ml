let () =
  Cmdliner.Cmd.eval
    (Commandlang_to_cmdliner.Translate.command
       Cubzzle.main
       ~name:"cubzzle"
       ~version:"%%VERSION%%")
  |> Stdlib.exit
;;
