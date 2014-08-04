all:
	ocamlbuild example/simple.native

doc:
	ocamlbuild mini-android.docdir/index.html

clean:
	ocamlbuild -clean
