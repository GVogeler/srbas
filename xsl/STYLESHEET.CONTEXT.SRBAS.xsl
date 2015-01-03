<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:rm="org.emile.roman.Roman" xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#default bk t" version="2.0">
    <xsl:import href="/archive/objects/cirilo:srbas/datastreams/STYLESHEET.MAIN/content" />
    <xsl:param name="context" />
    <xsl:param name="mode" />
    <xsl:variable name="pid" select="replace(/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno[@type='PID']/text(),'info:fedora/','')" />
    <xsl:template name="content">
        <div class="ym-wrapper">
            <div class="ym-wbox">
                <xsl:choose>
                    <xsl:when test="not($mode)">
                        <div class="ym-gbox nwbox">
                            <h3>Edition der Rechnungen der Stadt Basel</h3>
                            <p>... Einführungstext ...</p>
                            <ul>
                                <li>
                                    <a href="?mode=chrono">Chronologische Liste der Rechnungen</a>
                                </li>
                                <li>
                                    <a href="/archive/objects/query:srbas.accounts/methods/sdef:Query/get?params=$1|%3Chttp://gams.uni-graz.at/rem/%23toplevel%3E">Nach Konten aufgegliedert</a>
                                </li>
                            </ul>
                        </div>
                    </xsl:when>
                    <xsl:when test="$mode='browse'">
                        <div class="ym-gbox nwbox">
                            <h3>Anzeigen der Rechnungen als ...</h3>
                            <p>
                                <xsl:value-of select="/s:sparql/s:results/s:result[1]/s:cid/text()" />
                            </p>
                            <ul>
                                <li>
                                    <a href="?mode=chrono">Chronologische Liste der Rechnungen</a>
                                </li>
                                <li>
                                    <a href="/archive/objects/query:srbas.accounts/methods/sdef:Query/get?params=$1|%3Chttp://gams.uni-graz.at/rem/%23toplevel%3E">Nach Konten aufgegliedert</a>
                                </li>
                                <li>
                                    <a href="/archive/objects/query:srbas.keywords.list/methods/sdef:Query/get?params=">Schlagwortregister</a>
                                </li>
                            </ul>
                        </div>
                    </xsl:when>
                    <xsl:when test="$mode='chrono'">
                        <div class="ym-gbox nwbox">
                            <h3>Rechnungen</h3>
                            <h4>
                                <xsl:value-of select="/s:sparql/s:results/s:result[1]/s:container" />
                            </h4>
                            <ul class="resultList">
                                <xsl:for-each select="/s:sparql/s:results/s:result">
                                    <li>
                                        <xsl:choose>
                                            <xsl:when test="position() mod 2 = 0">
                                                <xsl:attribute name="class">
                                                    <xsl:text>results odd</xsl:text>
                                                </xsl:attribute>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="class">
                                                    <xsl:text>results even</xsl:text>
                                                </xsl:attribute>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:text>/archive/objects/</xsl:text>
                                                <xsl:value-of select="substring-after(s:pid/@uri, '/')" />
                                                <xsl:text>/methods/sdef:TEI/get</xsl:text>
                                            </xsl:attribute>
                                            <xsl:value-of select="s:date" />
                                            <xsl:text>: </xsl:text>
                                            <xsl:value-of select="s:title" />
                                            <xsl:text>, </xsl:text>
                                            <xsl:value-of select="s:creator" />
                                        </a>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </div>
                        <div class="ym-gbox nwbox">
                        <!-- ToDo: auf query:srbas.search generalisieren:
                        * einbauen von js/builbquery.js
                        * Suchfelder:
                        	input["Stichwort"]
							input["Suchart"] ('regex' oder 'fulltext')
							?? verknüpfung der Suchausdrücke: alle "und", alle "oder", individuell?
							input["jahrVor"], input["jahrNach"]
							input["konto"] : SELECT-Liste mit Kontoname (Kontopfad) => Konto-URI
							input["betrag"], input["betragsoperator"]
							
							input["params"].hidden
							-->
                            <h3>Suchmöglichkeiten</h3>
                            <ul>
                            <li>Stichwortsuche:<br/>
                                <form action="/archive/objects/query:srbas.fulltext/methods/sdef:Query/get" method="get" name="SucheStichwort" onsubmit="addParams(document.SucheStichwort)">
                                <input class="ym-serchfield" id="Stichwort" name="SucheStichwort" placeholder="Suche" type="search" />
                                <input name="params" type="hidden" />
                                <xsl:text />
                                <input class="ym-searchbutton" type="submit" value="Suche" />
                            </form>
                                <br/> (schnell, Rechtstrunkierung mit * möglich, Umlaute werden wie Grundbuchstabe behandelt)</li>
                                <li>Suche mit <a href="http://de.wikipedia.org/wiki/Regulärer_Ausdruck">regulären Ausdrücken</a>:<br/>
                                    <form action="/archive/objects/query:srbas.regex/methods/sdef:Query/get" method="get" name="SucheRegex" onsubmit="addParams(document.SucheRegex)">
                                        <input class="ym-serchfield" id="Stichwort" name="Stichwort" placeholder="Suche" type="search" />
                                        <input name="params" type="hidden" />
                                        <xsl:text />
                                        <input class="ym-searchbutton" type="submit" value="Suche" />
                                    </form>
                                    <br/>
                                    (langsamer, dafür sind reguläre Ausdrücke möglich: z.B. "sta[dt].?schre?ib" findet "Stadtschreiber", "statschriber", "stattschreibers", "stadeschrib" etc.)</li>
                                <li>Suche beschränken auf:<br/>
                                    <ul>
                                    <!-- 
									input["jahrVor"], input["jahrNach"]
									input["konto"] : SELECT-Liste mit Kontoname (Kontopfad) => Konto-URI
									input["betrag"], input["betragsoperator"]
									-->
                                        <li>Zeitraum: nach <input type="text" name="jahrNach"/> vor <input type="text" name="jahrVor"/></li>
                                        <li>Konto: <select name="konto">
                                        <option value="&lt;http://gams.uni-graz.at/rem/%23toplevel&gt;">Alle Konten</option><!-- option-Liste aus konten.xml = srbas.konten ? auslesen--> </select></li>
                                        <li>Betrag: <select name="betragsoperator"><option value="="/><option value="&gt;="/><option value="&lt;="/><option value="&gt;"/><option value="&lt;"/><!-- <option value="zwischen">zwischen</option><option value="ca">circa</option> --></select> <input type="text" name="betrag" /> </li>
                                    </ul></li>
                            </ul>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates />
                    </xsl:otherwise>
                </xsl:choose>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
