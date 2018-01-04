<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://martin.hoppenheit.info/code/generic-tree-xml"
    xmlns:e="http://purl.org/dc/elements/1.1/">

    <xsl:output method="text"/>

    <xsl:template match="/">
        <xsl:apply-templates select="//t:node[not(t:node)]"/>
    </xsl:template>

    <xsl:template match="t:node">
        <xsl:value-of select="t:content/e:creator"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="t:content/e:title"/>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>

</xsl:stylesheet>
