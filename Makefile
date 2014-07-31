all:
	ocamlbuild analysis.native

doc:
	ocamlbuild mini-android.docdir/index.html

clean:
	ocamlbuild -clean
