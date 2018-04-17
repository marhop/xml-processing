import xml.etree.ElementTree as ET


def exercise(xml):
    """Find all top level nodes, add their name attributes as subjects to their
    child nodes, append the child nodes directly to the root node, and remove
    the top level nodes.
    """
    ns = {"t": "http://martin.hoppenheit.info/code/generic-tree-xml",
          "e": "http://purl.org/dc/elements/1.1/"}
    root = ET.fromstring(xml)
    for n in root.findall("t:node", ns):
        name = n.get("name", "")
        for c in n.findall("t:node", ns):
            ET.SubElement(c.find("t:content", ns), "e:subject").text = name
            root.append(c)
        root.remove(n)
    for prefix, uri in ns.items():
        ET.register_namespace(prefix, uri)
    return ET.tostring(root, encoding="unicode")


with open("../xml/example.xml") as f:
    xml = f.read()
    print(exercise(xml))
