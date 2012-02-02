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
	<xsl:output method="text" />
	<xsl:template match="/">
		<xsl:variable name="last" select="article[last()]"/>
		<xsl:value-of select="layout:yield-map($yield-map)" />
		<xsl:for-each select="article">
		{	title: '<xsl:value-of select="title/node()" />',
			href: '<xsl:value-of select="concat(string(@uri),'?locale=',$locale)" />',
			teaser: '<xsl:value-of select="string-join(subsequence(tokenize(string(body),'/s+'),1,75) ,' ')" />'
		}
		<xsl:if test="not(. is $last)">
			,
		</xsl:if>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>