# basic_ocaml_proj

Learning how to create a basic OCaml project using standard tooling: `opam` and `dune`

## Useful resources

Much of what's in here is taken from

- [A Lightweight OCaml Webapp Tutorial](https://shonfeder.gitlab.io/ocaml_webapp/)
- [OPAM for npm/yarn users](https://ocamlverse.github.io/content/opam_npm.html)

## Basics

### Defining the project and dependencies

See `dune-project`.

### Building the project

```bash
dune build @install
```

This generates the specification in `basic_ocaml_proj.opam`.

To install the packages:

```bash
opam install . --deps-only
```

Or to do both collectively:

```bash
make deps
```
