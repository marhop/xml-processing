# Shell

XML processing with shell tools. Mainly [XMLStarlet], and also [xmllint] for
validation. This refers to the exercises described [here](../README.md).

[XMLStarlet]: http://xmlstar.sourceforge.net/
[xmllint]: http://xmlsoft.org/xmllint.html

XMLStarlet is like grep and sed specialized for XML files. It may feel a
little complicated at first but it gets easier when you realize that it makes
heavy use of XSLT and XPath concepts. In particular, the `select` operations
almost read like an XSLT template.

## Exercise 1

Use xmlstarlet's `sel` (`select`) operation. Use the `-N` option to bind a
prefix to a namespace, the `-t` (`--template`), `-m` (`--match`) and `-v`
(`--value-of`) options like their XSLT counterparts, the `-o` (`--output`)
option for literal text output and the `-n` (`--nl`) option for a newline.

    xmlstarlet sel \
        -N 't=http://martin.hoppenheit.info/code/generic-tree-xml' \
        -N 'e=http://purl.org/dc/elements/1.1/' \
        -t -m '//t:node[not(t:node)]/t:content' \
        -v 'e:creator' -o ', ' -v 'e:title' -n \
        ../xml/example.xml

## Exercise 2

Use xmlstarlet's `sel` (`select`) operation. Use the `-N` option to bind a
prefix to a namespace, the `-t` (`--template`), `-m` (`--match`) and `-v`
(`--value-of`) options like their XSLT counterparts, the `-o` (`--output`)
option for literal text output and the `-n` (`--nl`) option for a newline. Use
the `--if` and `--else` options for conditional constructs. This only searches
the parent element, no other ancestors!

    xmlstarlet sel \
        -N 't=http://martin.hoppenheit.info/code/generic-tree-xml' \
        -N 'e=http://purl.org/dc/elements/1.1/' \
        -t -m '//t:node[not(t:node)]/t:content' \
        --if 'e:creator' \
            -v 'e:creator' -o ', ' -v 'e:title' -n \
        --else \
            -v '../../t:content/e:creator' -o ', ' -v 'e:title' -n \
        ../xml/example.xml

## Exercise 3

Use xmlstarlet's `ed` (`edit`) operation. Use the `-N` option to bind a prefix
to a namespace, the `-u` (`--update`) option to select the element to be
modified and the `-x` (`--expr`) option to provide an expression that will be
applied to the element's content. The `translate` operation is an XPath
function.

    xmlstarlet ed \
        -N 'e=http://purl.org/dc/elements/1.1/' \
        -u '//e:title' \
        -x 'translate(., "abcdefghijklmnopqrstuvwxyz",
                        "ABCDEFGHIJKLMNOPQRSTUVWXYZ")' \
        ../xml/example.xml

## Exercise 4

TODO

## Exercise 5

Use xmlstarlet's `ed` (`edit`) operation. Use the `-N` option to bind a prefix
to a namespace and the `-d` (`--delete`) option to select the element to be
deleted.

    xmlstarlet ed \
        -N 't=http://martin.hoppenheit.info/code/generic-tree-xml' \
        -d '//t:node[@name="Programming Books"]' \
        ../xml/example.xml

## Exercise 6

Use xmlstarlet's `val` (`validate`) operation. Use the `-s` (`--xsd`) option
to provide an XML schema file.

    xmlstarlet val -s ../xml/gtr_dc.xsd ../xml/example.xml

Instead of xmlstarlet, xmllint can be used. Use the `--noout` option to
suppress output of the validated XML file and the `--schema` option to provide
and XML schema file. If you want to see which additional schema files are
fetched because they are referenced in the provided schema file, add the
`--load-trace` option.

    xmllint --noout --schema ../xml/gtr_dc.xsd ../xml/example.xml
