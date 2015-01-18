<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:rem="http://gams.uni-graz.at/rem"
    xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">
    <xd:doc>
        <xd:desc>Seitenweise HTML-Ansicht
        Georg Vogeler georg.vogeler@uni-graz.at, 2015-01-18
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:variable name="pbs" select="//t:body//t:pb"/>
        <xsl:variable name="pb-a" select="$pbs[1]"/> <!-- Ab hier soll ausgegeben werden -->
        <!-- Seitenfragment: -->
        <xsl:variable name="seite" select="rem:fragment($pb-a, $pb-a/following::t:pb[1], $pb-a/ancestor::node()[. = $pb-a/following::t:pb[1]/ancestor::node()][1])"/>
        <xsl:variable name="seite-t">
            <xsl:call-template name="fragment">
                <xsl:with-param name="from" select="$pb-a"/>
                <xsl:with-param name="to" select="$pb-a/following::t:pb[1]"/>
                <xsl:with-param name="where" select="$pb-a/ancestor::node()[. = $pb-a/following::t:pb[1]/ancestor::node()][1]"/><!-- Kleinster gemeinsamer Vorfahrenknoten aka "Stammvater" -->
            </xsl:call-template>
        </xsl:variable>
        <html>
            <head/>
            <body>
                <!-- FixMe: Unklar ist jetzt noch wie die aufgebaute Struktur dann verarbeitet werden kann: -->
               <xsl:copy-of select="$seite"/>
<!--                <xsl:apply-templates select="$seite"/>-->
            </body>
        </html>
    </xsl:template>

    <xd:doc>
        <xd:desc><xd:p>Fragment extrahiert die Struktur und die Inhalte zwischen zwei Elementen.<xs:lb/>
        Die Struktur besteht aus den beiden Elementen gemeinsamen übergeordneten XML-Struktur incl. Fragementen am Anfang und am Ende.</xd:p>
        </xd:desc>
    </xd:doc>    
    <xsl:function name="rem:fragment">
        <xsl:param name="from"/>
        <xsl:param name="to"/>
        <!-- Ausgangsknoten -->
        <xsl:param name="where"/>
        <!-- Die Schnittmenge zwischen den Knoten, die $from folgen und denen die vor $to liegen als Kindknoten von $where: -->
        <xsl:variable name="following"
            select="$from/following::*[.. = $where]|$from/following::text()[.. = $where]"/>
        <xsl:variable name="preceding"
            select="$to/preceding::*[.. = $where]|$to/preceding::text()[.. = $where]"/>
        <xsl:variable name="between" select="$preceding[count($following) = count($following| .)]"/>
        <!-- Aufbau der Struktur: -->
        <xsl:element name="{$where/name()}">
            <xsl:copy-of select="$where/@*"/>
            <!-- Anfangsfragment: 
            braucht eine Rekursion, damit nur Struktur und Inhalte übernommen werden, die auch nach dem Anfangselement vorkommen: -->
            <xsl:if test="$where/node()[.//node()/@xml:id=$from/@xml:id]">
                <xsl:copy-of select="rem:fragment($from, $to, $where/node()[.//node()=$from])"/>
            </xsl:if>
            <!-- Elemente zwischen Anfang und Ende können einfach kopiert werden: -->
            <xsl:for-each select="$between">
                <xsl:copy-of select="."/>
            </xsl:for-each>
            <!-- Endfragment: 
            braucht eine Rekursion, damit nur Struktur und Inhalte übernommen werden, die auch vor dem Anfangselement vorkommen: -->
            <xsl:if test="$where/node()[.//node()/@xml:id=$to/@xml:id]">
                <xsl:copy-of select="rem:fragment($from, $to, $where/node()[.//node()=$to])"/>
            </xsl:if>
        </xsl:element>
    </xsl:function>

    <xd:doc>
        <xd:desc>Darstellungstemplates</xd:desc>
    </xd:doc>
    <xsl:template match="t:p|t:closer|t:fw">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="t:head">
        <xsl:variable name="level" select="count(./ancestor::t:div)"/>
        <xsl:element name="h{$level}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="t:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="t:item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
</xsl:stylesheet>
