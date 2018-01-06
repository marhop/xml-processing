<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://martin.hoppenheit.info/code/generic-tree-xml"
    xmlns:e="http://purl.org/dc/elements/1.1/">

    <!-- In the template for `node` elements with the expected `name`
    attribute, just do nothing. That removes the element from the output.
    Apply the identity transform (a verbatim copy) to all other elements and
    attributes. -->

    <!-- Remove section. -->
    <xsl:template match="t:node[@name = 'Programming Books']"/>

    <!-- Identity transform for all other elements and attributes. -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
