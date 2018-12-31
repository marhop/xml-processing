# Haskell (xml-conduit)

XML processing with the Haskell [xml-conduit package]. This refers to the
exercises described [here](../../README.md).

[xml-conduit package]: https://hackage.haskell.org/package/xml-conduit

Build and run with [stack]:

    $ stack setup
    $ stack build
    $ stack exec exercise 1
    $ stack exec exercise 2
    ...

[stack]: https://haskellstack.org

All XML processing takes place in the [GtrDc module](src/GtrDc.hs) which exports
custom Haskell data types `GtrNode` and `DcElement` as well as `readXml` and
`showXml` functions to convert between these custom data types and their XML
representation. The solutions of the exercises work with the custom data types
only, not with any XML DOM representation. (For exercise 1, there is an
[alternative solution](src/Exercise1Simple.hs) that directly uses the Text.XML
and Text.XML.Cursor modules instead of the custom data types. I would recommend
this approach only for trivial data extractions.)

# Notes on xml-conduit

  * [Tutorial](https://www.yesodweb.com/book/xml)
  * [API documentation](https://hackage.haskell.org/package/xml-conduit)
