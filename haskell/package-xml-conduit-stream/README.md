# Haskell (xml-conduit)

XML processing with the streaming API of the Haskell [xml-conduit package]
(modules `Text.XML.Stream.*` in particular). This refers to the exercises
described [here](../../README.md).

[xml-conduit package]: https://hackage.haskell.org/package/xml-conduit

Build and run:

    $ cabal build
    $ cabal run exercise 1
    $ cabal run exercise 2
    ...

# Notes on xml-conduit

* The [xml-conduit tutorial](https://www.yesodweb.com/book/xml) unfortunately
  does not cover the streaming API.
* The [API documentation](https://hackage.haskell.org/package/xml-conduit)
  includes a short usage example in the docs of the `Text.XML.Stream.Parse`
  module.
* Since the streaming API is based on the conduit framework, the general
  [conduit tutorial](https://github.com/snoyberg/conduit#readme) is useful to
  get comfortable with the basics.
