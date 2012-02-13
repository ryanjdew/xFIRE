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
	<xsl:param name="locale"/>
	<xsl:param name="year"/>
	<xsl:param name="month"/>
	<xsl:param name="yield-map"/>
	<xsl:template match="/">
		<xsl:value-of select="layout:yield-map($yield-map)" />
		<xsl:value-of select="layout:layout('/test/views/layouts/application')" />
		<xsl:value-of select="layout:content-for('title', concat(i18n:i18n-bundle-entry($locale, 'general', 'articles-page-title'),' ', $year, ' ', i18n:i18n-bundle-entry($locale, 'general', concat('month-',$month))))" />
		<xsl:copy-of select="layout:render-partial('/resource/views/partials/article-stub', article)" />
	</xsl:template>
</xsl:stylesheet>