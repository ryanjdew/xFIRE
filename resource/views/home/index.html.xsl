<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:layout="/xFire/layout"
			xmlns:i18n="/xFire/i18n"
			exclude-result-prefixes="xs xdmp layout i18n"
			extension-element-prefixes="xdmp">
	<xsl:include href="/lib/xview_transform.xsl"/>
	<xdmp:import-module href="/lib/i18n.xqy" namespace="/xFire/i18n"/>
	<xsl:param name="locale" select="'eng'"/>
	<xsl:template match="/">
		<xsl:call-template name="xfire">
			<xsl:with-param name="content">
				<layout:content-for area='title'>
					<xsl:value-of select="i18n:i18n-bundle-entry($locale, 'general', 'home-page-title')" />
				</layout:content-for>
				<div>
					<xsl:copy-of select="i18n:i18n-bundle-entry($locale, 'general', 'home-page-body')" />
				</div>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>