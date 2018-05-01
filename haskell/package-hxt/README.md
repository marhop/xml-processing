# Haskell (HXT)

XML processing with the Haskell [hxt package]. This refers to the exercises
described [here](../../README.md).

[hxt package]: https://hackage.haskell.org/package/hxt

Build and run with [stack]:

    $ stack setup
    $ stack build
    $ stack exec exercise 1
    $ stack exec exercise 2
    ...

[stack]: https://haskellstack.org

# Notes on HXT

## Fundamental reading

  * [HXT tutorial](https://wiki.haskell.org/HXT)
  * [HXT API documentation](https://hackage.haskell.org/package/hxt)
  * [Typeclassopedia section on
    Arrows](https://wiki.haskell.org/Typeclassopedia#Arrow)

Essential takeaways:

  * XML processing is done by filters and composition of filters. A filter is a
    function (well, an arrow) with a type like `XmlTree -> [XmlTree]`. Filters
    are chained with the `>>>` operator which acts like function composition,
    but with its arguments reversed (so it reads like Unix pipes).
  * Arrows generalize functions, so to get started it may help to replace a type
    like `f :: ArrowXml a => a XmlTree XmlTree` by `f :: XmlTree -> XmlTree` in
    your head.

## Random stuff

Proper element selection would be done with `isElem >>> hasQName n` for some
QName `n`. If it is certain however that no things with this QName other than
elements exist (attributes usually don't have qualified names) then the sloppier
variant `hasQName n` will possibly be sufficient as well. Use your own
judgement.
