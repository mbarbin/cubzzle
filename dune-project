(lang dune 3.16)

(name cubzzle)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin")

(source
 (github mbarbin/cubzzle))

(documentation "https://mbarbin.github.io/cubzzle/")

(package
 (name cubzzle)
 (synopsis "Solver for a wooden cube puzzle")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (and
    (>= v0.17)
    (< v0.18)))
  (bisect_ppx
   (and
    :dev
    (>= 2.8.3)))
  (cmdliner
   (= 1.3.0))
  (commandlang
   (>= 0.0.2))
  (commandlang-to-cmdliner
   (>= 0.0.2))
  (graphics
   (>= 5.1.2))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_fields_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_js_style
   (and
    :dev
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))
  (ppxlib
   (>= 0.33))
  (stdio
   (and
    (>= v0.17)
    (< v0.18)))))

(package
 (name cubzzle-tests)
 (synopsis "Tests for cubzzle")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (and
    (>= v0.17)
    (< v0.18)))
  (bisect_ppx
   (and
    :dev
    (>= 2.8.3)))
  (cmdliner
   (= 1.3.0))
  (commandlang
   (>= 0.0.2))
  (commandlang-to-cmdliner
   (>= 0.0.2))
  (expect_test_helpers_core
   (and
    (>= v0.17)
    (< v0.18)))
  (graphics
   (>= 5.1.2))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_expect
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_fields_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_js_style
   (and
    :dev
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))
  (ppxlib
   (>= 0.33))
  (stdio
   (and
    (>= v0.17)
    (< v0.18)))))
