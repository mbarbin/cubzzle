(lang dune 3.17)

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
  (base
   (>= v0.17))
  (cmdlang
   (>= 0.0.9))
  (graphics
   (>= 5.1.2))
  (pplumbing
   (>= 0.0.14))
  (ppx_compare
   (>= v0.17))
  (ppx_enumerate
   (>= v0.17))
  (ppx_fields_conv
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (stdio
   (>= v0.17))))

(package
 (name cubzzle-tests)
 (synopsis "Tests for cubzzle")
 (depends
  (ocaml
   (>= 5.2))
  (ocamlformat
   (and
    :with-dev-setup
    (= 0.27.0)))
  (base
   (>= v0.17))
  (bisect_ppx
   (and
    :with-dev-setup
    (>= 2.8.3)))
  (cmdlang
   (>= 0.0.9))
  (cubzzle
   (= :version))
  (expect_test_helpers_core
   (>= v0.17))
  (graphics
   (>= 5.1.2))
  (pplumbing
   (>= 0.0.14))
  (ppx_compare
   (>= v0.17))
  (ppx_enumerate
   (>= v0.17))
  (ppx_expect
   (>= v0.17))
  (ppx_fields_conv
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (stdio
   (>= v0.17))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))
