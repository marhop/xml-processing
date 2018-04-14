from lxml import etree

"""Read the schema file and XML file, then validate."""

schema = etree.XMLSchema(etree.parse("../xml/gtr_dc.xsd"))
xml = etree.parse("../xml/example.xml")
print(schema.validate(xml))
