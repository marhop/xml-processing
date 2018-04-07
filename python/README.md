# Python

XML processing with Python. This refers to the exercises described
[here](../README.md).

# Notes

The complete documentation for the ElementTree module is
[here](https://docs.python.org/3.5/library/xml.etree.elementtree.html).

## Namespaces

Many methods accept an optional namespaces mapping:

    ns = {"t": "http://martin.hoppenheit.info/code/generic-tree-xml",
          "e": "http://purl.org/dc/elements/1.1/"}
    element.find("t:node", ns)

## Iterating over child elements

  * All direct child elements:
 
        for child in element:

  * All direct child elements named "foo":

        element.findall("foo")
        element.findall("n:foo", ns)

  * The first direct child element named "foo", or `None`:

        element.find("foo")
        element.find("n:foo", ns)

  * All descendant elements named "foo", recursively:

        element.iter("foo")
        element.iter("{%s}foo" % ns["n"])

  * The third child of the first child element:

        element[0][2]

  * All child elements named "foo" with an attribute named "bar" (XPath):

        element.findall("./foo[@bar]")
        element.findall("./foo[@bar]", ns)

