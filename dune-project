(lang dune 3.20)

(name cubzzle)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/cubzzle))

(documentation "https://mbarbin.github.io/cubzzle/")

(implicit_transitive_deps false)

(package
 (name cubzzle)
 (synopsis "Solver for a wooden cube puzzle")
 (depends
  (ocaml
   (>= 5.2))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-cmdliner-err-runner
   (>= 0.0.16))
  (dyn
   (>= 3.20))
  (graphics
   (>= 5.2.0))
  (ordering
   (>= 3.20))
  (pp
   (>= 2.0.0))))

(package
 (name cubzzle-tests)
 (synopsis "Tests for cubzzle")
 (depends
  (ocaml
   (>= 5.2))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-cmdliner-err-runner
   (>= 0.0.16))
  (cubzzle
   (= :version))
  (graphics
   (>= 5.2.0))
  (ppx_expect_nobase
   (>= v0.17.3))
  (ppxlib
   (>= 0.33))))

(package
 (name cubzzle-dev)
 (synopsis "Package to regroup dev targets, documentation, and more")
 (allow_empty)
 (depends
  (ocaml
   (>= 5.2))
  (ocamlformat
   (= 0.28.1))
  (bisect_ppx
   (>= 2.8.3))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-cmdliner-err-runner
   (>= 0.0.16))
  (cubzzle
   (= :version))
  (cubzzle-tests
   (= :version))
  (graphics
   (>= 5.2.0))
  (ppx_expect_nobase
   (>= v0.17.3))
  (ppx_js_style
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (sherlodoc
   (>= 0.2))))
