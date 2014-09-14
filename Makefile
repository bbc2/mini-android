.PHONY: all analyze example doc ocamldoc clean

all: analyze example doc

analyze:
	ocamlbuild -package cmdliner analyze.native

example:
	ocamlbuild example/simple.native
	ocamlbuild example/simple_android.native
	ocamlbuild example/parse.native

doc: ocamldoc
	./doc/gendoc

ocamldoc:
	ocamlbuild ocaml.docdir/index.html

clean:
	ocamlbuild -clean
	rm -rf html
