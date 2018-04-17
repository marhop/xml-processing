import xml.etree.ElementTree as ET
import exercise7 as E7


def exercise(xml):
    """Find all top level nodes and assign them to new parent nodes according to
    their subject. Create new parent nodes if necessary. Remove the subject
    elements.
    """
    ns = {"t": "http://martin.hoppenheit.info/code/generic-tree-xml",
          "e": "http://purl.org/dc/elements/1.1/"}
    root = ET.fromstring(xml)
    parents = {}
    for n in root.findall("t:node", ns):
        c = n.find("t:content", ns)
        s = c.find("e:subject", ns)
        p = s.text
        c.remove(s)
        if p not in parents:
            parents[p] = ET.SubElement(root, "t:node", {"name": p})
        parents[p].append(n)
        root.remove(n)
    for prefix, uri in ns.items():
        ET.register_namespace(prefix, uri)
    return ET.tostring(root, encoding="unicode")


if __name__ == "__main__":
    with open("../xml/example.xml") as f:
        xml = f.read()
        print(exercise(E7.exercise(xml)))
