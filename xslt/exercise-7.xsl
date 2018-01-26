<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://martin.hoppenheit.info/code/generic-tree-xml"
    xmlns:e="http://purl.org/dc/elements/1.1/">

    <!-- In the template for top level `node` elements, only apply templates for
    child elements but do nothing with (and thus, remove) the top level nodes
    themselves. In the template for second level `node/content` elements, create
    a copy of the element (including possible attributes) and add a new
    `subject` child element with the expected content. Apply the identity
    transform (a verbatim copy) to all other elements and attributes. -->

    <!-- Remove top level nodes. -->
    <xsl:template match="/t:tree/t:node">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Add subject to new top level nodes. -->
    <xsl:template match="/t:tree/t:node/t:node/t:content">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
            <e:subject>
                <xsl:value-of select="../../@name"/>
            </e:subject>
        </xsl:copy>
    </xsl:template>

    <!-- Identity transform for all other elements and attributes. -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
