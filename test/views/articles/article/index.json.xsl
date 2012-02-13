<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:layout="/xFire/layout"
			xmlns:i18n="/xFire/i18n"
			exclude-result-prefixes="xs xdmp layout"
			extension-element-prefixes="xdmp layout">
	<xdmp:import-module href="/lib/layout.xqy" namespace="/xFire/layout"/>
	<xdmp:import-module href="/lib/i18n.xqy" namespace="/xFire/i18n"/>
	<xsl:param name="yield-map" />
	<xsl:output method="text" />
	<xsl:template match="/article">
		<xsl:value-of select="layout:yield-map($yield-map)" />
		<xsl:value-of select="layout:layout('none')" />
		{ 
			title :'<xsl:value-of select=" title/node()" />',
			body : '<xsl:apply-templates select="body/node()" />'
		}
	</xsl:template>
	<xsl:template match="text()">
		<xsl:value-of select="." />
	</xsl:template>
	<xsl:template match="*">
		<xsl:value-of select="xdmp:quote(.)" />
	</xsl:template>
</xsl:stylesheet>