<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml" xmlns:bk="http://gams.uni-graz.at/rem/bookkeeping/" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:rm="org.emile.roman.Roman" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#default bk tei" version="2.0">
    <xsl:import href="/archive/objects/cirilo:srbas/datastreams/STYLESHEET.MAIN/content" />
    <xsl:import href="http://gams.uni-graz.at/rem/default.xsl" />
    <xsl:import href="http://gams.uni-graz.at/rem/debug.xsl" />
    <xsl:import href="http://gams.uni-graz.at/rem/tab_debug.xsl" />
    <xsl:import href="http://gams.uni-graz.at/rem/tab.xsl" />
    
    <xsl:variable name="pid" select="replace(/tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='PID']/text(),'info:fedora/','')" />
    <xsl:template name="content">
        <div class="ym-wrapper">
            <div class="ym-wbox">
                <div class="ym-gbox nwbox">
                    <a name="top" />
                    <xsl:choose>
                        <xsl:when test="$mode='tab'">
                            <xsl:apply-templates mode="tab" />
                        </xsl:when>
                        <xsl:when test="$mode='debug'">
                            <xsl:apply-templates mode="debug" />
                        </xsl:when>
                        <xsl:when test="$mode='tab-debug'">
                            <xsl:apply-templates mode="tab-debug" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates />
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </div>
        </div>
    </xsl:template>
</xsl:stylesheet>
