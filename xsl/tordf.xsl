<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/"
    xmlns:srbas="http://gams.uni-graz.at/srbas/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:g2o="http://gams.uni-graz.at/onto/#"
    xmlns:gl="http://www.xbrl.org/GLTaxonomy/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xsl:include
        href="http://gams.uni-graz.at/archive/objects/cirilo:srbas/datastreams/STYLESHEET.CONVERSIONS/content"/>
    <xd:doc><xd:desc><xd:p>Konvertiert ein TEI-Dokument mit Rechnungsmarkup (matches(@ana,'#bk_|#gl_') in RDF im Kontext des Editionsprojekts 'Basler Jahrrechnungen im 16. Jahrhundert'</xd:p>
    <xd:p>Georg Vogeler georg.vogeler@uni-graz.at, Version 2014-12-23</xd:p>
        <xd:ul>
            <xd:li>2015-01-12: Kontennamen eingeführt</xd:li>
            <xd:li>2014-12-23: xsl:text für Leerzeichen braucht es nicht mehr, weil es schon im TEI steht</xd:li>
        </xd:ul>
        <xd:p>ToDo:</xd:p>
        <xd:ul>
            <xd:li>g2o:appears-on in CIDOC-CRM-Vokabular übersetzen</xd:li>
        </xd:ul>
    </xd:desc>
    </xd:doc>
    <xsl:output encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
    
    <xd:doc>
        <xd:desc>Gemeinsame Variablen:
        <xd:ul>
            <xd:li>pid: die GAMS PID</xd:li>
            <xd:li>base-uri: die URI des TEI</xd:li>
            <xd:li>accounts: die Liste aller Konten aus tei:taxonomy[@ana='#bk_account']</xd:li>
            <xd:li>xmlBaseAccounts: die Basis-URI für alle Konten</xd:li>
            <xd:li>xmlBaseKeywords: die Basis-URI für alle Schlagwörter</xd:li>
        </xd:ul></xd:desc>
    </xd:doc>
    <xsl:variable name="pid"
        select="replace(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID']/text(),'info:fedora/','')"/>
    <xsl:variable name="base-uri"
        select="concat('http://gams.uni-graz.at/archive/get/',$pid,'/sdef:TEI/get#')"/>
    <xsl:variable name="accounts" select="//tei:taxonomy[@ana='#bk_account']"/>
    <xsl:variable name="xmlBaseAccounts">
        <xsl:choose>
            <xsl:when
                test="//tei:classDecl[.//tei:taxonomy/@ana='#bk_account']/starts-with(@xml:base,'http://')">
                <xsl:value-of select="//tei:classDecl[.//tei:taxonomy/@ana='#bk_account']/@xml:base"
                />
            </xsl:when>
            <xsl:otherwise>http://gams.uni-graz.at<xsl:value-of
                    select="//tei:classDecl[.//tei:taxonomy/@ana='#bk_account']/@xml:base"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="xmlBaseKeywords">http://gams.uni-graz.at/rem/Basel/</xsl:variable>
    
    <xd:doc>
        <xd:desc><xd:p>Folgende RDF-Objekte werden aufgebaut:</xd:p>
        <xd:ul>
            <xd:li>Die ganze Rechnung: http://gams.uni-graz.at/{$pid}</xd:li>
            <xd:li>Die Konten: //tei:taxonomy[@ana='#bk_account'] und tei:category" mode="accounts"</xd:li>
            <xd:li>Die Schlagwörter: //tei:*[@xml:id='srbas-schlagwoerter']</xd:li>
            <xd:li>Die einzelnen Buchungen: //tei:*[matches(@ana,'#bk_entry') or matches(@ana,'#gl_entryDetail') or matches(@ana, '#bk_total')]</xd:li>
        </xd:ul></xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>Die Rechnung hat folgende Eigenschaften:
            <xd:ul>
                <xd:li>die Referenz auf Mulgara-ID (g2o:sameAs)</xd:li>
                <xd:li>ein Datum</xd:li>
                <xd:li>eine Signatur (tei:msIdentifier)</xd:li>
                <xd:li>eine Liste der verwendeten Konten mit Summen (wobei die erläuternden Angaben zu den Konten ausgelagert sind (ToDo))</xd:li>
                <xd:li>die eigentlichen Buchungen</xd:li>
                <xd:li>die Seiten</xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <rdf:RDF>
            <rdf:Description rdf:about="http://gams.uni-graz.at/{$pid}">
                <g2o:sameAs
                    rdf:resource="info:fedora/{$pid}"/>
                <tei:msIdentifier>
                    <xsl:value-of select="//tei:msIdentifier"/>
                </tei:msIdentifier>
                <xsl:if test="//tei:teiHeader//tei:sourceDesc//tei:origDate[1]/substring-before(@from,'-')!=''"><srbas:from>
                    <xsl:attribute name="rdf:datatype"
                        >http://www.w3.org/2001/XMLSchema#int</xsl:attribute>
                    <xsl:value-of
                        select="//tei:teiHeader//tei:sourceDesc//tei:origDate[1]/substring-before(@from,'-')"
                    />
                </srbas:from></xsl:if>
                <xsl:if test="//tei:teiHeader//tei:sourceDesc//tei:origDate[1]/substring-before(@to,'-')!=''"><dc:date>
                    <xsl:attribute name="rdf:datatype"
                        >http://www.w3.org/2001/XMLSchema#int</xsl:attribute>
                    <xsl:value-of
                        select="//tei:teiHeader//tei:sourceDesc//tei:origDate[1]/substring-before(@to,'-')"
                    />
                </dc:date></xsl:if>
            </rdf:Description>
            <xsl:apply-templates
                select="//tei:taxonomy[matches(@ana,'#bk_account') or matches(@ana,'#gl_account')]"/>
            <xsl:apply-templates select="//tei:*[@xml:id='srbas-schlagwoerter']"/><!-- FixMe: Braucht es das wirklich? Das sollte doch eigentlich extern passieren -->
            <xsl:apply-templates
                select="//tei:*[matches(@ana,'#bk_entry') or matches(@ana,'#gl_entryDetail') or matches(@ana, '#bk_total')]"
            />
            <xsl:apply-templates select="//tei:pb"/>
        </rdf:RDF>
    </xsl:template>
    <xd:doc>
        <xd:desc>Die Kontenliste mit den jeweiligen Summen</xd:desc>
    </xd:doc>
    <xsl:template match="//tei:taxonomy[@ana='#bk_account']">
        <!-- ToDo: 
            Die Existenz von Toplevel und die accountPaths müßte man generalisiert auslagern, d.h. nur beim Ingest von konten.xml ausführen, also einen Abarbeitungspfad legen, der von besonderen Eigenschaften von konten.xml abhängt, z.B. der PID 
        Dort müßten dann auch die skos:prefLabel zu den Konten ausgelesen werden, die in die Anzeigen einzugehen haben -->
        <rdf:Description rdf:about="{concat($xmlBaseAccounts,'#toplevel')}">
            <skos:prefLabel>Alle Konten</skos:prefLabel>
            <bk:accountPath>/</bk:accountPath>
        </rdf:Description>
        <xsl:variable name="ausgaben">
            <xsl:for-each
                select="//tei:*[matches(@ana,'#bs_Ausgaben')]//tei:*[matches(@ana,'#bk_entry')]">
                <betrag>
                    <xsl:call-template name="betrag"/>
                </betrag>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="einnahmen">
            <xsl:for-each
                select="//tei:*[matches(@ana,'#bs_Einnahmen')]//tei:*[matches(@ana,'#bk_entry')]">
                <betrag>
                    <xsl:call-template name="betrag"/>
                </betrag>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable as="xs:float" name="ergebnis">
            <xsl:value-of
                select="(sum($einnahmen/*/number(text())) - sum($ausgaben/*/number(text())))"/>
        </xsl:variable>
        <xsl:variable name="konto-id">
            <xsl:choose>
                <xsl:when test="//tei:*[matches(@ana,'#bs_Remanet')]">
                    <xsl:value-of select="//tei:*[matches(@ana,'#bs_Remanet')]/@xml:id"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$pid"/>_balance</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <rdf:Description>
            <xsl:attribute name="rdf:about" select="concat($base-uri,$konto-id, '_calc')"/>
            <rdf:type rdf:resource="http://gams.uni-graz.at/rem/bookkeeping/#bk_total_calc"/>
            <bk:mainAccount rdf:resource="{concat($xmlBaseAccounts,'#toplevel')}"/>
            <rdf:type rdf:resource="http://gams.uni-graz.at/rem/bookkeeping/#bk_balance"/>
            <g2o:partOf rdf:resource="http://gams.uni-graz.at/{$pid}"/>
            <bk:amount>
                <rdf:Description>
                    <xsl:attribute name="rdf:about" select="concat($base-uri,'toplevel_calc')"/>
                    <bk:num rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal">
                        <xsl:value-of select="string(format-number($ergebnis,'#0'))"/>
                    </bk:num>
                    <bk:unit rdf:resource="http://gams.uni-graz.at/rem/currencies/#d"/>
                    <xsl:element name="bk:as">
                        <xsl:choose>
                            <xsl:when test="$ergebnis gt 0">
                                <xsl:attribute name="rdf:resource"
                                    >http://gams.uni-graz.at/rem/bookkeping/#bk_i</xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="rdf:resource"
                                    >http://gams.uni-graz.at/rem/bookkeping/#bk_d</xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </rdf:Description>
            </bk:amount>
        </rdf:Description>
        <xsl:apply-templates mode="accounts" select="tei:category"/>
    </xsl:template>
    <xd:doc>
        <xd:desc><xd:b>Die Kontenliste:</xd:b></xd:desc>
    </xd:doc>
    <xsl:template match="tei:category" mode="accounts">
        <xsl:param name="accountPath"/>
        <rdf:Description rdf:about="{concat($xmlBaseAccounts,'#',@xml:id)}">            
                <xsl:apply-templates select="tei:catDesc"/>
                <xsl:apply-templates select="tei:catDesc/tei:name" mode="accounts"/>
            <!-- FixMe: Die Sprache mit berücksichtigen ... was Konsequenzen für die SPARQLs hat -->
            <xsl:variable name="levelup">
                <xsl:choose>
                    <xsl:when test="parent::tei:category">
                        <xsl:value-of
                            select="concat($xmlBaseAccounts,'#',parent::tei:category/@xml:id)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($xmlBaseAccounts,'#toplevel')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <rdf:type rdf:resource="http://gams.uni-graz.at/rem/bookkeeping/#account"/>
            <bk:subAccountOf rdf:resource="{$levelup}"/>
            <bk:accountPath>
                <xsl:value-of select="concat($accountPath,'/',./@xml:id)"/>
            </bk:accountPath>
        </rdf:Description>
        <xsl:variable name="betraege">
            <xsl:for-each
                select="//tei:*[matches(@ana,concat('#',current()/@xml:id))]//tei:*[matches(@ana,'#bk_entry')]">
                <betrag>
                    <xsl:call-template name="betrag"/>
                </betrag>
            </xsl:for-each>
        </xsl:variable>
        <rdf:Description>
            <xsl:attribute name="rdf:about"
                select="concat($xmlBaseAccounts,'#',$pid,'_',@xml:id, '_total_calc')"/>
            <!-- ToDo: oder doch eine ID aus der TEI-ID bilden? -->
            <rdf:type rdf:resource="http://gams.uni-graz.at/rem/bookkeeping/#bk_total_calc"/>
            <bk:mainAccount rdf:resource="{concat($xmlBaseAccounts,'#',@xml:id)}"/>
            <g2o:partOf rdf:resource="http://gams.uni-graz.at/{$pid}"/>
            <bk:amount>
                <rdf:Description>
                    <xsl:attribute name="rdf:about" select="concat($base-uri,@xml:id,'_calc')"/>
                    <bk:num rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal">
                        <xsl:value-of
                            select="string(format-number(sum($betraege/*/number(text())),'#0'))"/>
                    </bk:num>
                    <bk:unit rdf:resource="http://gams.uni-graz.at/rem/currencies/#d"/>
                    <xsl:element name="bk:as">
                        <xsl:attribute name="rdf:resource"
                            select="concat('http://gams.uni-graz.at/rem/bookkeping/',ancestor-or-self::node()[matches(@ana,'#bk_d') or matches(@ana,'#bk_i')][1]/replace(@ana,'^.*?(#bk_[id]).*?$','$1'))"
                        />
                    </xsl:element>
                </rdf:Description>
            </bk:amount>
        </rdf:Description>
        <xsl:apply-templates mode="accounts" select="tei:category">
            <xsl:with-param name="accountPath" select="concat($accountPath,'/',@xml:id)"/>
        </xsl:apply-templates>
    </xsl:template>
    <xd:doc>
        <xd:desc>Die folgenden beiden Templates werten die Kontenliste näher aus</xd:desc>
    </xd:doc>
    <xsl:template match="tei:catDesc/tei:name" mode="accounts">
        <skos:prefLabel><xsl:apply-templates /></skos:prefLabel>
    </xsl:template>
    <xsl:template match="tei:catDesc">
        <skos:definition><xsl:apply-templates /></skos:definition>
    </xsl:template>
    <xd:doc>
        <xd:desc>Falls es Schlagwörter gibt, werden sie hier ausgewertet</xd:desc>
    </xd:doc>
    <xsl:template match="//tei:*[@xml:id='srbas-schlagwoerter']">
        <xsl:for-each select=".//tei:category">
            <rdf:Description>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="concat($xmlBaseKeywords,'#',@xml:id)"/>
                </xsl:attribute>
                <rdf:type rdf:resource="skos:Concept"/>
                <skos:prefLabel>
                    <xsl:value-of select="tei:catDesc/tei:term"/>
                </skos:prefLabel>
                <skos:defintion>
                    <xsl:value-of select="tei:catDesc/tei:gloss"/>
                </skos:defintion>
            </rdf:Description>
        </xsl:for-each>
        <xsl:apply-templates select="//tei:term[@ref]"/>
    </xsl:template>
    <xsl:template match="tei:term[@ref]">
        <xsl:variable name="ref">
            <xsl:choose>
                <xsl:when test="starts-with(@ref,'#')">
                    <xsl:value-of select="concat($xmlBaseKeywords,@ref)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@ref"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <rdf:Description>
            <xsl:attribute name="rdf:about">
                <xsl:value-of
                    select="concat($base-uri,ancestor-or-self::tei:*[matches(@ana,'#bk_')][1]/@xml:id)"
                />
            </xsl:attribute>
            <g2o:hasKeyword rdf:resource="{$ref}"/>
        </rdf:Description>
    </xsl:template>
    <xd:doc>
        <xd:desc>Hier werden numerische Beträge gebildet</xd:desc>
    </xd:doc>
    <xsl:template name="betrag">
        <!-- ToDo: Umrechnung zwischen beliebigen Maßangaben, also 
                from (./@unit) und to als Parameter, mit Default und wenn @unit nicht in der Conversion-Tabelle vorhanden ist, erhalt der Maßangabe -->
        <xsl:param name="vorzeichen"/>
        <xsl:variable name="vorz" select="number(concat($vorzeichen,'1'))"/>
        <xsl:choose>
            <xsl:when test="(not(./@quantity) or ./@quantity = 0)">
                <xsl:value-of
                    select="$vorz*(sum(bk:umrechnung(./tei:num/@value,./@unit))                     + sum(sum(.//tei:measure[./@type='currency']/bk:umrechnung(tei:num/@value,@unit)))                     +     sum(.//tei:measure[./@type='currency' and ./@quantity]/bk:umrechnung(@quantity, @unit))                     +  sum(.//tei:measure[string(number(substring-before(text()[1],' '))) != 'NaN']/bk:umrechnung(number(substring-before(text()[1],' ')), ./@unit)))                     "
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$vorz*(bk:umrechnung(./@quantity, ./@unit))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>Alle mit @ana auf die Buchhaltungsontologie verweisenden Elmenete werden im folgenden verarbeitet</xd:desc>
    </xd:doc>
    <xsl:template match="*[substring-before(@ana,'_')='#bk']|*[substring-before(@ana,'_')='#gl']"
        priority="-2">
        <xsl:variable name="id">
            <xsl:choose>
                <xsl:when test="./@xml:id">
                    <xsl:value-of select="./@xml:id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <rdf:Description>
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="$base-uri"/>
                <xsl:value-of select="$id"/>
            </xsl:attribute>
            <rdf:type>
                <!-- ToDo: mehrere Inhalte in @ana werden nicht richtig ausgewertet -->
                <xsl:attribute name="rdf:resource"
                    select="replace(./@ana,'bk:','http://gams.uni-graz.at/rem/bookkeeping/#')"/>
            </rdf:type>
            <g2o:partOf rdf:resource="http://gams.uni-graz.at/{$pid}"/>
            <bk:label>
                <xsl:value-of select="./@n"/>
            </bk:label>
            <xsl:for-each
                select="ancestor-or-self::node()[name()='div' or name()='list' or name()='tr' or name()='table' or name()='ab']/tokenize(@ana,' ')">
                <xsl:call-template name="account">
                    <xsl:with-param name="accountID"
                        select="substring-after(translate(string(.),':','_'),'#')"/>
                    <xsl:with-param name="position" select="position()"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:apply-templates
                select="./tei:measure[./@type='currency'] | descendant::tei:*[matches(@ana,'#(bk|gl)_amount')]"/>
            <bk:inhalt>
                <xsl:apply-templates mode="text"/>
            </bk:inhalt>
            <!-- ToDo: "appears-on" noch in ein CIDOC-taugliches Vokabular übersetzen -->
            <g2o:appears-on rdf:resource="{concat($base-uri,'#',preceding::pb[1]/@xml:id)}"/>
        </rdf:Description>
    </xsl:template>
    <xd:doc>
        <xd:desc>Die <xd:b>Seiten</xd:b> sind auch Objekte alleine wegen der Bildreferenz</xd:desc>
    </xd:doc>
    <xsl:template match="tei:pb">
        <rdf:Description>
            <xsl:attribute name="rdf:about" select="concat($base-uri,'#',@xml:id)"/>
            <g2o:folio><xsl:value-of select="count(preceding::tei:pb)"/></g2o:folio>
            <!-- Hier käme dann die Referenz auf die URI des Bildes hinzu:
            g2o:is-depicted-by-->
        </rdf:Description>
    </xsl:template>
    <!--    <xd:doc>
        <xd:desc>Betragsangaben im Text müssen immer ein Lerzeichen davor und danach haben</xd:desc>
    </xd:doc>
    <xsl:template match="tei:measure/text()" mode="text">
        <xsl:text xml:space="preserve"> </xsl:text><xsl:value-of select="."/><xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>-->
    <xd:doc>
        <xd:desc>Betragsangaben müssen noch ein paar Informationen aus der Umgebung ziehen</xd:desc>
    </xd:doc>
    <xsl:template match="tei:measure[./@type='currency']|tei:*[matches(@ana,'#(bk|gl)_amount')]" priority="-1">
        <!-- ToDo: die Konstruktion mit measure[@type='currency'] sollte in einem allgemeinen Stylesheet raus, weil sie zu unpräzise ist: Preisangaben z.B. -->
        <xsl:element name="bk:amount">
            <xsl:element name="rdf:Description">
                <xsl:variable name="vorzeichen">
                    <xsl:if
                        test="ancestor-or-self::node()[matches(@ana,'#bk_d') or matches(@ana,'#bk_i')][1]/replace(@ana,'^.*?(#bk_[id]).*?$','$1')='#bk_d'"
                        >-</xsl:if>
                </xsl:variable>
                <xsl:attribute name="rdf:about" select="concat($base-uri,./@xml:id)"/>
                <xsl:element name="bk:as">
                    <xsl:attribute name="rdf:resource"
                        select="concat('http://gams.uni-graz.at/rem/bookkeping/',ancestor-or-self::node()[matches(@ana,'#bk_d') or matches(@ana,'#bk_i')][1]/replace(@ana,'^.*?(#bk_[id]).*?$','$1'))"
                    />
                </xsl:element>
                <xsl:element name="bk:num">
                    <xsl:attribute name="rdf:datatype"
                        >http://www.w3.org/2001/XMLSchema#decimal</xsl:attribute>
                    <xsl:call-template name="betrag">
                        <xsl:with-param name="vorzeichen" select="$vorzeichen"/>
                    </xsl:call-template>
                </xsl:element>
                <xsl:element name="bk:unit">
                    <xsl:attribute name="rdf:resource"
                        >http://gams.uni-graz.at/rem/currencies/#d</xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xd:doc>
        <xd:desc>Konteninferenz</xd:desc>
    </xd:doc>
    <xsl:template name="account">
        <xsl:param name="accountID"/>
        <xsl:param name="position"/>
        <xsl:if test="$accounts//tei:category[@xml:id/string() = $accountID]">
            <xsl:element name="bk:account">
                <xsl:attribute name="rdf:resource" select="concat($xmlBaseAccounts,.)"/>
            </xsl:element>
            <xsl:if test="$position=last()">
                <xsl:element name="bk:mainAccount">
                    <xsl:attribute name="rdf:resource" select="concat($xmlBaseAccounts,.)"/>
                </xsl:element>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc>Der Rest wird nicht ins RDF übernommen</xd:desc>
    </xd:doc>
    <xsl:template match="*|@*" priority="-3"/>
</xsl:stylesheet>
