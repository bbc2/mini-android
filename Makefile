.PHONY: all example doc ocamldoc clean

all: example doc

example:
	ocamlbuild example/simple.native
	ocamlbuild example/simple_android.native
	ocamlbuild example/parse.native
	ocamlbuild example/analyze.native

doc: ocamldoc
	./doc/gendoc

ocamldoc:
	ocamlbuild ocaml.docdir/index.html

clean:
	ocamlbuild -clean
	rm -rf html
