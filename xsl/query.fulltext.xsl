<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/" xmlns:sr="http://www.w3.org/2001/sw/DataAccess/rf1/result" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:import href="/archive/objects/cirilo:srbas/datastreams/STYLESHEET.MAIN/content" />
    <xsl:decimal-format decimal-separator="," grouping-separator="." name="european" />
    <xsl:param name="mode" />
    <xsl:variable name="query" select="//sr:result[1]/sr:query[1]" />
    <xsl:function name="bk:d2lb">
        <xsl:param name="denarii" />
        <xsl:value-of select="format-number($denarii div 240,'###.##0,00', 'european')" />
    </xsl:function>
    <xsl:template name="content">
        <script src="https://www.google.com/jsapi" type="text/javascript">&amp;nbsp;</script>
        <div id="main">
            <div xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result" class="ym-wrapper">
                <div class="ym-wbox">
                    <div class="ym-gbox nwbox">
                        <xsl:apply-templates select="//sr:results" />
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="sr:results">
        <p>
            <xsl:value-of select="count(sr:result)" /> Treffer zur Suche "<xsl:value-of select="$query" />"</p>
        <table>
            <thead>
                <tr>
                    <td>Jahr</td>
                    <td>Konto</td>
                    <td>Text</td>
                    <td>Betrag (in lb)</td>
                </tr>
            </thead>
            <xsl:for-each-group group-by="sr:o/@uri" select="sr:result">
                <tr>
                    <td>
                        <h2>
                            <a href="{current-grouping-key()}/sdef:TEI/get?context={$query}">
                                <xsl:apply-templates select="sr:jahr" />
                            </a>
                        </h2>
                    </td>
                </tr>
                <xsl:apply-templates select="current-group()" />
            </xsl:for-each-group>
        </table>
    </xsl:template>
    <xsl:template match="sr:result">
        <xsl:variable name="signofamount">
            <xsl:if test="sr:signofamount='http://gams.uni-graz.at/rem/bookkeping/#bk_id'">-</xsl:if>
        </xsl:variable>
        <tr>
            <td>
                <xsl:apply-templates select="sr:jahr" />
            </td>
            <td>
                <a href="/archive/objects/query:srbas.accounts/methods/sdef:Query/get?params=$1|&lt;{replace(sr:konto/@uri,'#','%23')}&gt;">
                    <xsl:value-of select="substring-after(sr:konto/@uri,'/#bs_')" />
                </a>
            </td>
            <td>
                <a href="{sr:entry/@uri}">
                    <xsl:apply-templates select="sr:text" />
                </a>
            </td>
            <td class="numeric">
                <xsl:value-of select="$signofamount" />
                <xsl:value-of select="sr:betrag/bk:d2lb(text())" />
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="sr:text/text()">
        <xsl:choose>
            <xsl:when test="$query != ''">
                <xsl:analyze-string flags="i" regex="(^|\s)({$query})" select=".">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)" />
                        <span class="highlight" id="hit" name="hit">
                            <xsl:value-of select="regex-group(2)" />
                        </span>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="." />
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="." />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="sr:jahr">
        <xsl:value-of select="../sr:von"/><xsl:text>/</xsl:text><xsl:value-of select="."/>
    </xsl:template>
</xsl:stylesheet>
