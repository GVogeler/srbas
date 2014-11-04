<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/" xmlns:sr="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs xd" version="2.0">
    <xsl:import href="http://gams.uni-graz.at/archive/objects/cirilo:srbas/datastreams/STYLESHEET.MAIN/content" />
    <xsl:decimal-format decimal-separator="," grouping-separator="." name="european" />
    <xsl:param name="mode" />
    <xsl:variable name="gesuchteskonto" select="distinct-values(//sr:result/sr:konto/@uri)[1]" />
    <xsl:variable name="accounts">
        <xsl:for-each select="distinct-values(//sr:result/sr:subkonto/@uri)">
            <account>
                <xsl:value-of select="." />
            </account>
        </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="pfad">
        <xsl:for-each select="tokenize(//sr:result[1]/sr:pfad[1],'/')">
            <konto>
                <xsl:value-of select="." />
            </konto>
        </xsl:for-each>
    </xsl:variable>
    <xd:doc>
        <xd:desc />
    </xd:doc>
    <xsl:template name="content">
        <script src="https://www.google.com/jsapi" type="text/javascript">&amp;nbsp;</script>
        <xsl:variable name="betraege">
            <xsl:choose>
                <xsl:when test="//sr:result[sr:subkonto/@uri=$accounts/*]">
                    <xsl:copy-of select="//sr:result[sr:subkonto/@uri=$accounts/*]" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="//sr:result[sr:konto/@uri=$accounts/*]" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <script type="text/javascript">
            google.load("visualization", "1", {packages:["corechart"]});
            function drawChart() {
            var data = google.visualization.arrayToDataTable([
            ['Jahr'<xsl:for-each select="$accounts/*">, '<xsl:value-of select="substring-after(.,'/#bs_')" />'</xsl:for-each>]
            <xsl:for-each-group group-by="sr:o/@uri" select="//sr:result[sr:subkonto/@uri=$accounts/*]">
                <xsl:sort select="sr:jahr" />
                <xsl:variable name="objekt" select="current-group()" />
                <xsl:text>,
                        ['</xsl:text>
                <xsl:value-of select="sr:jahr" />' <xsl:for-each select="$accounts/*">
                    <xsl:text>, </xsl:text>
                    <xsl:choose>
                        <xsl:when test="$objekt[sr:subkonto[@uri=current()]]/sr:subbetrag != 0 ">
                            <xsl:value-of select="$objekt[sr:subkonto[@uri=current()]]/sr:subbetrag" />
                        </xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <xsl:text>]</xsl:text>
            </xsl:for-each-group>
            ]);
            
            var options = {
            title: 'Stadtrechnungen Basel',
            hAxis: {title: 'Jahr'},
            vAxis: {title: 'Pfennige'}
            };
            
            var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
            chart.draw(data, options);
            }
        </script>
        <div id="main">
            <div xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" class="ym-wrapper">
                <div class="ym-wbox">
                    <div class="ym-gbox nwbox">
                        <h3>Zeitreihe Kontensummen zu <xsl:value-of select="$gesuchteskonto" />
                        </h3>
                        <p>
                            <a href="/archive/objects/query:srbas.accounts/methods/sdef:Query/get?params=$1|&lt;http://gams.uni-graz.at/rem/%23toplevel&gt;">Top Level</a>
                            <xsl:for-each select="tokenize(//sr:result[1]/sr:pfad[1],'/')">
                                <xsl:if test="not(.='')">
                                    <a href="./get?params=$1|&lt;http://gams.uni-graz.at/rem/%23{.}&gt;">
                                        <xsl:value-of select="." />
                                    </a>
                                </xsl:if> / 
                            </xsl:for-each>
                        </p>
                        <xsl:choose>
                            <xsl:when test="$mode='graph'">
                                <p>
                                    <a href="/archive/objects/query:srbas.accounts/methods/sdef:Query/get?params=$1|&lt;{replace($gesuchteskonto,'#','%23')}&gt;">Tabelle</a>
                                </p>
                                <script type="text/javascript">google.setOnLoadCallback(drawChart);</script>
                                <hr />
                                <div id="chart_div" style="height: 500px;" />
                            </xsl:when>
                            <xsl:otherwise>
                                <p>
                                    <a href="/archive/objects/query:srbas.accounts/methods/sdef:Query/get?mode=graph&amp;params=$1|&lt;{replace($gesuchteskonto,'#','%23')}&gt;">Graphik</a>
                                </p>
                                <hr />
                                <div id="table">
                                    <a name="table" />
                                    <table>
                                        <xsl:call-template name="head" />
                                        <xsl:for-each-group group-by="sr:subkonto/@uri" select="//sr:result">
                                            <tr>
                                                <td>
                                                    <a href="./get?&amp;mode=&amp;params=$1|&lt;{replace(current-grouping-key(),'#','%23')}&gt;">
                                                        <xsl:value-of select="substring-after(current-grouping-key(),'#')" />
                                                    </a>
                                                </td>
                                                <xsl:for-each select="current-group()">
                                                    <xsl:apply-templates select="sr:subbetrag" />
                                                </xsl:for-each>
                                            </tr>
                                        </xsl:for-each-group>
                                        <tr style="font-weight:bold">
                                            <td>Gesamt:</td>
                                            <xsl:for-each-group group-by="sr:o/@uri" select="//sr:result">
                                                <xsl:text />
                                                <td>
                                                    <xsl:value-of select="format-number(./sr:betrag,'###.###', 'european')" /> d.</td>
                                            </xsl:for-each-group>
                                        </tr>
                                    </table>
                                </div>
                            </xsl:otherwise>
                        </xsl:choose>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="sr:subbetrag">
        <td>
            <xsl:value-of select="format-number(.,'###.###', 'european')" /> d.</td>
    </xsl:template>
    <xsl:template name="head">
        <thead>
            <tr>
                <th>Konto</th>
                <xsl:for-each select="distinct-values(//sr:result/concat(sr:jahr,'----',sr:o/@uri))">
                    <th>
                        <a href="{substring-after(.,'----')}">
                            <xsl:value-of select="substring-before(.,'----')" />
                        </a>
                    </th>
                </xsl:for-each>
            </tr>
        </thead>
    </xsl:template>
</xsl:stylesheet>
