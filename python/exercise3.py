import xml.etree.ElementTree as ET


def exercise(xml):
    """Iterate over all title elements, make their content uppercase, and return
    the modified XML string.
    """
    ns = {"t": "http://martin.hoppenheit.info/code/generic-tree-xml",
          "e": "http://purl.org/dc/elements/1.1/"}
    root = ET.fromstring(xml)
    for t in root.iter("{%s}title" % ns["e"]):
        t.text = t.text.upper()
    for prefix, uri in ns.items():
        ET.register_namespace(prefix, uri)
    return ET.tostring(root, encoding="unicode")


if __name__ == "__main__":
    with open("../xml/example.xml") as f:
        xml = f.read()
        print(exercise(xml))
