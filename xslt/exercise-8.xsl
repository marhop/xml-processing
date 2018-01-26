<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:t="http://martin.hoppenheit.info/code/generic-tree-xml"
    xmlns:e="http://purl.org/dc/elements/1.1/">

    <!-- This transformation uses three different templates for `node` elements:
    First, a template for nodes with a subject. For each of these nodes a new
    parent node is created with its `name` attribute set to the child node's
    subject; then all sibling nodes on the same level with the same subject are
    collected under their new parent node. Second, a template for nodes with a
    subject whose subject already appeared in a preceding sibling node. These
    nodes are ignored (removed) because they have been processed in the first
    template. Third, a template for arbitrary `node` elements that does little
    more than copying the node. Further note the template for `subject` elements
    that removes those and the identity transform for all other elements and
    attributes. -->

    <!-- Select each node with a subject ... -->
    <xsl:template match="//t:node[t:content/e:subject]">
        <xsl:variable name="s" select="t:content/e:subject"/>
        <!-- ... create a new parent node with the subject as name ... -->
        <t:node>
            <xsl:attribute name="name">
                <xsl:value-of select="$s"/>
            </xsl:attribute>
            <!-- ... and move all nodes on the same level (siblings) that share
            the same subject into the new parent node. Note that if there were
            no need for modification of the nodes (namely, removal of the
            subject element) this would be easier using xsl:copy-of. -->
            <xsl:apply-templates select="../t:node[t:content/e:subject=$s]"
                mode="copy"/>
        </t:node>
    </xsl:template>

    <!-- Remove all nodes whose subject already occured on the same level
    because they have been processed by the above template. -->
    <xsl:template match="//t:node[t:content/e:subject =
        preceding-sibling::t:node/t:content/e:subject]"/>

    <!-- Essentially, the identity transform for node elements. This is
    necessary to distinguish between copying nodes (minus the subject) and
    moving nodes to new parent nodes. -->
    <xsl:template match="t:node" mode="copy">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Remove subject elements. -->
    <xsl:template match="e:subject"/>

    <!-- Identity transform for all other elements and attributes. -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
