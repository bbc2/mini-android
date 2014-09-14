Tutorial
========

We assume that you have read `README.md`.  Build the analyzer with `make`:

    make analyze

It should have produced an `analyze.native` file.  Run it with a sample
application as argument:

    ./analyze.native example/app.mini

This analyzes the application and produces a dot graph of the result.  To
visualize it, redirect the output to `dot`:

    ./analyze.native example.app.mini | dot -Tpng -o graph.png

Then open `graph.png` (it can be big) to see the graph of global states and the
semantic steps Android can take from each of them.
