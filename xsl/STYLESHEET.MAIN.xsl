<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:r="http://gams.uni-graz.at/rem/ns/1.0" xmlns:rm="org.emile.roman.Roman" xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="s t html" version="2.0">
    <xsl:output doctype-system="about:legacy-compat" encoding="UTF-8" indent="no" method="xml" />
    <xsl:strip-space elements="t:phr t:p" />
    <xsl:param name="mode" />
    <xsl:variable name="cid" select="/s:sparql/s:results/s:result/s:cid" />
    <xsl:variable name="mainTitle">
        <xsl:text>Rechnungen der Stadt Basel</xsl:text>
    </xsl:variable>
    <xsl:variable name="subTitle">
        <xsl:text>Alpha-Version</xsl:text>
    </xsl:variable>
    <xsl:variable name="projectCss">
        <xsl:text>/archive/objects/cirilo:srbas/datastreams/CSS/content</xsl:text>
    </xsl:variable>
    <xsl:variable name="searchXsl">
        <xsl:text>http://glossa.uni-graz.at/archive/objects/cirilo:srbas/datastreams/STYLESHEET.GSEARCH/content</xsl:text>
    </xsl:variable>
    <xsl:template match="/">
        <html lang="de">
            <head>
                <meta charset="utf-8" />
                <title>
                    <xsl:value-of select="$mainTitle" />
                </title>
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <link href="http://gams.uni-graz.at/reko/css/yaml/flexible-grids.css" rel="stylesheet" type="text/css" />
                <link href="{$projectCss}" rel="stylesheet" type="text/css" />
                <link href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.1/themes/base/jquery-ui.css" rel="stylesheet" type="text/css" />
                <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js" type="text/javascript">
                    /* test */
                </script>
                <script src="http://gams.uni-graz.at/reko/scripts/multiple.js" type="text/javascript">
                    /* test */
                </script>
                <script src="http://gams.uni-graz.at/rem/bookkeeping.js" type="text/javascript">/* test */</script>
                <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.1/jquery-ui.min.js">
                    /* test */
                </script>
                <script type="text/javascript"> 
                    $(document).ready(function(){ 
                    
                    if($('#random div').size() != 0) {
                    initializeRandomTexts();
                    window.setInterval(replaceTexts, 11000);  
                    }
                    
                    }); </script>
                <script xmlns="" xmlns:sr="http://www.w3.org/2001/sw/DataAccess/rf1/result" type="text/javascript">
                    function addParams() {
                    document.Suche.params.value="$1|" + document.Suche.Stichwort.value ;
                    document.Suche.Stichwort.setAttribute("disabled", "disabled");
                    return true;
                    }
                </script>
                <xsl:text disable-output-escaping="yes">&lt;!--[if lte IE 7]&gt;</xsl:text>
                <link href="http://gams.uni-graz.at/reko/css/yaml/core/iehacks.css" media="screen" rel="stylesheet" type="text/css" />
                <xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 9]&gt;</xsl:text>
                <script src="http://html5shim.googlecode.com/svn/trunk/html5.js">
                    <xsl:text />
                </script>
                <xsl:text disable-output-escaping="yes">&lt;![endif]--&gt;</xsl:text>
            </head>
            <body>
                <ul class="ym-skiplinks">
                    <li>
                        <a class="ym-skip" href="#nav">Skip to navigation (Press Enter)</a>
                    </li>
                    <li>
                        <a class="ym-skip" href="#main">Skip to main content (Press Enter)</a>
                    </li>
                </ul>
                <header>
                    <div class="ym-wrapper">
                        <div class="ym-wbox">
                            <div class="unilogo">
                                <a class="unilogo" href="http://www.uni-graz.at">
                                    <img alt="Karl-Franzens-Universität Graz" class="logoUni" height="62" src="http://gams.uni-graz.at/reko/img/logoUniGraz.gif" title="Karl-Franzens-Universität Graz" width="73" />
                                </a>
                            </div>
                            <h1>
                                <xsl:value-of select="$mainTitle" />
                            </h1>
                            <h2>
                                <xsl:value-of select="$subTitle" />
                            </h2>
                        </div>
                    </div>
                </header>
                <nav id="nav">
                    <div class="ym-wrapper">
                        <div class="ym-hlist">
                            <ul id="unav">
                                <li>
                                    <xsl:if test="$cid='context:srbas' and not($mode)">
                                        <xsl:attribute name="class">
                                            <xsl:text>active</xsl:text>
                                        </xsl:attribute>
                                        <strong>HOME</strong>
                                    </xsl:if>
                                    <xsl:if test="not($cid='context:srbas') or ($cid='context:srbas' and $mode)">
                                        <a href="/context:srbas"> HOME </a>
                                    </xsl:if>
                                </li>
                                <li>
                                    <xsl:if test="$cid='context:srbas-account' or $mode='chrono'">
                                        <xsl:attribute name="class">
                                            <xsl:text>active</xsl:text>
                                        </xsl:attribute>
                                    </xsl:if>
                                    <a href="/context:srbas?mode=browse">Browse</a>
                                </li>
                            </ul>
                            <form action="/archive/objects/query:srbas.fulltext/methods/sdef:Query/get" class="ym-searchform" method="get" name="Suche" onsubmit="addParams()">
                                <input class="ym-serchfield" id="Stichwort" name="Stichwort" placeholder="Suche" type="search" />
                                <input name="params" type="hidden" />
                                <xsl:text />
                                <input class="ym-searchbutton" type="submit" value="Suche" />
                            </form>
                        </div>
                    </div>
                </nav>
                <div id="main">
                    <xsl:call-template name="content" />
                </div>
                <footer>
                    <div class="ym-wrapper">
                        <div class="ym-wbox">
                            <section class="ym-grid linearize-level-1 ym-equalize">
                                <div class="ym-g50 ym-gl">
                                    <div class="ym-gbox gbox-l">
                                        <h6>Quick-Links</h6>
                                        <p>
                                            <a href="http://gams.uni-graz.at/archive/objects/context:rem/methods/sdef:Context/get?mode=imprint">Impressum</a>
                                        </p>
                                        <p>
                                            <a href="http://informationsmodellierung.uni-graz.at/">ZIM-ACDH</a>
                                        </p>
                                        <p class="logoGAMS">
                                            <a href="http://gams.uni-graz.at">
                                                <img alt="Geisteswissenschaftliches Asset Management System" class="logoGams" height="48" src="/reko/img/gamslogo_weiss.png" title="Geisteswissenschaftliches Asset Management System" width="128" />
                                            </a>
                                            <br /> Geisteswissenschaftliches Asset Management System
                                        </p>
                                    </div>
                                </div>
                                <div class="ym-g50 ym-gl">
                                    <div class="ym-gbox gbox-r">
                                        <h6>Kontakt</h6>
                                        <p>
                                            <a href="http://www.burghartz.ch/">Prof. Dr. Susanna
                                                Burghartz</a>
                                            <br />Universität Basel<br />
                                            Departement Geschichte</p>
                                    </div>
                                </div>
                            </section>
                        </div>
                    </div>
                </footer>
                <div id="multiLinkPopup" title="Überlagernde Textebenen" />
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
