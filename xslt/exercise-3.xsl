<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://martin.hoppenheit.info/code/generic-tree-xml"
    xmlns:e="http://purl.org/dc/elements/1.1/">

    <!-- In the template for `title` elements, create a copy of the element
    (including possible attributes). Make its content uppercase with the
    `translate` XPath function. Apply the identity transform (a verbatim copy)
    to all other elements and attributes. -->

    <!-- Make title elements uppercase. -->
    <xsl:template match="e:title">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:value-of select="translate(.,
                'abcdefghijklmnopqrstuvwxyz',
                'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </xsl:copy>
    </xsl:template>

    <!-- Identity transform for all other elements and attributes. -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
