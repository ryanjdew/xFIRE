<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:xfire-layout="/xFire/layout"
			xmlns:i18n="/xFire/i18n"
			exclude-result-prefixes="xs xdmp xfire-layout"
			extension-element-prefixes="xdmp xfire-layout">
	<xdmp:import-module href="/lib/layout.xqy" namespace="/xFire/layout"/>
	<xdmp:import-module href="/lib/i18n.xqy" namespace="/xFire/i18n"/>
	<xsl:param name="locale"/>
	<xsl:param name="year"/>
	<xsl:template match="/">
		<xsl:value-of select="xfire-layout:content-for('title', concat(i18n:i18n-bundle-entry($locale, 'general', 'articles-page-title'),' ', $year))" />
		<xsl:copy-of select="xfire-layout:render-partial('/resource/views/partials/article-stub', article)" />
	</xsl:template>
</xsl:stylesheet>