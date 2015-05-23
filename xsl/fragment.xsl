<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output indent="yes"/>
    <xsl:param name="id"/>
    <xsl:variable name="von" select="//*[@xml:id=$id]"/>
    <!-- Generalisierter XPath: //*/generate-id() = $context/generate-id() -->
    <xsl:variable name="bis" select="$von/following::*[name()=name($von)][1]"/>
    <xsl:variable name="ca" select="($von/ancestor::* intersect $bis/ancestor::*)[last()]"/>
    <xsl:variable name="intersect" select="$von/following::* intersect $bis/preceding::*"></xsl:variable>
    <xd:doc>
        <xd:desc>Erzeugt ein XML-Fragment, das alle Knoten enthält, die zwischen einem Milestone ($von) und einem nächsten des selben Elementtyps ($bis) liegen, sowie die Hierarchie der Teilknoten am Anfang und Ende, die innerhalb des nächsten gemeinsamen Knoten liegen ($ca). Der Anfangsknoten wird über seine @xml:id ermittelt.</xd:desc>
    </xd:doc>
    <!-- Generalisierungspotential: 
    * Anfangsknoten statt über @xml:id über einen beliebigen XPath ermitteln
    * Typ des Endknotens/Referenzeigenschaft ermitteln
    * Auswahl, ob die gesamte Hierarchie oder nur die Hierarchie vom kleinsten gemeinsamen Knoten ausgewertet werden soll.
    +-->
    <xsl:template match="/">
        <xsl:comment>
            von: <xsl:value-of select="$von/@xml:id"/> bis:
            <xsl:value-of select="$bis/@xml:id"/>
        </xsl:comment>
        <xsl:apply-templates select="$ca" mode="fragment"/>
    </xsl:template>
    <xsl:template match="*" mode="fragment">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:if test=".//*/generate-id()=$bis/generate-id() or .//*/generate-id()=$von/generate-id()">
                <xsl:attribute name="part"><xsl:text>Y</xsl:text></xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="./node()[
                (
                ./generate-id()=$intersect/generate-id() or
                .//descendant-or-self::*/generate-id()=$von/generate-id() or
                .//descendant-or-self::*/generate-id()=$bis/generate-id()
                )
                ]|text()[.=$intersect or 
                following::*/generate-id()=$bis/generate-id() or
                preceding::*/generate-id()=$von/generate-id()
                ]" mode="fragment"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>