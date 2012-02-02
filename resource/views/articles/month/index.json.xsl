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
	<xsl:param name="yield-map" />
	<xsl:param name="year"/>
	<xsl:param name="month"/>
	<xsl:output method="text" />
	<xsl:template match="/">
		<xsl:value-of select="layout:yield-map($yield-map)" />
		<xsl:value-of select="layout:layout('none')" />
		{ 	
			year: '<xsl:value-of select="$year" />',
			month: '<xsl:value-of select="$month" />',
			monthText: '<xsl:value-of select="i18n:i18n-bundle-entry($locale, 'general', concat('month-',$month))" />',
			articles :[
				<xsl:copy-of select="layout:render-partial('/resource/views/partials/article-stub', article)" />
			]
		}
	</xsl:template>
</xsl:stylesheet>