# Haskell

XML processing with Haskell. This refers to the exercises described
[here](../README.md). So far, three different modules were explored (tl;dr → Use
[xml-conduit] like in [these examples][xml-conduit-dom]):

  * The [Text.XML.Light module (package xml)][xml] is arguably the easiest to
    use, particularly if you are rather new to Haskell. It has at least one
    [annoying bug](https://github.com/GaloisInc/xml/issues/10) that complicates
    working with namespaces though. See [here][xml-examples] for solutions to
    the exercises.
  * The [Text.XML module (package xml-conduit)][xml-conduit] is only slightly,
    if at all, more complicated to get started with. There is a [very good
    tutorial](https://www.yesodweb.com/book/xml). The API's overall design
    together with the operators defined in the Text.XML.Cursor module make it a
    pleasure to work with. If there is no compelling reason to choose another
    module I would definitely recommend xml-conduit. See
    [here][xml-conduit-dom] for solutions to the exercises.
  * The [Text.XML.HXT.Core module (package hxt)][hxt] is the entry point to a
    vast package full of elegant, powerful concepts with a really steep learning
    curve. After trying for quite a while to tackle this learning curve without
    much success I ~~gave up~~ discovered xml-conduit and decided that HXT is
    fascinating, but just a bit *too* elegant and powerful for my needs ... See
    [here][hxt-examples] for my pathetic attempts.

The [solutions made with the xml package][xml-examples] operate directly on the
XML representation, whereas the [solutions made with
xml-conduit][xml-conduit-dom] use custom data types combined with functions that
convert between these data types and the XML representation. (Of course, both
approaches are viable with both packages.) For really trivial tasks like simple
extraction of data from two or three XML elements, operating directly on the XML
representation is pretty straightforward. For everything else, particularly a
read/modify/write XML process, it is much more convenient to use custom data
types that hide the XML processing overhead like distinction of nodes, elements
and attributes, namespace handling etc. in one module that can be kept at the
program boundaries.

[xml]: https://hackage.haskell.org/package/xml
[xml-examples]: ./package-xml/
[xml-conduit]: https://hackage.haskell.org/package/xml-conduit
[xml-conduit-examples]: ./package-xml-conduit-dom/
[hxt]: https://hackage.haskell.org/package/hxt
[hxt-examples]: ./package-hxt/
