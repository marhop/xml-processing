import xml.etree.ElementTree as ET


def exercise(xml):
    """Iterate over all node elements, check if they are leaf nodes (i.e., have
    no node child nodes), and retrieve the creator and title, supplying empty
    strings as default values.
    """
    ns = {"t": "http://martin.hoppenheit.info/code/generic-tree-xml",
          "e": "http://purl.org/dc/elements/1.1/"}
    root = ET.fromstring(xml)
    results = []
    # The iter method does not accept a namespaces mapping parameter.
    for n in root.iter("{%s}node" % ns["t"]):
        if not n.find("t:node", ns):
            creator = n.findtext("t:content/e:creator", "", ns)
            title = n.findtext("t:content/e:title", "", ns)
            results.append("%s, %s" % (creator, title))
    return "\n".join(results)


if __name__ == "__main__":
    with open("../xml/example.xml") as f:
        xml = f.read()
        print(exercise(xml))
