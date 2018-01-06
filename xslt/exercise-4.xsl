<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://martin.hoppenheit.info/code/generic-tree-xml"
    xmlns:e="http://purl.org/dc/elements/1.1/">

    <!-- In the template for `node` elements with the expected title, create a
    copy of the element. Apply the identity transform (a verbatim copy) to its
    child elements and to all other elements and attributes. Then, after all
    child elements have thus been copied, append a new child element with the
    desired content. -->

    <!-- Append new node. -->
    <xsl:template
        match="t:node[t:content/e:title = 'A Song of Ice and Fire']">
        <xsl:copy>
            <xsl:apply-templates/>
            <t:node>
                <t:content type="Dublin Core">
                    <e:title>A Feast for Crows</e:title>
                    <e:date>2005</e:date>
                </t:content>
            </t:node>
        </xsl:copy>
    </xsl:template>

    <!-- Identity transform for all other elements and attributes. -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
