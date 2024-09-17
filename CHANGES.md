## 0.0.11 (unreleased)

### Added

### Changed

- Upgrade to `cmdlang.0.0.5`.

### Deprecated

### Fixed

### Removed

## 0.0.10 (2024-09-07)

### Changed

- Upgrade to `cmdlang.0.0.4`.
- Split test package & use `expect_test_helpers_base`.

## 0.0.9 (2024-08-19)

### Changed

- Switch to using `cmdlang` for commands.

## 0.0.8 (2024-07-26)

### Added

- Added dependabot config for automatically upgrading action files.

### Changed

- Upgrade `ppxlib` to `0.33` - activate unused items warnings.
- Upgrade `ocaml` to `5.2`.
- Upgrade `dune` to `3.16`.
- Upgrade base & co to `0.17`.

## 0.0.7 (2024-03-13)

### Changed

- Uses `expect-test-helpers` (reduce core dependencies)
- Run `ppx_js_style` as a linter & make it a `dev` dependency.
- Upgrade GitHub workflows `actions/checkout` to v4.
- In CI, specify build target `@all`, and add `@lint`.
- List ppxs instead of `ppx_jane`.

## 0.0.6 (2024-02-14)

### Changed

- Upgrade dune to `3.14`.
- Build the doc with sherlodoc available to enable the doc search bar.

## 0.0.5 (2024-02-09)

### Changed

- Internal changes related to the release process.
- Upgrade dune and internal dependencies.
- Improve `bisect_ppx` setup for test coverage.

## 0.0.4 (2024-01-18)

### Changed

- Internal changes related to build and release process.
- Generate opam file from `dune-project`.
- Use `command-unix-for-opam`.
- Change changelog format to be closer to dune-release's.

## 0.0.3 (2023-11-01)

### Added

- Added opam install instruction to the README.

### Fixed

- Allow the user to close the window without raising an uncaught exception
  `Graphic_failure("fatal I/O error")`, rather simply `exit 0`.

## 0.0.2 (2023-10-31)

### Fixed

- Make `cubzzle -version` output the package version.

## 0.0.1 (2023-08-24)

### Added

- Added changelog file [CHANGES.md].
