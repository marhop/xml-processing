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

Proper element selection would be done with `isElem >>> hasQName n` for some
QName `n`. If it is certain however that no things with this QName other than
elements exist (attributes usually don't have qualified names) then the sloppier
variant `hasQName n` will possibly be sufficient as well. Use your own
judgement.
