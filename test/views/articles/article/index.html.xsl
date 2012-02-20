<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:layout="/xFire/layout"
			exclude-result-prefixes="xs xdmp"
			extension-element-prefixes="xdmp">
	<xsl:template match="/article">
		<layout:layout path='/test/views/layouts/application' />
		<layout:content-for area="title">
			<xsl:copy-of select="title/node()" />
		</layout:content-for>
		<div>
			<xsl:copy-of select="body/node()" />
		</div>
	</xsl:template>
</xsl:stylesheet>