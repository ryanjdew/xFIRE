<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:layout="/xFire/layout"
			xmlns:i18n="/xFire/i18n"
			exclude-result-prefixes="xs xdmp layout i18n"
			extension-element-prefixes="xdmp layout">
	<xdmp:import-module href="/lib/layout.xqy" namespace="/xFire/layout"/>
	<xdmp:import-module href="/lib/i18n.xqy" namespace="/xFire/i18n"/>
	<xsl:param name="locale" select="'eng'"/>
	<xsl:param name="yield-map" />
	<xsl:template match="/">
		<xsl:value-of select="layout:yield-map($yield-map)" />
		<xsl:value-of select="layout:content-for('title', i18n:i18n-bundle-entry($locale, 'general', 'home-page-title'))" />
		<div>
			<xsl:copy-of select="i18n:i18n-bundle-entry($locale, 'general', 'home-page-body')" />
		</div>
	</xsl:template>
</xsl:stylesheet>