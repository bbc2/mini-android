let analyze path =
  (* Parse the application file and convert it to an [App.t]. *)
  let file = open_in path in
  let app = App.from_ast (Lang.Parser.app Lang.Lexer.read (Lexing.from_channel file)) in

  (* For each potential initial state, run an analysis and append the result to
     [analyses]. *)
  let append_analysis g l =
    let gc = Gcontext.from_list [(Context.from_global g, (g, Nexts.bot))] in
    (Analysis.fixpoint Gcontext.equal (Android.transfer app) gc)::l in
  let analyses = App.fold_on_init_states append_analysis app [] in

  (* Get the result based on the first initial state and discard the rest. *)
  let analysis = List.hd analyses in

  (* Print the dot graph of the analysis. *)
  print_endline (Dot.from_gcontext analysis)

let path =
  let doc = "The application file to analyze." in
  Cmdliner.Arg.(required & pos 0 (some string) None & info [] ~docv:"PATH" ~doc)

let analyze_t = Cmdliner.Term.(pure analyze $ path)

let info =
  let doc = "analyze a Mini application" in
  Cmdliner.Term.info "analyze" ~doc

let () =
  match Cmdliner.Term.eval (analyze_t, info) with `Error _ -> exit 1 | _ -> exit 0
