all:
	ocamlbuild example/simple.native
	ocamlbuild example/simple_android.native
	ocamlbuild example/parse.native

doc:
	ocamlbuild mini-android.docdir/index.html

clean:
	ocamlbuild -clean
