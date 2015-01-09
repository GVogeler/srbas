<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:r="http://gams.uni-graz.at/rem/ns/1.0"
    xmlns="http://www.opengis.net/kml/2.2"
    xmlns:kml="http://www.opengis.net/kml/2.2"
    xmlns:gx="http://www.google.com/kml/ext/2.2" 
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:cc="http://creativecommons.org/ns#"
    xmlns:dcterms="http://purl.org/dc/terms/" 
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:gn="http://www.geonames.org/ontology#" 
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:wgs84_pos="http://www.w3.org/2003/01/geo/wgs84_pos#" 
    exclude-result-prefixes="xs t r kml"
    version="2.0">
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc><p>Extrahiert geonames-Referenzen aus placeName[starts-with(@ref,'geonames')] und transformiert sie in eine KML-Datei.</p>
            <p>Georg Vogeler georg.vogeler@uni-graz.at, 4.1.2015</p>
        </desc>
    </doc>
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="PID" select="/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno[@type='PID']"/>
    <xsl:template match="/">
        <kml>
            <Document>
                <name>Orte in Jahrrechnung <xsl:value-of
                        select="//t:teiHeader/t:fileDesc/t:titleStmt[1]/t:title"/></name>
                <open>1</open>
                <StyleMap id="msn_ylw-stars">
                    <Pair>
                        <key>normal</key>
                        <styleUrl>#sn_ylw-stars8</styleUrl>
                    </Pair>
                    <Pair>
                        <key>highlight</key>
                        <styleUrl>#sh_ylw-stars0</styleUrl>
                    </Pair>
                </StyleMap>
                <Style id="sn_ylw-stars8">
                    <IconStyle>
                        <scale>1.1</scale>
                        <Icon>
                            <href>http://maps.google.com/mapfiles/kml/paddle/ylw-stars.png</href>
                        </Icon>
                        <hotSpot x="32" y="1" xunits="pixels" yunits="pixels"/>
                    </IconStyle>
                    <ListStyle>
                        <ItemIcon>
                            <href>http://maps.google.com/mapfiles/kml/paddle/ylw-stars-lv.png</href>
                        </ItemIcon>
                    </ListStyle>
                </Style>
                <Style id="sh_ylw-stars0">
                    <IconStyle>
                        <scale>1.3</scale>
                        <Icon>
                            <href>http://maps.google.com/mapfiles/kml/paddle/ylw-stars.png</href>
                        </Icon>
                        <hotSpot x="32" y="1" xunits="pixels" yunits="pixels"/>
                    </IconStyle>
                    <ListStyle>
                        <ItemIcon>
                            <href>http://maps.google.com/mapfiles/kml/paddle/ylw-stars-lv.png</href>
                        </ItemIcon>
                    </ListStyle>
                </Style>
                <xsl:for-each select="//t:placeName[starts-with(@ref,'geonames:')]">
                    <xsl:if test="not(preceding::t:placeName[@ref=current()/@ref])"><xsl:call-template name="geonames"/></xsl:if>
                </xsl:for-each>
            </Document>
        </kml>
    </xsl:template>
    <xsl:template name="geonames">
        <xsl:variable name="geonames-rdf" select="document(concat('http://sws.geonames.org/',substring-after(@ref,'geonames:'),'/about.rdf'))/rdf:RDF/gn:Feature[1]"/>
        <!-- http://sws.geonames.org/2973783/about.rdf -->
        <Placemark>
            <name><xsl:value-of select="$geonames-rdf/gn:name"/></name>
<!--            /rdf:RDF/gn:Feature[1]/gn:name[1]-->
            <description>
                <ul>
                <xsl:for-each select="//t:placeName[@ref=current()/@ref]">
                    <li><a><xsl:if test="ancestor::r:e[1]/@xml:id|ancestor::t:*[matches(@ana,'bk_entry')][1]/@xml:id"><xsl:attribute name="href">http://gams.uni-graz.at/archive/objects/<xsl:value-of select="$PID"/>/methods/sdef:TEI/get#<xsl:value-of select="ancestor::r:e[1]/@xml:id|ancestor::t:*[matches(@ana,'bk_entry')][1]/@xml:id"></xsl:value-of></xsl:attribute></xsl:if><!-- FixMe: Link auf die Buchung in der Einzelrechnung --><xsl:apply-templates select="ancestor::r:e[1]|ancestor::t:*[matches(@ana,'bk_entry')][1]"/></a>
                    </li>
                </xsl:for-each>
                </ul>
            </description>
            <styleUrl>#msn_ylw-stars</styleUrl>
            <Point>
                <coordinates><xsl:value-of select="$geonames-rdf/wgs84_pos:long"/>,<xsl:value-of select="$geonames-rdf/wgs84_pos:lat"/>,0</coordinates>
            </Point>
        </Placemark>
    </xsl:template>
</xsl:stylesheet>
