import xml.etree.ElementTree as ET


def exercise(xml):
    root = ET.fromstring(xml)
    return leafnodes(root, "")


def leafnodes(elem, creator):
    """Find the leaf nodes of an element and for each return a line of the form
    'creator, title'. Accept a default for the creator value that will be
    updated during tree traversal.
    """
    ns = {"t": "http://martin.hoppenheit.info/code/generic-tree-xml",
          "e": "http://purl.org/dc/elements/1.1/"}
    if elem.tag == "{%s}node" % ns["t"] and not elem.find("t:node", ns):
        c = elem.findtext("t:content/e:creator", creator, ns)
        t = elem.findtext("t:content/e:title", "", ns)
        return "%s, %s" % (c, t)
    else:
        c = elem.findtext("t:content/e:creator", creator, ns)
        return "\n".join([leafnodes(n, c) for n in elem.findall("t:node", ns)])


with open("../xml/example.xml") as f:
    xml = f.read()
    print(exercise(xml))
