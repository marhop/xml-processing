import xml.etree.ElementTree as ET


def exercise(xml):
    """Find the target element, add the new item, and return the modified XML
    string.
    """
    ns = {"t": "http://martin.hoppenheit.info/code/generic-tree-xml",
          "e": "http://purl.org/dc/elements/1.1/"}
    root = ET.fromstring(xml)
    for n in root.iter("{%s}node" % ns["t"]):
        if n.findtext("t:content/e:title", "", ns) == "A Song of Ice and Fire":
            n.append(new_item())
    for prefix, uri in ns.items():
        ET.register_namespace(prefix, uri)
    return ET.tostring(root, encoding="unicode")


def new_item():
    """Create the new child item. Assumes the same namespaces mapping as the
    exercise function.
    """
    n = ET.Element("t:node")
    c = ET.Element("t:content", {"type": "Dublin Core"})
    n.append(c)
    t = ET.Element("e:title")
    t.text = "A Feast for Crows"
    c.append(t)
    d = ET.Element("e:date")
    d.text = "2005"
    c.append(d)
    return n


with open("../xml/example.xml") as f:
    xml = f.read()
    print(exercise(xml))
