# XSLT

XML processing with XSLT. This refers to the exercises described
[here](../README.md). Using [XMLStarlet] or [xsltproc], the XSLT stylesheets
can be run like this:

    $ xmlstarlet tr exercise-1.xsl ../xml/example.xml
    $ xsltproc exercise-1.xsl ../xml/example.xml

[XMLStarlet]: http://xmlstar.sourceforge.net/
[xsltproc]: http://xmlsoft.org/XSLT/xsltproc2.html

In case you have problems understanding the identity transform used in the
solutions of exercises 3-5, [Wikipedia has an article about
it](https://en.wikipedia.org/wiki/Identity_transform).

There is obviously no XSLT solution of exercise 6 -- XSLT is not intended for
XML validation.
