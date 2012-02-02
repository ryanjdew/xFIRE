<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:layout="/xFire/layout"
			exclude-result-prefixes="xs xdmp layout"
			extension-element-prefixes="xdmp layout">
	<xdmp:import-module href="/lib/layout.xqy" namespace="/xFire/layout"/>
	<xsl:param name="yield-map"/>
	<xsl:param name="locale" select="xdmp:get-request-field('locale', 'eng')"/>
	<xsl:template match="/">
		<xsl:value-of select="layout:yield-map($yield-map)" />
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="article">
		<div class="article">
			<h2><a><xsl:attribute name="href">
						<xsl:value-of select="concat(string(@uri),'?locale=',$locale)" />
					</xsl:attribute>
					<xsl:value-of select="title/node()" />
			</a></h2>
			<p><xsl:copy-of select="string-join(subsequence(tokenize(string(body),'/s+'),1,75) ,' ')" /></p>
		</div>
	</xsl:template>	
</xsl:stylesheet>