<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/" xmlns:r="http://gams.uni-graz.at/rem/ns/1.0"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:bas="http://gams.uni-graz.at/srbas/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs bk bas t xd" version="2.0">
    <xsl:import
        href="http://gams.uni-graz.at/archive/objects/cirilo:srbas/datastreams/STYLESHEET.CONVERSIONS/content"/>
    <xd:doc>
        <xd:desc>http://gams.uni-graz.at/archive/objects/cirilo:srbas/datastreams/STYLESHEET.CONVERSIONS/content
            die Umrechnungefunktionalitäten</xd:desc>
    </xd:doc>


    <xd:doc>
        <xd:desc>
            <xd:p>Das Stylesheet konvertiert die mit der TEI-Customization "rem-basel"
                (http://gams.uni-graz.at/rem/rem-basel.odd) erstellen Dokumente in allgemeines TEI,
                das in gams.uni-graz.at/rem verarbeitet wird.</xd:p>
            <xd:p>Version 2014-12-23</xd:p>
            <xd:p>Georg Vogeler georg.vogeler@uni-graz.at</xd:p>
            <xd:ul>
                <xd:li>2015-01-22: Aufbau einer Facsimile-Struktur</xd:li>
                <xd:li>2014-12-23: xsl:text mit Leerzeichen um xml:space="preserve" erweitert</xd:li>
                <xd:li>Verwendet die Betragsumrechnungen auf Basis eines TEI-Stylesheets</xd:li>
                <xd:li>Expandiert xi:imports</xd:li>
            </xd:ul>
            <xd:p>ToDo:</xd:p>
            <xd:ul>
                <xd:li>pb => Bildlink: facsimile/surface/graphic; @facs</xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    <xsl:output exclude-result-prefixes="#all" indent="yes"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xd:doc>
        <xd:desc>Hinter den teiHeader kommt eine facsimile-Gruppe</xd:desc>
    </xd:doc>
    <xsl:template match="t:teiHeader">
        <xsl:copy>
            <xsl:call-template name="id">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:if test="@*">
                <xsl:copy-of select="@*"/>
            </xsl:if>
            <xsl:apply-templates select="comment()|text()|*|r:*"/>
        </xsl:copy>
        <xsl:if test="not(/t:TEI/t:facsimile)">
            <facsimile>
                <xsl:for-each select="//t:pb">
                    <xsl:variable name="imagetype">jpg</xsl:variable><!-- Könnte automatisch ermittelt werden -->
                    <xsl:variable name="filelocation">
                        <xsl:value-of select="/t:TEI/t:teiHeader[1]/t:fileDesc[1]/t:sourceDesc[1]/t:msDesc[1]/t:msIdentifier[1]/concat(translate(substring-after(t:collection,'AHA '),' ','_'), '_', translate(t:idno[1],'.','_'))"/>
                    </xsl:variable>
                    <xsl:variable name="sz">
                        <!-- Füllt die Seitenzahl um einleitende Nullen auf -->
                        <xsl:choose>
                            <xsl:when test="count(preceding::t:pb) + 1 lt 10"><xsl:text>00</xsl:text></xsl:when>
                            <xsl:when test="count(preceding::t:pb) + 1 lt 100"><xsl:text>0</xsl:text></xsl:when>
                        </xsl:choose>
                        <xsl:value-of select="count(preceding::t:pb) + 1"></xsl:value-of>
                    </xsl:variable>
<!--                    <xsl:comment><xsl:value-of select="bas:folioangabe(.)"/></xsl:comment>-->
                    <surface>
                        <xsl:attribute name="xml:id"><xsl:text>fol_</xsl:text><xsl:value-of select="bas:folioangabe(.)"/></xsl:attribute>
                        <graphic mimeType="image/{$imagetype}" url="{$filelocation}/{$filelocation}_{$sz}.{$imagetype}" xml:id="fol_{bas:folioangabe(.)}_{$imagetype}"/>
                    </surface>
                </xsl:for-each>
            </facsimile>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>Und die t:pb müssen darauf verweisen</xd:desc>
    </xd:doc>
    <xsl:template match="t:pb">
        <xsl:copy>
            <xsl:call-template name="id">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:if test="@*">
                <xsl:copy-of select="@*"/>
            </xsl:if>
            <xsl:attribute name="facs">#fol_<xsl:value-of select="bas:folioangabe(.)"/></xsl:attribute>
            <xsl:apply-templates select="comment()|text()|*|r:*"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Catch all and copy</xd:desc>
    </xd:doc>
    <xsl:template match="comment()|text()|@*" priority="-2">
        <xsl:copy/>
    </xsl:template>
    <xd:doc>
        <xd:desc>Ein paar Attribute will ich nicht kopieren, weil sie aus Defaultangaben der TEI stammen.</xd:desc>
    </xd:doc>
    <xsl:template match="@part|@instant|@status|@uniform|@sample" priority="-1"/>
    <xd:doc>
        <xd:desc>Catch all and copy</xd:desc>
    </xd:doc>
    <xsl:template match="*|t:*|r:*" priority="-2">
        <xsl:copy>
            <xsl:call-template name="id">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:if test="@*">
                <xsl:copy-of select="@*"/>
            </xsl:if>
            <xsl:apply-templates select="comment()|text()|*|r:*"/>
        </xsl:copy>
    </xsl:template>


    <xd:doc>
        <xd:desc>Erzeug für jeden Term im Body einen Indexeintrag des Schlagwortindex</xd:desc>
    </xd:doc>
    <xsl:template match="t:text//t:term">
        <index indexName="schlagwort">
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </xsl:copy>
        </index>
        <xsl:if test="not(empty(.))">
            <xsl:copy>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc>Umwandlung der Buchungen</xd:desc>
    </xd:doc>
    <xsl:template match="r:e">
        <p>
            <xsl:call-template name="id">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:attribute name="ana">#bk_entry</xsl:attribute>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xd:doc>
      <xd:desc><xd:p>Umwandlung der Summen</xd:p>
        <xd:p><xd:b>FixMe:</xd:b> die Ersetzung durch closer ist ein Erfahrungswert und nicht aus der Rechnungslogik/dem TEI-Modell abgeleitet.</xd:p>
      </xd:desc>
    </xd:doc>
    <xsl:template match="r:sum">
        <xsl:variable name="ename">
            <xsl:choose>
                <xsl:when test="@extend='#bk_page'">fw</xsl:when>
                <xsl:when
                    test="preceding-sibling::*/name()='div' and not(following-sibling::*//t:p)"
                    >closer</xsl:when>
                <xsl:otherwise>p</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="preceding-sibling::*/name()='div' and following-sibling::*/name()='div'">
                <div>
                    <xsl:element name="p">
                        <xsl:call-template name="id">
                            <xsl:with-param name="element" select="."/>
                        </xsl:call-template>
                        <xsl:attribute name="ana">#bk_total <xsl:value-of select="@extend"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="@*[name()!='extend']"/>
                        <xsl:apply-templates/>
                    </xsl:element>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{$ename}">
                    <xsl:call-template name="id">
                        <xsl:with-param name="element" select="."/>
                    </xsl:call-template>
                    <xsl:attribute name="ana">#bk_total <xsl:value-of select="@extend"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="@*[name()!='extend']"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@r:extend"/>


    <xd:doc>
        <xd:desc>Umwandlung der Beträge</xd:desc>
    </xd:doc>
    <xsl:template match="r:b">
        <xsl:variable name="element-name">
            <xsl:choose>
                <xsl:when test="parent::r:klammer">ab</xsl:when>
                <xsl:otherwise>seg</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:text xml:space="preserve"> </xsl:text><xsl:element name="{$element-name}">
            <xsl:call-template name="id">
                <xsl:with-param name="element" select="."/>
            </xsl:call-template>
            <xsl:attribute name="ana">#bk_amount</xsl:attribute>
            <xsl:apply-templates select="@*"/><xsl:apply-templates/>
        </xsl:element><xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>

    <xd:doc>
        <xd:desc>Umwandlung von allgemeinen Währungsangaben</xd:desc>
    </xd:doc>
    <xsl:template match="r:wä">
        <measure>
            <xsl:call-template name="umrechnung"/>
            <xsl:attribute name="type">currency</xsl:attribute>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </measure>
    </xsl:template>

    <xd:doc>
        <xd:desc>Umwandlung von allgemeinen Pfundangaben</xd:desc>
    </xd:doc>
    <xsl:template match="r:lbd">
        <xsl:text xml:space="preserve"> </xsl:text>
        <measure>
            <xsl:call-template name="umrechnung"/>
            <xsl:attribute name="type">currency</xsl:attribute>
            <xsl:attribute name="unit">lb</xsl:attribute>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/> lb</measure>
    </xsl:template>

    <xd:doc>
        <xd:desc>Umwandlung von allgemeinen Schillingangaben (kurzer Schilling)</xd:desc>
    </xd:doc>
    <xsl:template match="r:ß|r:sh">
        <xsl:text xml:space="preserve"> </xsl:text>
        <measure>
            <xsl:call-template name="umrechnung"/>
            <xsl:attribute name="type">currency</xsl:attribute>
            <xsl:attribute name="unit">ß-w</xsl:attribute>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/> ß</measure>
    </xsl:template>

    <xd:doc>
        <xd:desc>Umwandlung von allgemeinen Pfennigangaben</xd:desc>
    </xd:doc>
    <xsl:template match="r:d">
        <xsl:text xml:space="preserve"> </xsl:text>
        <measure>
            <xsl:call-template name="umrechnung"/>
            <xsl:attribute name="type">currency</xsl:attribute>
            <xsl:attribute name="unit">d</xsl:attribute>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/> d</measure>
    </xsl:template>


    <xd:doc>
        <xd:desc>
            <xd:p>Hochstellungen</xd:p>
            <xd:p><xs:b>ToDo:</xs:b> Umbenennen in r:exp/@rend="exponent", weil die Hochstellungen
                nur als Funktionalität "Exponent" in die Rechnungsedition eingehen sollte</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="r:sup|r:exp">
        <seg rend="super">
            <xsl:apply-templates/>
        </seg><xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>


    <xd:doc>
        <xd:desc>Umrechnung von römischen Zahlen in numerische Werte, basierend auf
            STYLESHEET.CONVERSIONS. Verarbeitet den aktuellen Knoten und summiert numerische
            Teilangaben</xd:desc>
        <xd:return>Ein Attribut @quantitiy (default) oder @value (wenn im aktuellen Knoten
            vorhanden) mit dem Zahlenwert</xd:return>
    </xd:doc>
    <xsl:template name="umrechnung">
        <xsl:choose>
            <xsl:when test="@quantity">
                <xsl:copy-of select="@quantity"/>
            </xsl:when>
            <xsl:when test="@value">
                <xsl:copy-of select="@value"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="wert">
                    <xsl:for-each select="text()">
                        <r:zahl>
                            <xsl:choose>
                                <xsl:when test="string(number(.)) != 'NaN'">
                                    <xsl:value-of select="."/>
                                </xsl:when>
                                <xsl:when test="matches(.,'^[ ijvxlcdmIJVXLCDM̶]*?$')">
                                    <xsl:choose>
                                        <xsl:when
                                            test="following-sibling::*[1]/name()='r:sup' and matches(following-sibling::*[1]/.,'^[ ijvxlcdmIJVXLCDM̶]*?$')">
                                            <xsl:value-of
                                                select="number(bk:roman2int(translate(., ' ', '')) * bk:roman2int(replace(following-sibling::*[1], '\s', '')))"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of
                                                select="number(bk:roman2int(replace(., '\s', '')))"
                                            />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </r:zahl>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:attribute name="quantity">
                    <xsl:value-of select="sum($wert/r:zahl)"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Wandelt eine Klammer in ein tei:metamark mit Verweis auf das letzte Element der
                Klammer um</xd:p>
            <xd:p><xd:b>ToDo:</xd:b> @function ('repeat'|'aggregate') richtig interpretiert?</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="r:klammer">
        <metamark>
            <xsl:attribute name="rend">Klammer<xsl:if test="@rend">
                    <xsl:text xml:space="preserve"> </xsl:text>
                    <xsl:value-of select="@rend"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@function">
                    <xsl:attribute name="function" select="@function"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="function">repeat</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="@target">
                    <xsl:attribute name="target" select="@target"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="target" select="concat('#',generate-id(./*[1]))"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:attribute name="spanTo" select="concat('#',generate-id(./*[last()]))"/>
            <xsl:apply-templates select="@*"/>
        </metamark>
        <xsl:apply-templates/>
    </xsl:template>

    <xd:doc>
        <xd:desc>Vergibt eine ID</xd:desc>
        <xd:return>@xml:id mit entweder der aktuellen xml:id oder einer generierte</xd:return>
    </xd:doc>
    <xsl:template name="id">
        <xsl:param name="element"/>
        <xsl:if test="not($element/@xml:id) and not(name($element)='TEI')">
            <xsl:attribute name="xml:id">
                <xsl:if test="name($element)='div' and $element/head/text()">
                    <xsl:value-of select="$element/head/text()"/>
                    <xsl:text xml:space="preserve">_</xsl:text>
                </xsl:if>
                <xsl:value-of select="generate-id(.)"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Vergibt eine PID, wenn es noch keine gibt</xd:desc>
    </xd:doc>
    <xsl:template match="/t:TEI/t:teiHeader[1]/t:fileDesc[1]/t:publicationStmt[1]">
        <xsl:copy>
            <xsl:apply-templates/>
            <xsl:if test="not(t:idno[@type='PID'])">
                <idno type="PID">o:srbas.<xsl:value-of select="../t:sourceDesc/t:msDesc/t:msContents/t:p/t:origDate/substring-before(@from,'-')"></xsl:value-of></idno>
            </xsl:if>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Expandiert XIncludes</xd:desc>
    </xd:doc>
    <xsl:template xmlns:xi="http://www.w3.org/2001/XInclude" match="xi:include">
        <xsl:choose>
            <xsl:when test="document(@href)">
                <xsl:copy-of select="document(@href)//*[@xml:id=current()/@xpointer]"/>
            </xsl:when>
            <xsl:when test="xi:fallback/document(@href)">
                <xsl:copy-of
                    select="document(xi:fallback/@href)//*[@xml:id=current()/xi:fallback/@xpointer]"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>Error: import of <xsl:value-of select="concat(@href,'#',@xpointer, ' and ', xi:fallback/@href,'#',xi:fallback/@xpointer)"/> failed.</xsl:comment>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="bas:folioangabe">
        <xsl:param name="me"/>
        <xsl:variable name="anzahl" select="count($me/preceding::t:pb) + 1"/>
        <xsl:choose>
            <xsl:when test="$me/@n">
                <xsl:value-of select="$me/@n"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ceiling(($anzahl) div 2)"/><xsl:choose><xsl:when test="$anzahl mod 2 = 1"><xsl:text>r</xsl:text></xsl:when><xsl:otherwise><xsl:text>v</xsl:text></xsl:otherwise></xsl:choose></xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>
