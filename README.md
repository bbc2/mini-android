mini-android
============

mini-android is a research project started at Inria and aimed at highlighting
static analysis challenges raised by the event-driven control flow of Android
applications.  It features a context-sensitive static analysis for a small
Java-like language called mini with a subset of the Android API.

Dependencies
------------

  * `OCaml` with `ocamlbuild` to build the project and generate OCaml
    documentation
  * `menhir` for the parser
  * `omd` for the documentation
  * `cmdliner` for the command line tool `analyze`

Documentation
-------------

Use `make doc` to generate the full documentation.  The main documentation ends
up in `html` and the ocamldoc documentation in `ocaml.docdir`.  To read the
documentation, open `html/index.html` in your browser.

License
-------

This work is licensed under a MIT license.  See `LICENSE` for more information.
