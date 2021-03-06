<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://martin.hoppenheit.info/code/generic-tree-xml"
    xmlns:e="http://purl.org/dc/elements/1.1/">

    <!-- Use output method "text" (default is usually "xml"). Provide two
    different templates for `node` elements: one for inner nodes, and one for
    leaf nodes. Starting with the top-level `node` elements, both templates
    call each other recursively, thus iterating through the XML tree. Use a
    parameter to pass the content of the `creator` element on when applying
    the templates recursively to child nodes (starting with default empty
    string). Whenever a node has a `creator` element of its own the content of
    that element will override the supplied parameter value. -->

    <xsl:output method="text"/>

    <xsl:template match="/">
        <xsl:apply-templates select="/t:tree/t:node"/>
    </xsl:template>

    <!-- inner nodes -->
    <xsl:template match="t:node[t:node]">
        <xsl:param name="creator"/>
        <xsl:apply-templates select="t:node">
            <xsl:with-param name="creator">
                <xsl:choose>
                    <xsl:when test="t:content/e:creator">
                        <xsl:value-of select="t:content/e:creator"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$creator"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>

    <!-- leaf nodes -->
    <xsl:template match="t:node[not(t:node)]">
        <xsl:param name="creator"/>
        <xsl:choose>
            <xsl:when test="t:content/e:creator">
                <xsl:value-of select="t:content/e:creator"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$creator"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="t:content/e:title"/>
        <xsl:text>&#x0a;</xsl:text>
    </xsl:template>

</xsl:stylesheet>
