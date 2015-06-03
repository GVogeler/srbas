
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:rm="org.emile.roman.Roman" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#default bk tei xd" version="2.0">
  <xsl:import href="http://gams.uni-graz.at/archive/objects/cirilo:srbas/datastreams/STYLESHEET.MAIN/content"></xsl:import>
  <xsl:import href="http://gams.uni-graz.at/archive/objects/cirilo:srbas/datastreams/STYLESHEET.TAB_DEBUG/content"></xsl:import>
  <xsl:import href="http://gams.uni-graz.at/archive/objects/cirilo:srbas/datastreams/STYLESHEET.TAB/content"></xsl:import>
  <xsl:import href="http://gams.uni-graz.at/archive/objects/cirilo:srbas/datastreams/STYLESHEET.CONVERSIONS/content"></xsl:import>
  <xd:docd>
    <xd:desc>TODO:
        Eine seitenweise Verarbeitung hinzufügen: $context ist die Nummer der Seite (oder die xml:id?), drumherum bleibt alles gleich
    </xd:desc>
  </xd:docd>
  <xsl:param name="context"></xsl:param>
  <xsl:param name="mode"></xsl:param>
  <xsl:param name="locale"></xsl:param>
  <xsl:variable name="pid" select="replace(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID']/text(),'info:fedora/','')"></xsl:variable>
  <xd:doc>
    <xd:desc>
      Verzweigung der verschiedenen Anzeigemodi</xd:desc>
  </xd:doc>
  <xsl:template name="content">
    <script src="http://gams.uni-graz.at/archive/objects/cirilo:srbas/datastreams/JS.BOOKKEEPING/content" type="text/javascript">//</script>
    <script src="http://gams.uni-graz.at/rem/navigation.js" type="text/javascript">//</script>
    <div class="titlepage">
      <div class="titlepage_header">
        <p class="logoGAMS">
          <a href="http://gams.uni-graz.at">
            <img alt="Geisteswissenschaftliches Asset Management System" class="logoGams" height="48" src="http://gams.uni-graz.at/reko/img/gamslogo_weiss.png" title="Geisteswissenschaftliches Asset Management System" width="128"></img>
          </a>
          <br></br> Geisteswissenschaftliches Asset Management System
        </p>
        <p class="unilogo_graz">
          <a class="unilogo" href="http://www.uni-graz.at">
            <img alt="Karl-Franzens-Universität Graz" class="logoUni" height="62" src="http://gams.uni-graz.at/reko/img/uniGraz.gif" title="Karl-Franzens-Universität Graz" width="73"></img>
          </a>
        </p>
        <p class="unilogo_basel">
          <a class="unilogo" href="http://www.unibas.ch/">
            <img alt="Universität Basel" class="logoUni" height="62" src="http://urz.unibas.ch/files/documents/unilogoschwarz.gif" title="Universität Basel" width="73"></img>
          </a>
        </p>
      </div>
      <main>
        <h1>
          <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"></xsl:value-of>
        </h1>
        <div id="info">
          <p>Zitiervorschlag: ######</p>
          <p>Transkription von:
        <ul class="transkription_von">
              <xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:persName">
                <li>
                  <xsl:value-of select="."></xsl:value-of>
                </li>
              </xsl:for-each>
            </ul>
          </p>
        </div>
        <div id="kontakt">
          <h6>Kontakt:</h6>
          <p>Prof. Dr. Susanna Burghartz (http://www.burghartz.ch)              
          <br></br>Universität Basel
          <br></br>Departement Geschichte
        </p>
        </div>
      </main>
    </div>
    <div class="ym-wrapper">
      <div class="ym-wbox">
        <xsl:choose>
          <xsl:when test="$mode='tab'">
            <xsl:apply-templates mode="tab"></xsl:apply-templates>
          </xsl:when>
          <xsl:when test="$mode='debug'">
            <xsl:apply-templates mode="debug"></xsl:apply-templates>
          </xsl:when>
          <xsl:when test="$mode='tab-debug'">
            <xsl:apply-templates mode="tab-debug"></xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates></xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
  </xsl:template>
  <xd:doc>
    <xd:desc>Hier beginnt der eigentliche Inhalt</xd:desc>
  </xd:doc>
  <xsl:variable name="accounts" select="//tei:taxonomy[@ana='#bk_account']"></xsl:variable>
  <xsl:variable name="xmlBaseAccounts" select="//tei:classDecl[.//tei:taxonomy/@ana='#bk_account']/@xml:base"></xsl:variable>
  <xsl:template match="tei:TEI">
    <div class="ym-grid">
      <div class="ym-g960-4 ym-gl" id="Navigation">
        <div class="ym-gbox ym-clearfix" id="toc-wrapper" xml:space="preserve">
         <ul id="toc" xml:space="preserve"></ul>
          
          
          
        </div>
      </div>
      <div class="ym-g960-6 ym-gl" id="Hauptteil">
        <div class="ym-gbox ym-clearfix haupt">
          <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:p"></xsl:apply-templates>
          <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt//tei:p"></xsl:apply-templates>
          <xsl:choose>
            <xsl:when test="$mode='page'">
              <xsl:apply-templates mode="page" select="//tei:pb[@xml:id=$context]"></xsl:apply-templates>
            </xsl:when>
            <xsl:when test="$mode='debugging'">
              <xsl:apply-templates mode="d" select="//tei:body"></xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="//tei:body"></xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <div class="ym-gbox ym-clearfix appendix">
          <div id="appendix" xml:space="preserve">
            <xsl:variable name="fncontext"> 
              <xsl:choose>
                <xsl:when test="$mode='page' and not($context='')">
                  <xsl:variable name="my-pb" select="//tei:pb[@xml:id=$context]"></xsl:variable>
                  <xsl:copy-of select="bk:fragment($my-pb, $my-pb/following::tei:pb[1], $my-pb/ancestor::node()[. = $my-pb/following::tei:pb[1]/ancestor::node()][1])"></xsl:copy-of>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="//tei:body"></xsl:copy-of>
                </xsl:otherwise>
              </xsl:choose>
              </xsl:variable>
            
            <h1 class="fussnotenapparat">Fussnotenapparat</h1>
            
            <xsl:apply-templates mode="fn-text" select="$fncontext//tei:note[@resp='#editor']"></xsl:apply-templates>
            <p class="fussnotenapparat">Textkritsche Anmerkungen</p>
                      
            <xsl:for-each select="$fncontext//(tei:*[@rend='margin']|tei:addSpan|tei:damage|tei:gap|tei:supplied|tei:add|tei:unclear|tei:del|tei:app/tei:rdg|tei:space|tei:sic)|$fncontext//tei:note[not(@resp='#editor')]">
              <xsl:variable name="fn"><xsl:apply-templates mode="fn-text" select="."></xsl:apply-templates></xsl:variable>
              <xsl:if test="not(../../tei:*[@rend='margin']|tei:addSpan|tei:damage|tei:gap|tei:supplied|tei:note[not(@resp='#editor')]|tei:add|tei:unclear|tei:del|tei:app/tei:rdg|tei:space|tei:sic/text()/normalize-space()='')"><xsl:copy-of select="$fn"></xsl:copy-of></xsl:if>
            </xsl:for-each>
    
          </div>
        </div>
      </div>
      <div class="ym-g960-4 ym-gr" id="calc">
        <div class="ym-gbox ym-clearfix" id="Infobox">
          <h2>
            <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"></xsl:value-of>
          </h2>
          <p class="title">
            <xsl:apply-templates select="//tei:sourceDesc/tei:msDesc/tei:msIdentifier"></xsl:apply-templates>
          </p>
          <p>
            <span class="icons">
              <a href="#" onclick="window.print();">
                <img height="41" src="http://gams.uni-graz.at/srbas/image/print-button.png" title="Drucken"></img>
              </a>
            </span>
            <span class="icons">
              <a href="http://gams.uni-graz.at/archive/objects/{$pid}/methods/sdef:TEI/get?mode=tab" title="Als Tabelle anzeigen">
                <img alt="Als Tabelle anzeigen" height="41" src="http://gams.uni-graz.at/srbas/image/table.png"></img>
              </a>
            </span>
            <span class="icons">
              <a href="http://gams.uni-graz.at/archive/objects/{$pid}/datastreams/TEI_SOURCE/content" target="_blank">
                <img height="41" src="http://gams.uni-graz.at/srbas/image/TEI-400.jpg" title="TEI Download"></img>
              </a>
            </span>
            <span class="icons">
              <a href="http://gams.uni-graz.at/archive/objects/{$pid}/datastreams/RDF/content" target="_blank">
                <img height="41" src="http://gams.uni-graz.at/srbas/image/rdf_w3c_icon.128" title="RDF Download"></img>
              </a>
            </span>
          </p>
          <p class="zitiervorschlag">Zitiervorschlag: ######</p>
          <p class="transkription_von">Transkription von:</p>
          <ul class="transkription_von">
            <xsl:for-each select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt/tei:persName">
              <li>
                <xsl:value-of select="."></xsl:value-of>
              </li>
            </xsl:for-each>
          </ul>
        </div>
        <div class="ym-gbox ym-clearfix" id="Datenkorb">
          <h2>Datenkorb</h2>
          <div id="calculations">
            <xsl:text></xsl:text>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>
  <xd:doc>
    <xd:desc>Die einzelnen Templates</xd:desc>
  </xd:doc>
  <xsl:template match="tei:body">
    <xsl:apply-templates></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="tei:metamark"></xsl:template>
  <xsl:template match="text()">
    <xsl:choose>
      <xsl:when test="$context and not($mode='page')">
        <xsl:call-template name="bk:highlighter"></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:desc>Hervorhebungen von Suchergebnissen</xd:desc>
  </xd:doc>
  <xsl:template name="bk:highlighter">
    <xsl:analyze-string regex="{$context}" select=".">
      <xsl:matching-substring>
        <span class="highlight" id="hit" name="hit">
          <xsl:value-of select="."></xsl:value-of>
        </span>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select="."></xsl:value-of>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:template>
  <xsl:function name="bk:tabulator">
    <xsl:param name="input"></xsl:param>
    <xsl:if test="contains($input,'#|#')">
      <xsl:value-of select="substring-before($input,'#|#')"></xsl:value-of>
      <span class="tab">
        <xsl:text></xsl:text>
      </span>
      <xsl:value-of select="substring-after($input,'#|#') "></xsl:value-of>
    </xsl:if>
  </xsl:function>
  <xd:doc>
    <xd:desc>Abschnitten</xd:desc>
  </xd:doc>
  <xsl:template match="tei:div">
    <div class="anchor">
      <xsl:apply-templates select="@xml:id"></xsl:apply-templates>
      <xsl:if test="matches(@ana,'#bs_')">
        <xsl:attribute name="data-type">
          <xsl:text>#bk_account</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="substring-before(./@ana,'_') = '#bk'">
        <xsl:attribute name="data-type">
          <xsl:value-of select="./@ana"></xsl:value-of>
        </xsl:attribute>
        <xsl:call-template name="bk">
          <xsl:with-param name="element" select="."></xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates></xsl:apply-templates>
    </div>
  </xsl:template>
  <xd:doc>
    <xd:desc>Listen</xd:desc>
  </xd:doc>
  <xsl:template match="tei:list">
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="@xml:id">
          <xsl:apply-templates select="@xml:id"></xsl:apply-templates>
        </xsl:when>
        <xsl:when test="tei:head">
          <a>
            <xsl:attribute name="id">heading_<xsl:value-of select="translate(tei:head,' -+#?&amp;;.,!:()/§$%=`´\}][{*~|','')"></xsl:value-of>
            </xsl:attribute>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="id">
              <xsl:value-of select="generate-id(.)"></xsl:value-of>
            </xsl:attribute>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates select="tei:head"></xsl:apply-templates>
    <ul class="entries undot">
      <xsl:if test="substring-before(./@ana,'_') = '#bk'">
        <xsl:attribute name="data-type">
          <xsl:value-of select="./@ana"></xsl:value-of>
        </xsl:attribute>
        <xsl:call-template name="bk">
          <xsl:with-param name="element" select="."></xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select="tei:item |tei:pb|tei:lb"></xsl:apply-templates>
    </ul>
  </xsl:template>
  <xd:doc>
    <xd:desc>Überschriften</xd:desc>
  </xd:doc>
  <xsl:template match="tei:head">
    <xsl:variable name="tiefe" select="count(./ancestor-or-self::node()[name()='div' or name()='list'][matches(@ana,'#bs_')][tei:head])"></xsl:variable>
    <xsl:choose>
      <xsl:when test="$tiefe gt 0">
        <xsl:element name="h{$tiefe}">
          <xsl:attribute name="id">
            <xsl:value-of select="current()/@xml:id"></xsl:value-of>
          </xsl:attribute>
          <xsl:if test="matches(parent::tei:div/@ana,'#bs_')">
            <xsl:attribute name="title">
              <xsl:value-of select="document('/archive/objects/o:srbas.konten/datastreams/TEI_SOURCE/content')//tei:category[@xml:id=replace(current()/ancestor::tei:div[1]/@ana,'^.*?#(bs_.*?)($|\s)','$1')]/tei:catDesc/tei:name"></xsl:value-of>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates></xsl:apply-templates>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <div class="head">
          <xsl:apply-templates></xsl:apply-templates>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:lb">
    <span class="diplomatic visible notToC">
      <xsl:if test="@break='no'">-</xsl:if>
      <br></br>
    </span>
  </xsl:template>
  <xd:doc>
    <xd:desc>Seitensummen, Seitenüberschriften etc.</xd:desc>
  </xd:doc>
  <xsl:template match="tei:fw[not(@ana)]">
    <p class="fw_head">
      <xsl:apply-templates></xsl:apply-templates>
    </p>
  </xsl:template>
  <xd:doc>
    <xd:desc>Summen</xd:desc>
  </xd:doc>
  <xsl:template match="tei:p|tei:closer">
    <p>
      <xsl:if test="matches(@ana,'#bk_')">
        <xsl:attribute name="id" select="./@xml:id"></xsl:attribute>
        <xsl:attribute name="class" select="normalize-space(replace(@ana,'#bk_(.*?)(\s|$)',' $1'))"></xsl:attribute>
        <xsl:attribute name="data-type">
          <xsl:value-of select="./@ana"></xsl:value-of>
        </xsl:attribute>
        <xsl:call-template name="bk">
          <xsl:with-param name="element" select="."></xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="concat('#',@xml:id) = preceding-sibling::tei:metamark[1]/@spanTo">
          <span title="Hinter der Klammer">
            <xsl:text>└──▷</xsl:text>
          </span>
        </xsl:when>
        <xsl:when test="preceding-sibling::tei:metamark[1][contains(@rend,'Klammer')] and not(preceding-sibling::*[concat('#',@xml:id) = preceding::tei:metamark[1]/@spanTo])">
          <span title="Klammer">
            <xsl:text>│</xsl:text>
          </span>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates></xsl:apply-templates>
    </p>
  </xsl:template>
  <xsl:template match="tei:item">
    <li>
      <xsl:apply-templates select="@xml:id"></xsl:apply-templates>
      <xsl:if test="substring-before(./@ana,'_') = '#bk'">
        <xsl:attribute name="class">
          <xsl:if test="$context">
            <xsl:choose>
              <xsl:when test="matches(.,$context)">hit</xsl:when>
              <xsl:otherwise>nohit</xsl:otherwise>
            </xsl:choose>
            <xsl:text></xsl:text>
          </xsl:if>
          <xsl:value-of select="translate(./@ana,':','_')"></xsl:value-of>
        </xsl:attribute>
        <xsl:attribute name="data-type">
          <xsl:value-of select="./@ana"></xsl:value-of>
        </xsl:attribute>
        <xsl:if test="($context and matches(.,$context))">
          <xsl:attribute name="style">background-color:yellow;</xsl:attribute>
        </xsl:if>
        <xsl:if test="(matches(.,$context)) or not($context)">
          <xsl:call-template name="bk">
            <xsl:with-param name="element" select="."></xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:if>
      <xsl:if test="preceding-sibling::tei:metamark[1]/contains(@rend,'Klammer')">
        <xsl:text>↓</xsl:text>
      </xsl:if>
      <xsl:if test="concat('#',@xml:id) = preceding::tei:metamark[1]/@spanTo">
        <xsl:text>└──→</xsl:text>
      </xsl:if>
      <xsl:apply-templates></xsl:apply-templates>
    </li>
  </xsl:template>
  <xd:doc>
    <xd:desc>Seiten</xd:desc>
  </xd:doc>
  <xsl:template match="tei:pb">
    <xsl:variable name="facs" select="substring-after(./@facs, '#')"></xsl:variable>
    <xsl:variable name="seitenzahl">
      <xsl:choose>
        <xsl:when test="@n">
          <xsl:value-of select="@n"></xsl:value-of>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="ceiling((count(preceding::tei:pb) + 1) div 2)"></xsl:value-of>
          <xsl:choose>
            <xsl:when test="(count(preceding::tei:pb) + 1) mod 2 = 1">r</xsl:when>
            <xsl:otherwise>v</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <p class="ym-g20 folio editor">
      <xsl:apply-templates select="@xml:id"></xsl:apply-templates>
      <a id="fol{$seitenzahl}" xml:space="preserve"></a>
      <a target="_blank">
        <xsl:attribute name="href">
          <xsl:text>/archive/objects/</xsl:text>
          <xsl:value-of select="$pid"></xsl:value-of>
          <xsl:text>/datastreams/</xsl:text>
          <xsl:value-of select="//tei:surface[@xml:id = $facs]/tei:graphic/@xml:id"></xsl:value-of>
          <xsl:text>/content</xsl:text>
        </xsl:attribute>
        <xsl:text>fol. </xsl:text>
        <xsl:value-of select="$seitenzahl"></xsl:value-of>
      </a>
    </p>
  </xsl:template>
  <xsl:template match="tei:pb[@xml:id=$context]" mode="page">
    <xsl:variable name="facs" select="substring-after(./@facs, '#')"></xsl:variable>
    <xsl:variable name="seitenzahl">
      <xsl:choose>
        <xsl:when test="@n">
          <xsl:value-of select="@n"></xsl:value-of>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="ceiling((count(preceding::tei:pb) + 1) div 2)"></xsl:value-of>
          <xsl:choose>
            <xsl:when test="(count(preceding::tei:pb) + 1) mod 2 = 1">r</xsl:when>
            <xsl:otherwise>v</xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <p class="ym-g20 folio editor">
      <xsl:apply-templates select="@xml:id"></xsl:apply-templates>
      <a id="fol{$seitenzahl}" xml:space="preserve"></a>
      <xsl:if test="preceding::tei:pb[1]/@xml:id">
        <a href="?mode=page&amp;context={preceding::tei:pb[1]/@xml:id}" title="Vorherige Seite">«</a>
        <xsl:text xml:space="preserve"> </xsl:text>
      </xsl:if>
      <a target="_blank">
        <xsl:attribute name="href">
          <xsl:text>/archive/objects/</xsl:text>
          <xsl:value-of select="$pid"></xsl:value-of>
          <xsl:text>/datastreams/</xsl:text>
          <xsl:value-of select="//tei:surface[@xml:id = $facs]/tei:graphic/@xml:id"></xsl:value-of>
          <xsl:text>/content</xsl:text>
        </xsl:attribute>
        <xsl:text>fol. </xsl:text>
        <xsl:value-of select="$seitenzahl"></xsl:value-of>
      </a>
      <xsl:if test="following::tei:pb[1]/@xml:id">
        <xsl:text xml:space="preserve"> </xsl:text>
        <a href="?mode=page&amp;context={following::tei:pb[1]/@xml:id}" title="Nächste Seite">»</a>
      </xsl:if>
    </p>
    <xsl:apply-templates select="bk:fragment(current(), current()/following::tei:pb[1], current()/ancestor::node()[. = current()/following::tei:pb[1]/ancestor::node()][1])"></xsl:apply-templates>
  </xsl:template>
  <xd:doc>
    <xd:desc>Lagenwechsel</xd:desc>
  </xd:doc>
  <xsl:template match="gb"></xsl:template>
  <xd:doc>
    <xd:desc>Referenzen</xd:desc>
  </xd:doc>
  <xsl:template match="*[(./@corresp and not(substring-before(@ana,'_') = '#bk')) or ./@key]">
    <xsl:variable name="element" select="."></xsl:variable>
    <xsl:variable name="ref">
      <xsl:choose>
        <xsl:when test="./@target">
          <xsl:value-of select="./@target"></xsl:value-of>
        </xsl:when>
        <xsl:when test="./@key">
          <xsl:value-of select="./@key"></xsl:value-of>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="./@corresp"></xsl:value-of>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <a class="object">
      <xsl:attribute name="href" select="$ref"></xsl:attribute>
      <xsl:attribute name="title" select="//tei:note[@xml:id = substring-after($ref,'#')]/string()"></xsl:attribute>      
<xsl:apply-templates></xsl:apply-templates>
    </a>
  </xsl:template>
  <xsl:template match="@xml:id">
    <xsl:attribute name="id" select="./string()"></xsl:attribute>
  </xsl:template>
  <xd:doc>
    <xd:desc>Anzeigevorgaben aus @rend werden wie Klassen behandelt</xd:desc>
  </xd:doc>
  <xsl:template match="@rend">
    <xsl:attribute name="class">
      <xsl:value-of select="."></xsl:value-of>
    </xsl:attribute>
  </xsl:template>
  <xd:doc>
    <xd:desc>
      <xd:p>Textkritische Beobachtungen</xd:p>
      <xd:p>vorkommende Verschachtelungen:
        damage/gap =&gt; Beschädigung mit Textverlust
        damage/note =&gt; Beschädigung mit Kommentar
        damage/supplied =&gt; Beschädigung mit Textergänzung
        del/damage =&gt; Streichung eines beschädigt Texts
        del/gap =&gt; Streichung mit Textverlust
        del/unclear =&gt; Streichung mit unleserlichem Text
        supplied/del =&gt; Erschlossener Text mit Streichung
        supplied/gap =&gt; Erschlossener Text mit Lücke
        supplied/note =&gt; Erschlossener Text mit Kommentar
        supplied/unclear =&gt; Erschlossener Text mit unleserlicher Stelle
        *[@rend='margin']: =&gt; Am Rand
            note/damage =&gt; ... mit Schaden
            note/supplied =&gt; ... mit erschlossenem Text
            p/damage =&gt; ... mit Schaden
            p/supplied =&gt; ... mit erschlossenem Text
            fw/damage =&gt; ... mit Schaden
            closer/damage =&gt; mit Schaden
        note/damage =&gt; Kommentar mit Schaden
        note/gap =&gt; Kommentar mit Lücke
        note/supplied =&gt; Kommentar mit erschlossenem Text
        note/unclear =&gt; Kommentar mit unleserlichem Text
        
        damage/gap
        damage/note
        damage/supplied
        del/damage
        del/gap
        del/unclear
        note/damage
        note/gap
        note/supplied
        note/unclear
        p/damage
        p/supplied
        r:e/damage
        r:sum/damage
        supplied/del
        supplied/gap
        supplied/note
        supplied/unclear
      </xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="tei:*[@rend='margin']">
    <span class="margin" title="am Rand">
      <xsl:apply-templates></xsl:apply-templates>
    </span>
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
      <xsl:attribute name="title">
        <xsl:text>am Rand</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:*[@rend='margin']" mode="fn-text">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>
        <xsl:text>) </xsl:text>
      </a>
      <xsl:text>am Rand</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="tei:note[@type='Rechnungsabhör']|tei:add[@type='Rechnungsabhör']" priority="1">
    <span class="margin add" title="nachträglich hinzugefügter Vermerk über die Rechnungsabhör">
      <xsl:apply-templates></xsl:apply-templates>
    </span>
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
      <xsl:attribute name="title">
        <xsl:text>nachträglich hinzugefügter Vermerk über die Rechnungsabhör</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:note[@type='Rechnungsabhör']|tei:add[@type='Rechnungsabhör']" mode="fn-text" priority="1">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>
        <xsl:text>) </xsl:text>
      </a>
      <xsl:text>nachträglich hinzugefügter Vermerk über die Rechnungsabhör</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="tei:note[not(@resp='#editor')][not(@rend='margin')][not(parent::tei:damage)]">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <xsl:apply-templates></xsl:apply-templates>
    <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
      <xsl:attribute name="title">Anmerkung im Original</xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:note[not(@resp='#editor')][not(@rend='margin')][not(parent::tei:damage)]" mode="fn-text">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>
        <xsl:text>) </xsl:text>
      </a>
      Anmerkung im Original.</p>
  </xsl:template>
  <xsl:template match="tei:addSpan">
    <span class="margin add" xml:space="preserve">
      <xsl:apply-templates></xsl:apply-templates>
    </span>
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
      <xsl:attribute name="title">
        <xsl:text>auf einem beigefügten Zettel</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:addSpan" mode="fn-text">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>
        <xsl:text>) </xsl:text>
      </a>
      <xsl:text>auf einem beigefügten Zettel</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="tei:damage">
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:text>[</xsl:text>
    <span class="mouseover">
      <xsl:choose>
        <xsl:when test="current()/tei:supplied">
          <xsl:attribute name="title">
            <xsl:text>Beschädigt, rekonstruierte Angaben aus: </xsl:text>
            <xsl:value-of select="document('http://gams.uni-graz.at/archive/objects/o:srbas.suppliedSources/datastreams/TEI_SOURCE/content')//tei:item[@xml:id=current()/tei:supplied/@source/substring-after(.,'#')]"></xsl:value-of>
          </xsl:attribute>
          <xsl:apply-templates></xsl:apply-templates>
        </xsl:when>
        <xsl:when test="current()/tei:gap[not(following-sibling::tei:note or following-sibling::tei:supplied or preceding-sibling::tei:supplied)]">
          <xsl:attribute name="title">
            <xsl:text>Beschädigt</xsl:text>
          </xsl:attribute>
          <xsl:text>...g</xsl:text>
        </xsl:when>
        <xsl:when test="current()/tei:note[parent::tei:damage]">
          <xsl:attribute name="title">
            <xsl:text>Beschädigt, vermutlich: </xsl:text>
            <xsl:value-of select="normalize-space(.)"></xsl:value-of>
          </xsl:attribute>
          <xsl:text>...</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="title">
            <xsl:text>Beschädigt</xsl:text>
          </xsl:attribute>
          <xsl:apply-templates></xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </span>
    <xsl:text>]</xsl:text>
    <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
      <xsl:attribute name="title">
        <xsl:text>Beschädigt</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:damage" mode="fn-text">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>
        <xsl:text>) </xsl:text>
      </a>
      <xsl:if test="text()/normalize-space()=''">
        <xsl:for-each select="child::tei:*">      
    <xsl:apply-templates mode="fn-text" select="."></xsl:apply-templates>
        </xsl:for-each>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="current()/tei:supplied">
          <xsl:text>Beschädigt, rekonstruierte Angaben aus:</xsl:text>
          <br></br>
          <span class="quelle">
            <xsl:value-of select="document('http://gams.uni-graz.at/archive/objects/o:srbas.suppliedSources/datastreams/TEI_SOURCE/content')//tei:item[@xml:id=current()/tei:supplied/@source/substring-after(.,'#')]"></xsl:value-of>
          </span>
        </xsl:when>
        <xsl:when test="current()/tei:gap[not(following-sibling::tei:note or following-sibling::tei:supplied or preceding-sibling::tei:supplied)]">
          <xsl:text>Beschädigt</xsl:text>
        </xsl:when>
        <xsl:when test="current()/tei:note[parent::tei:damage]">
          <xsl:text>Beschädigt, vermutlich: </xsl:text>
          <xsl:text>&quot;</xsl:text>
          <xsl:value-of select="."></xsl:value-of>
          <xsl:text>&quot;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Beschädigt</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </p>
  </xsl:template>
  <xsl:template match="tei:unclear">
    <xsl:text>[</xsl:text>
    <span class="mouseover">
      <xsl:attribute name="title">
        <xsl:text>Beschädigt, vermutlich: </xsl:text>
        <xsl:value-of select="."></xsl:value-of>
      </xsl:attribute>
      <xsl:apply-templates></xsl:apply-templates>
    </span>
    <xsl:text>]</xsl:text>
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
      <xsl:attribute name="title">
        <xsl:text>Lesung unsicher</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:unclear" mode="fn-text">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>
        <xsl:text>) </xsl:text>
      </a>
      <xsl:text> Lesung unsicher</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="tei:supplied[not(ancestor::tei:damage|ancestor::tei:note|ancestor::tei:del|ancestor::tei:add)]">
    <xsl:text>[</xsl:text>
    <span class="mouseover">
      <xsl:attribute name="title">
        <xsl:text>Beschädigt, vermutlich: </xsl:text>
        <xsl:value-of select="."></xsl:value-of>
      </xsl:attribute>
      <xsl:apply-templates></xsl:apply-templates>
    </span>
    <xsl:text>]</xsl:text>
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
      <xsl:attribute name="title">
        <xsl:text>Ergänzt aus:</xsl:text>
        <xsl:value-of select="//tei:item[@xml:id=current()/@source/substring-after(.,'#')]"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:supplied[not(ancestor::tei:damage|ancestor::tei:note|ancestor::tei:del|ancestor::tei:add)]" mode="fn-text">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>
        <xsl:text>) </xsl:text>
      </a>
      <xsl:text> Ergänzt aus:</xsl:text>
      <br></br>
      <span class="quelle">
        <xsl:value-of select="//tei:item[@xml:id=current()/@source/substring-after(.,'#')]"></xsl:value-of>
      </span>
    </p>
  </xsl:template>
  <xsl:template match="tei:del">
    <del class="del" title="Streichung im Original">
      <xsl:apply-templates></xsl:apply-templates>
    </del>
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
      <xsl:attribute name="title">
        <xsl:text>Streichung im Original</xsl:text> 
     </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:del" mode="fn-text">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>
        <xsl:text>) </xsl:text>
      </a>
      <xsl:text>Streichung im Original</xsl:text>
    </p>
  </xsl:template>
  <xsl:template match="tei:add">
    <span class="add" title="Hinzufügung im Original">
      <xsl:apply-templates></xsl:apply-templates>
    </span>
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
      <xsl:attribute name="title">
        <xsl:text>Hinzufügung im Original</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:add" mode="fn-text">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>) </a>
      <xsl:text>Hinzufügung</xsl:text>
      <xsl:apply-templates mode="fn-text"></xsl:apply-templates>
    </p>
  </xsl:template>
  <xsl:template match="tei:sic|tei:space|tei:corr">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <xsl:apply-templates></xsl:apply-templates>
    <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
      <xsl:attribute name="title">
        <xsl:value-of select="concat(name(.), ' ', ./@reason, ' ', @extent)"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:sic|tei:space|tei:corr" mode="fn-text">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>
        <xsl:text>) </xsl:text>
      </a>
      <xsl:value-of select="concat(name(.), ' ', ./@reason, ' ', @extent)"></xsl:value-of>
    </p>
  </xsl:template>
  <xsl:template match="tei:gap">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <span class="mouseover">
      <xsl:attribute name="title">Lücke <xsl:value-of select="concat(./@reason, ' ', @extent)"></xsl:value-of>
      </xsl:attribute>[…]</span>
    <xsl:if test="not(ancestor::tei:damage|ancestor::tei:note|ancestor::tei:del|ancestor::tei:add|tei:supplied)">
      <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
        <xsl:attribute name="title">Lücke<xsl:text></xsl:text>
          <xsl:value-of select="concat(./@reason, ' ', @extent)"></xsl:value-of>
        </xsl:attribute>
        <xsl:value-of select="$n"></xsl:value-of>
      </a>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tei:gap[not(ancestor::tei:damage|ancestor::tei:note|ancestor::tei:del|ancestor::tei:add|tei:supplied)]" mode="fn-text">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>
        <xsl:text>) </xsl:text>
      </a>
      <xsl:text>Lücke </xsl:text>
      <xsl:value-of select="concat(./@reason, ' ', @extent)"></xsl:value-of>
    </p>
  </xsl:template>
  <xsl:template match="text()" mode="fn-text"></xsl:template>
  <xd:doc>
    <xd:desc>Weitere Templates für Textphänomene:</xd:desc>
  </xd:doc>
  <xsl:template match="tei:foreign">
    <span class="foreign">
      <xsl:apply-templates></xsl:apply-templates>
    </span>
  </xsl:template>
  <xsl:template match="tei:g">
    <span title="{./@rend}">
      <xsl:apply-templates></xsl:apply-templates>
    </span>
  </xsl:template>
  <xsl:template match="tei:seg[@rend='super' or @rend='superscript']">
    <span class="sup">
      <xsl:apply-templates></xsl:apply-templates>
    </span>
  </xsl:template>
  <xsl:template match="tei:ref">
    <a href="{@target}">
      <xsl:apply-templates></xsl:apply-templates>
    </a>
  </xsl:template>
  <xsl:template match="@wit">
    <xsl:text></xsl:text>
    <span class="editor">
      <xsl:value-of select="."></xsl:value-of>
    </span>
  </xsl:template>
  <xsl:template match="tei:choice">
    <xsl:apply-templates select="tei:corr|tei:sic"></xsl:apply-templates>
  </xsl:template>
  <xsl:function name="bk:textcriticalnote">
    <xsl:param name="element"></xsl:param>
    <xsl:value-of select="bk:alphanumerisch($element/count(preceding::tei:*[@rend='margin'][not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]|preceding::tei:app[not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]|preceding::tei:add[not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]|preceding::tei:del[not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]|preceding::tei:addSpan[not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]|preceding::tei:space[not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]|preceding::tei:sic[not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]|preceding::tei:damage[not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]|preceding::tei:note[not(@resp='#editor')][not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]|preceding::tei:unclear[not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]|preceding::tei:gap[not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]|preceding::tei:supplied[not(ancestor::tei:unclear|ancestor::tei:add|ancestor::tei:del|ancestor::tei:damage|ancestor::tei:supplied|ancestor::tei:note|ancestor::tei:*[@rend='margin'])]))"></xsl:value-of>
  </xsl:function>
  <xsl:function name="bk:alphanumerisch">
    <xsl:param name="number"></xsl:param>
    <xsl:value-of select="codepoints-to-string(97+ ($number mod 26))"></xsl:value-of>
    <xsl:if test="floor($number div 26) gt 0">
      <xsl:value-of select="bk:for-to(1,floor($number div 26))"></xsl:value-of>
    </xsl:if>
  </xsl:function>
  <xsl:function name="bk:for-to">
    <xsl:param name="von"></xsl:param>
    <xsl:param name="to"></xsl:param>
    <xsl:choose>
      <xsl:when test="$von = $to">
        <xsl:value-of select="$von"></xsl:value-of>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="bk:for-to(($von + 1),$to)"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  <xd:doc>
    <xd:desc>Anmerkungen des Editors</xd:desc>
  </xd:doc>
  <xsl:template match="tei:note[@resp='#editor']">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:footnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}" id="up_{$id}">
      <xsl:attribute name="title">
        <xsl:value-of select=".//text()"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:note[@resp='#editor']" mode="fn-text">
    <xsl:variable name="id" select="@xml:id"></xsl:variable>
    <xsl:variable name="n" select="bk:footnote(.)"></xsl:variable>
    <p class="note" id="{$id}">
      <a class="footnote_number" href="#up_{$id}" onclick="scrollup()">
        <xsl:value-of select="$n"></xsl:value-of>
        <xsl:text>) </xsl:text>
      </a>
      <xsl:apply-templates></xsl:apply-templates>
      <span class="italics">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="//tei:persName[@xml:id='editor']"></xsl:value-of>
        <xsl:text>)</xsl:text>
      </span>
    </p>
  </xsl:template>
  <xsl:function name="bk:footnote">
    <xsl:param name="element"></xsl:param>
    <xsl:value-of select="count($element//preceding::tei:note[@resp='#editor']) + 1"></xsl:value-of>
  </xsl:function>
  <xsl:template match="tei:measure">
    <span>
      <xsl:if test="substring-before(./@ana,'_') = '#bk'">
        <xsl:attribute name="data-type">
          <xsl:value-of select="./@ana"></xsl:value-of>
        </xsl:attribute>
        <xsl:call-template name="bk">
          <xsl:with-param name="element" select="."></xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="./tei:num">
          <xsl:apply-templates></xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates></xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>
  <xsl:template match="tei:num">
    <span class="edition invisible">
      <xsl:value-of select="@value"></xsl:value-of>
    </span>
    <span class="diplomatic visible">
      <xsl:attribute name="title">
        <xsl:value-of select="@value"></xsl:value-of>
      </xsl:attribute>
      <xsl:apply-templates></xsl:apply-templates>
    </span>
    <xsl:text></xsl:text>
  </xsl:template>
  <xsl:template name="bk">
    <xsl:param name="element"></xsl:param>
    <xsl:if test="./@ana='#bk_entry' or ./@ana='#bk_total'">
      <xsl:attribute name="data-uri" select="concat('http://gams.uni-graz.at/archive/get/',$pid,'/sdef:TEI/get#',@xml:id)"></xsl:attribute>
      <xsl:attribute name="data-account">
        <xsl:for-each select="ancestor-or-self::node()[name()='div' or name()='list']/tokenize(@ana,' ')">
          <xsl:variable name="ana-token">
            <xsl:value-of select="substring-after(translate(string(.),':','_'),'#')"></xsl:value-of>
          </xsl:variable>
          <xsl:if test="$accounts//tei:category[@xml:id/string() = $ana-token]">
            <xsl:text>/</xsl:text>
            <xsl:value-of select="$ana-token"></xsl:value-of>
          </xsl:if>
        </xsl:for-each>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="./@ana='#bk_total' or ./@ana='#bk_balance'">
      <xsl:attribute name="data-corresp" select="@corresp"></xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="bk-attributes" select=".//tei:*[@ana='#bk_amount']"></xsl:apply-templates>
  </xsl:template>
  <xsl:template name="account">
    <xsl:param name="accountID"></xsl:param>
    <xsl:param name="URI" select="0"></xsl:param>
    <xsl:if test="$accounts//tei:category[@xml:id/string() = $accountID]">
      <xsl:choose>
        <xsl:when test="$URI!=0">
          <xsl:value-of select="concat($xmlBaseAccounts,.)"></xsl:value-of>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."></xsl:value-of>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tei:*[@ana='#bk_amount']">
    <xsl:if test="@rend='rbms'">
      <xsl:text> -   -   -   -   -   -   - </xsl:text>
    </xsl:if>
    <span class="amount">
      <xsl:apply-templates></xsl:apply-templates>
    </span>
  </xsl:template>
  <xsl:template match="tei:*[@ana='#bk_amount']" mode="bk-attributes">
    <xsl:variable name="data_as">
      <xsl:value-of select="ancestor-or-self::node()[@ana='#bk_d' or @ana='#bk_i'][1]/@ana"></xsl:value-of>
    </xsl:variable>
    <xsl:attribute name="data-amount">
      <xsl:if test="$data_as = '#bk_d'">
        <xsl:text>-</xsl:text>
      </xsl:if>
      <xsl:call-template name="betrag"></xsl:call-template>
    </xsl:attribute>
    <xsl:attribute name="data-unit">d.</xsl:attribute>
  </xsl:template>
  <xsl:template match="tei:ex">
    <span class="edition invisible">
      <xsl:apply-templates></xsl:apply-templates>
    </span>
    <span class="diplomatic visible abbr">
      <xsl:apply-templates></xsl:apply-templates>
    </span>
  </xsl:template>
  <xsl:template match="tei:c[@type='long-s']">
    <span class="diplomatic visible">ſ</span>
    <span class="edition invisible">s</span>
  </xsl:template>
  <xsl:template name="betrag">
    <xsl:choose>
      <xsl:when test="(not(./@quantity) or ./@quantity = 0)">
        <xsl:value-of select="format-number(sum(bk:umrechnung(./tei:num/@value,./@unit)) + sum(sum(.//tei:measure[./@type='currency']/bk:umrechnung(tei:num/@value,@unit))) + sum(.//tei:measure[./@type='currency' and ./@quantity]/bk:umrechnung(@quantity, @unit)) + sum(.//tei:measure[not(@quantity or tei:num) and string(number(substring-before(text()[1],' '))) != 'NaN']/bk:umrechnung(number(substring-before(text()[1],' ')), ./@unit)) ,'#')"></xsl:value-of>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number(bk:umrechnung(./@quantity, ./@unit),'#')"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:desc>
      <xd:b>ToDo</xd:b>: Die Indexeinträge müssen in der Edition wenigstens als Sprungmarken
      sichtbar sein.</xd:desc>
  </xd:doc>
  <xsl:template match="tei:index"></xsl:template>
  <xsl:template name="bk_is_account">
    <xsl:param name="accounts"></xsl:param>
    <xsl:copy-of select="$accounts"></xsl:copy-of>
  </xsl:template>
  <xsl:template name="currency">
    <xsl:param name="name"></xsl:param>
    <xsl:choose>
      <xsl:when test="$name='lib.d.'">240</xsl:when>
      <xsl:when test="$name='sol.d.'">8</xsl:when>
      <xsl:when test="$name='d.'">1</xsl:when>
      <xsl:when test="$name='gul'">288</xsl:when>
      <xsl:when test="$name='legr'">12</xsl:when>
      <xsl:when test="$name='gr'">12</xsl:when>
      <xsl:when test="$name='lew'">1</xsl:when>
      <xsl:when test="$name='lb'">240</xsl:when>
      <xsl:when test="$name='d'">1</xsl:when>
      <xsl:when test="$name='lb_amb'">120</xsl:when>
      <xsl:when test="$name='d_amb'">0.5</xsl:when>
      <xsl:when test="$name='ß_d'">8</xsl:when>
      <xsl:when test="$name='lb_d'">240</xsl:when>
      <xsl:when test="$name='ß'">8</xsl:when>
      <xsl:when test="$name='ß-w'">12</xsl:when>
      <xsl:when test="$name='d_Rat'">1</xsl:when>
      <xsl:when test="$name='lb_Rat'">240</xsl:when>
      <xsl:when test="$name='ß_rat_d'">8</xsl:when>
      <xsl:when test="$name='ß_rat'">8</xsl:when>
      <xsl:when test="$name='lb_Rat_d'">240</xsl:when>
      <xsl:when test="$name='ß_amb'">4</xsl:when>
      <xsl:when test="$name='fl'">120</xsl:when>
      <xsl:when test="$name='fl_rheinisch'">58</xsl:when>
      <xsl:when test="$name='fl_ungarisch'">120</xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="striche">
    <xsl:param name="level-max"></xsl:param>
    <xsl:param name="level-curr"></xsl:param>
    <xsl:if test="$level-curr &lt; $level-max">
      <xsl:text>- </xsl:text>
      <xsl:call-template name="striche">
        <xsl:with-param name="level-max" select="$level-max"></xsl:with-param>
        <xsl:with-param name="level-curr" select="$level-curr + 1"></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>
  <xsl:template match="tei:*[@ana='#bk_amount']" mode="tab-reduce">
    <xsl:variable name="data_as">
      <xsl:if test="ancestor-or-self::node()[@ana='#bk_d' or @ana='#bk_i'][1]/@ana = '#bk_d'">
        <xsl:text>-</xsl:text>
      </xsl:if>
    </xsl:variable>
    <xsl:variable name="amount">
      <xsl:call-template name="betrag"></xsl:call-template>
    </xsl:variable>
    <xsl:value-of select="bk:reduce(number($amount), $data_as)"></xsl:value-of>
  </xsl:template>
  <xd:doc>
    <xd:desc>
      <xd:p>
        <xd:b>bk:fragment()</xd:b> extrahiert die Struktur und die Inhalte zwischen zwei Elementen.<xd:lb></xd:lb>
      Die Struktur besteht aus den beiden Elementen gemeinsamen übergeordneten XML-Struktur incl. Fragementen am Anfang und am Ende.</xd:p>
    </xd:desc>
    <xd:param>from: start element</xd:param>
    <xd:param>to: end element</xd:param>
    <xd:param>where: root element of the evaluation</xd:param>
    <xd:return>tei structure starting at the $where-parameter of two elements and the content between these two elements</xd:return>
  </xd:doc>
  <xsl:function name="bk:fragment">
    <xsl:param name="from"></xsl:param>
    <xsl:param name="to"></xsl:param>
    <xsl:param name="where"></xsl:param>
    <xsl:variable name="following" select="$from/following::*[.. = $where]|$from/following::text()[.. = $where]"></xsl:variable>
    <xsl:variable name="preceding" select="$to/preceding::*[.. = $where]|$to/preceding::text()[.. = $where]"></xsl:variable>
    <xsl:variable name="between" select="$preceding intersect $following"></xsl:variable>
    <xsl:element name="{$where/name()}" namespace="{namespace-uri($where)}">
      <xsl:copy-of select="$where/@*"></xsl:copy-of>
      <xsl:if test="$where/node()[.//node()/@xml:id=$from/@xml:id]">
        <xsl:copy-of select="bk:fragment($from, $to, $where/node()[.//node()=$from])"></xsl:copy-of>
      </xsl:if>
      <xsl:for-each select="$between">
        <xsl:copy-of select="."></xsl:copy-of>
      </xsl:for-each>
      <xsl:if test="$where/node()[.//node()/@xml:id=$to/@xml:id]">
        <xsl:copy-of select="bk:fragment($from, $to, $where/node()[.//node()=$to])"></xsl:copy-of>
      </xsl:if>
    </xsl:element>
  </xsl:function>
</xsl:stylesheet>
