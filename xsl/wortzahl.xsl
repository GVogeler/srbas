<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns:r="http://gams.uni-graz.at/rem/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:for-each select="collection('file:/Z:/Eigene%20Dateien/Uni/HistInf/Rechnungen/Basel/DatenFertig/tei-r/?select=*.xml')">
            <xsl:variable name='file'>
                <xsl:value-of select="tokenize(document-uri(.), '/')[last()]"/>
            </xsl:variable>
         <xsl:for-each select="$file">
            <xsl:value-of select="."/><xsl:text>\t</xsl:text><xsl:value-of select="count(document($file)//body//text()/tokenize(normalize-space(.),' '))"></xsl:value-of><xsl:text>\n
            </xsl:text>
        </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>