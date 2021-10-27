# The name of your project (as given in the dune-project file)
# TODO
project_name = basic_ocaml_proj

# The opam package configuration file
opam_file = $(project_name).opam

.PHONY: deps run run-debug migrate rollback

# Alis to update the opam file and install the needed deps
deps: $(opam_file)

# Build and run the app
run:
	dune exec $(project_name)

# Build and run the app with Opium's internal debug messages visible
run-debug:
	dune exec $(project_name) -- --debug

# Update the package dependencies when new deps are added to dune-project
$(opam_file): dune-project
	-dune build @install        # Update the $(project_name).opam file
	opam install . --deps-only  # Install the new dependencies
