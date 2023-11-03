(lang dune 3.11)

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
 (description "Solver for a wooden cube puzzle")
 (depends
  (ocaml
   (>= 5.1))
  (dune
   (>= 3.11))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (bisect_ppx
   (and
    :dev
    (>= 2.8)))
  (graphics
   (>= 5.1.2))
  (core
   (and
    (>= v0.16)
    (< v0.17)))
  (command-unix-for-opam
   (>= 0.0.1))
  (expect_test_helpers_core
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_jane
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    (>= v0.16)
    (< v0.17)))
  (stdio
   (and
    (>= v0.16)
    (< v0.17)))))
