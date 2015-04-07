<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:rm="org.emile.roman.Roman" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="#default bk tei xd" version="2.0">
  <xsl:import href="http://gams.uni-graz.at/archive/objects/cirilo:srbas/datastreams/STYLESHEET.MAIN/content"></xsl:import>
  <xsl:import href="http://gams.uni-graz.at/rem/tab_debug.xsl"></xsl:import>
  <xsl:import href="http://gams.uni-graz.at/rem/tab.xsl"></xsl:import>
  <xsl:import href="http://gams.uni-graz.at/archive/objects/cirilo:srbas/datastreams/STYLESHEET.CONVERSIONS/content"></xsl:import>
  <xsl:param name="context"></xsl:param>
  <xsl:param name="mode"></xsl:param>
  <xsl:param name="locale"></xsl:param>
  <xsl:variable name="pid" select="replace(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID']/text(),'info:fedora/','')"></xsl:variable>
  <xsl:template name="content">
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js" type="text/javascript">/* test */</script>
    <script src="http://gams.uni-graz.at/rem/bookkeeping.js" type="text/javascript">/* test */</script>
    <script src="http://gams.uni-graz.at/rem/navigation.js" type="text/javascript">/* test*/</script>
    <div class="ym-wrapper">
      <div class="ym-wbox">
        <div class="ym-gbox nwbox">
          <a name="top"></a>
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
    </div>
  </xsl:template>
  <xsl:variable name="accounts" select="//tei:taxonomy[@ana='#bk_account']"></xsl:variable>
  <xsl:variable name="xmlBaseAccounts" select="//tei:classDecl[.//tei:taxonomy/@ana='#bk_account']/@xml:base"></xsl:variable>
  <xsl:template match="tei:TEI">
    <div class="ym-column">
      <div class="ym-col1" id="Navigation" style="display:none">
        <div class="ym-cbox">
          <h2>Inhalt</h2>
          <ul>
            <xsl:apply-templates mode="toc" select="//tei:div[@xml:id and ./tei:head]|//tei:list[@xml:id and ./tei:head]"></xsl:apply-templates>
          </ul>
        </div>
      </div>
      <div class="ym-col3" id="main">
        <div class="ym-cbox">
          <h1>
            <xsl:value-of select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"></xsl:value-of>
          </h1>
          <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:p"></xsl:apply-templates>
          <xsl:apply-templates select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt//tei:p"></xsl:apply-templates>
          <xsl:choose>
            <xsl:when test="$mode='debugging'">
              <xsl:apply-templates mode="d" select="//tei:body"></xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="//tei:body"></xsl:apply-templates>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <div class="appendix" id="back">
          <div id="apparatus">
            <xsl:apply-templates mode="end" select="//tei:body//tei:app/tei:rdg|//tei:body//tei:add|//tei:body//tei:del|//tei:body//tei:space|//tei:body//tei:sic|//tei:body//tei:supplied|//tei:body//tei:unclear|//tei:body//tei:gap|//tei:body//tei:choice|//tei:body//tei:damage"></xsl:apply-templates>
          </div>
          <div id="notes">
            <xsl:apply-templates mode="end" select="//tei:note"></xsl:apply-templates>
            <xsl:apply-templates select="//tei:back"></xsl:apply-templates>
          </div>
        </div>
      </div>
      <div class="ym-col2" id="calc" style="display:none">
        <div class="ym-cbox">
          <p>
            <a href="http://gams.uni-graz.at/archive/objects/{$pid}/datastreams/TEI_SOURCE/content" target="_blank">
              <img src="http://gams.uni-graz.at/reko/img/tei_icon.gif"></img> Quelldaten</a>
          </p>
          <form method="get">
            <xsl:attribute name="action">
              <xsl:value-of select="concat('/archive/get/',$pid,'/sdef:TEI/get')"></xsl:value-of>
            </xsl:attribute>
            <p>
              <input name="context" size="20" type="text" value="{$context}"></input>
              <input type="submit" value="Suchen"></input>
              <br></br>
              <a href="#hit">Treffer</a>
            </p>
          </form>
          <h2>
            <a href="javascript:diplomatic()" id="AnsichtUmschalter">Editionsansicht</a>
          </h2>
          <h2>
            <a href="http://gams.uni-graz.at/archive/objects/{$pid}/methods/sdef:TEI/get?mode=tab">tabellarische Ansicht</a>
          </h2>
          <h2>Beträge</h2>
          <p>
            <a href="http://gams.uni-graz.at/archive/objects/{$pid}/datastreams/RDF/content">RDF/XML</a>
          </p>
          <div id="calculations">
            <xsl:text></xsl:text>
          </div>
        </div>
      </div>
    </div>
    <script type="text/javascript">
                summieren();
            </script>
  </xsl:template>
  <xsl:template match="tei:body">
    <xsl:apply-templates></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="tei:metamark"></xsl:template>
  <xsl:template match="text()">
    <xsl:choose>
      <xsl:when test="$context">
        <xsl:call-template name="bk:highlighter"></xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template name="bk:highlighter">
    <xsl:analyze-string regex="{$context}" select=".">
      <xsl:matching-substring>
        <span class="highlight" id="hit" name="hit">
          <a class="hitprev" href="#hit">[&lt;]</a>
          <xsl:value-of select="."></xsl:value-of>
        </span>
        <a class="hitnext" href="#">[&gt;]</a>
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
  <xsl:template match="tei:div">
    <div>
      <xsl:if test="substring-before(./@ana,'_') = '#bk'">
        <xsl:attribute name="data-type">
          <xsl:value-of select="./@ana"></xsl:value-of>
        </xsl:attribute>
        <xsl:call-template name="bk">
          <xsl:with-param name="element" select="."></xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select="@xml:id"></xsl:apply-templates>
      <xsl:apply-templates select="@n"></xsl:apply-templates>
      <xsl:apply-templates></xsl:apply-templates>
    </div>
  </xsl:template>
  <xsl:template match="@n">
    <a name="{.}"></a>
  </xsl:template>
  <xsl:template match="tei:list">
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="@xml:id">
          <xsl:apply-templates select="@xml:id"></xsl:apply-templates>
        </xsl:when>
        <xsl:when test="tei:head">
          <a>
            <xsl:attribute name="name">heading_<xsl:value-of select="translate(tei:head,' -+#?&amp;;.,!:()/Â§$%=`Â´\}][{*~|','')"></xsl:value-of>
            </xsl:attribute>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="name">
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
  <xsl:template match="tei:div|tei:list" mode="toc">
    <xsl:variable name="id">
      <xsl:choose>
        <xsl:when test="@xml:id">
          <xsl:value-of select="@xml:id"></xsl:value-of>
        </xsl:when>
        <xsl:when test="tei:head">heading_<xsl:value-of select="translate(tei:head,' -+#?&amp;;.,!:()/Â§$%=`Â´\}][{*~|','')"></xsl:value-of>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id(.)"></xsl:value-of>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <li>
      <a href="#{$id}">
        <xsl:if test="$context and matches(.,$context)">
          <xsl:attribute name="class">highlight</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="./tei:head"></xsl:value-of>
      </a>
    </li>
  </xsl:template>
  <xsl:template match="tei:head">
    <xsl:variable name="tiefe" select="concat('h',count(./ancestor-or-self::node()[name()='div' or name()='list']) - (if (count(./ancestor-or-self::node()[name()='div' or name()='list']) lt 3) then 0 else 2))"></xsl:variable>
    <xsl:element name="{$tiefe}">
      <xsl:apply-templates></xsl:apply-templates>
    </xsl:element>
  </xsl:template>
  <xsl:template match="tei:lb">
    <xsl:if test="@break='no'">-</xsl:if>
    <br class="diplomatic visible"></br>
  </xsl:template>
  <xsl:template match="tei:p|tei:fw|tei:closer">
    <a>
      <xsl:attribute name="name" select="./@xml:id"></xsl:attribute>
    </a>
    <p>
      <xsl:if test="matches(@ana,'#bk_')">
        <xsl:attribute name="class">entry</xsl:attribute>
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
            <xsl:text>&#x2514;&#x2500;&#x2500;&#x25b7;</xsl:text>
          </span>
        </xsl:when>
        <xsl:when test="preceding-sibling::tei:metamark[1][contains(@rend,'Klammer')] and not(preceding-sibling::*[concat('#',@xml:id) = preceding::tei:metamark[1]/@spanTo])">
          <span title="Klammer">
            <xsl:text>&#x2502;</xsl:text>
          </span>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates></xsl:apply-templates>
    </p>
  </xsl:template>
  <xsl:template match="tei:item">
    <a>
      <xsl:attribute name="name" select="./@xml:id"></xsl:attribute>
    </a>
    <li>
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
        <xsl:text>&#x2193;</xsl:text>
      </xsl:if>
      <xsl:if test="concat('#',@xml:id) = preceding::tei:metamark[1]/@spanTo">
        <xsl:text>&#x2514;&#x2500;&#x2500;&#x2192;</xsl:text>
      </xsl:if>
      <xsl:apply-templates></xsl:apply-templates>
    </li>
  </xsl:template>
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
    <a>
      <xsl:attribute name="name" select="./@xml:id"></xsl:attribute>
    </a>
    <p class="ym-g20 folio editor">
      <a name="fol{$seitenzahl}"></a>
      <a target="_blank">
        <xsl:attribute name="href">
          <xsl:value-of select="//tei:surface[@xml:id = $facs]/tei:graphic/@url"></xsl:value-of>
        </xsl:attribute>
        <xsl:text>fol. </xsl:text>
        <xsl:value-of select="$seitenzahl"></xsl:value-of>
      </a>
    </p>
  </xsl:template>
  <xsl:template match="gb"></xsl:template>
  <xsl:template match="tei:note">
    <xsl:choose>
      <xsl:when test="ancestor::tei:body">
        <xsl:variable name="ref">
          <xsl:choose>
            <xsl:when test="@corresp">
              <xsl:value-of select="@corresp"></xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('#',generate-id())"></xsl:value-of>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <sup>
          <a>
            <xsl:attribute name="href" select="$ref"></xsl:attribute>
            <xsl:choose>
              <xsl:when test="@n">
                <xsl:value-of select="@n"></xsl:value-of>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="count(preceding::tei:note) + 1"></xsl:value-of>
              </xsl:otherwise>
            </xsl:choose>
          </a>
        </sup>
      </xsl:when>
      <xsl:otherwise>
        <p class="footnote">
          <xsl:apply-templates select="@xml:id"></xsl:apply-templates>
          <span class="footnote_3">
            <xsl:value-of select="count(./preceding::tei:note) + 1"></xsl:value-of>)
                        
            
          </span>
          <xsl:apply-templates></xsl:apply-templates>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="tei:note" mode="end">
    <xsl:variable name="ref">
      <xsl:choose>
        <xsl:when test="@xml:id">
          <xsl:value-of select="@corresp"></xsl:value-of>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="generate-id()"></xsl:value-of>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <p class="footnote">
      <xsl:element name="a">
        <xsl:attribute name="name" select="$ref"></xsl:attribute>
      </xsl:element>
      <span class="footnote_3">
        <xsl:value-of select="count(./preceding::tei:note) + 1"></xsl:value-of>)
                
        
      </span>
      <xsl:apply-templates></xsl:apply-templates>
    </p>
  </xsl:template>
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
    <a name="{./string()}"></a>
  </xsl:template>
  <xsl:template match="@rend">
    <xsl:attribute name="class">
      <xsl:value-of select="."></xsl:value-of>
    </xsl:attribute>
  </xsl:template>
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
  <xsl:template match="choice">
    <xsl:apply-templates></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="tei:seg[@rend='super' or @rend='superscript']">
    <span class="sup">
      <xsl:apply-templates></xsl:apply-templates>
    </span>
  </xsl:template>
  <xsl:template match="tei:gap">
    <xsl:variable name="id" select="generate-id(.)"></xsl:variable>
    <xsl:text>[...]</xsl:text>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}">
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:add|tei:del|tei:sic|tei:space|tei:unclear|tei:corr|tei:damage">
    <xsl:variable name="id" select="generate-id(.)"></xsl:variable>
    <xsl:apply-templates></xsl:apply-templates>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}">
      <xsl:attribute name="title">
        <xsl:value-of select="concat(name(.), ' ', ./@reason, ' ', @extent)"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:supplied">
    <xsl:variable name="id" select="generate-id(.)"></xsl:variable>
    <xsl:text>[</xsl:text>
    <xsl:apply-templates></xsl:apply-templates>
    <xsl:text>]</xsl:text>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}">
      <xsl:attribute name="title">
        <xsl:value-of select="concat(name(.), ' ', ./@reason, ' ', @extent)"></xsl:value-of>
      </xsl:attribute>
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:rdg">
    <xsl:variable name="id" select="generate-id(.)"></xsl:variable>
    <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
    <a class="footnote_reference" href="{concat('#',$id)}">
      <xsl:value-of select="$n"></xsl:value-of>
    </a>
  </xsl:template>
  <xsl:template match="tei:add|tei:del|tei:space|tei:sic|tei:supplied|tei:unclear|tei:gap|tei:corr|tei:choice/tei:orig|tei:choice/tei:reg|tei:damage" mode="end">
    <p class="note">
      <xsl:variable name="id" select="generate-id(.)"></xsl:variable>
      <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
      <a class="footnote_number" name="{$id}">
        <xsl:value-of select="$n"></xsl:value-of>) </a>
      <xsl:value-of select="concat(name(.), ' ', ./@reason, ' ', @extent)"></xsl:value-of>
      <xsl:if test="@hand">von <xsl:value-of select="@hand"></xsl:value-of> Hand</xsl:if>
      <xsl:choose>
        <xsl:when test="name(.) = 'del'">
          <xsl:apply-templates></xsl:apply-templates>
        </xsl:when>
      </xsl:choose>
      <xsl:apply-templates select="@wit"></xsl:apply-templates>
    </p>
  </xsl:template>
  <xsl:template match="tei:app/tei:rdg" mode="end">
    <p class="note">
      <xsl:variable name="id" select="generate-id(.)"></xsl:variable>
      <xsl:variable name="n" select="bk:textcriticalnote(.)"></xsl:variable>
      <a class="footnote_number" name="{$id}">
        <xsl:value-of select="$n"></xsl:value-of>
      </a>) <xsl:apply-templates></xsl:apply-templates>
      <xsl:apply-templates select="@wit"></xsl:apply-templates>
    </p>
  </xsl:template>
  <xsl:template match="tei:ref">
    <a href="{@target}">
      <xsl:apply-templates></xsl:apply-templates>
    </a>
  </xsl:template>
  <xsl:template match="tei:choice">
    <xsl:apply-templates select="tei:corr|tei:sic"></xsl:apply-templates>
  </xsl:template>
  <xsl:template match="tei:choice" mode="end">
    <xsl:apply-templates select="tei:orig|tei:reg"></xsl:apply-templates>
  </xsl:template>
  <xsl:function name="bk:textcriticalnote">
    <xsl:param name="element"></xsl:param>
    <xsl:value-of select="bk:alphanumerisch(count($element/preceding::tei:app|$element/preceding::tei:add|$element/preceding::tei:del|$element/preceding::tei:space|$element/preceding::tei:sic|$element/preceding::tei:supplied|$element/preceding::tei:unclear|$element/preceding::tei:gap|$element/ancestor::tei:choice|$element/preceding::tei:gap|$element/ancestor::tei:choice|$element/ancestor::tei:add|$element/ancestor::tei:del|$element/ancestor::tei:space|$element/ancestor::tei:sic|$element/ancestor::tei:supplied|$element/ancestor::tei:unclear|$element/ancestor::tei:gap))"></xsl:value-of>
  </xsl:function>
  <xsl:template match="@wit">
    <xsl:text></xsl:text>
    <span class="editor">
      <xsl:value-of select="."></xsl:value-of>
    </span>
  </xsl:template>
  <xsl:function name="bk:alphanumerisch">
    <xsl:param name="number"></xsl:param>
    <xsl:value-of select="codepoints-to-string(97+$number)"></xsl:value-of>
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
      <xsl:text> - &#x0020; - &#x0020; - &#x0020; - &#x0020; - &#x0020; - &#x0020; - </xsl:text>
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
    <span class="diplomatic visible">Å¿</span>
    <span class="edition invisible">s</span>
  </xsl:template>
  <xsl:template name="betrag">
    <xsl:choose>
      <xsl:when test="(not(./@quantity) or ./@quantity = 0)">
        <xsl:value-of select="sum(bk:umrechnung(./tei:num/@value,./@unit))                     + sum(sum(.//tei:measure[./@type='currency']/bk:umrechnung(tei:num/@value,@unit)))                     +     sum(.//tei:measure[./@type='currency' and ./@quantity]/bk:umrechnung(@quantity, @unit))                     +  sum(.//tei:measure[not(@quantity or tei:num) and string(number(substring-before(text()[1],' '))) != 'NaN']/bk:umrechnung(number(substring-before(text()[1],' ')), ./@unit))                     "></xsl:value-of>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="bk:umrechnung(./@quantity, ./@unit)"></xsl:value-of>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xd:doc>
    <xd:desc>
      <xd:b>ToDo</xd:b>: Die Indexeinträge müssen in der Edition wenigstens als Sprungmarken sichtbar sein.</xd:desc>
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
</xsl:stylesheet>
