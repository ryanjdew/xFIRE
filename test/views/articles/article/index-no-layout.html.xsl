<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:layout="/xFire/layout"
			exclude-result-prefixes="xs xdmp layout"
			extension-element-prefixes="xdmp">
	<xsl:include href="/lib/xview_transform.xsl"/>
	<xdmp:import-module href="/lib/layout.xqy" namespace="/xFire/layout"/>
	<xsl:template match="/article">
		<xsl:call-template name="xfire">
			<xsl:with-param name="content">
				<layout:layout path='none' />
				<layout:content-for area='title'>
					<xsl:copy-of select="title/node()" />
				</layout:content-for>
				<div>
					<xsl:copy-of select="body/node()" />
				</div>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>