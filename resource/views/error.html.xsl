<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:xfire-layout="/xFire/layout"
			exclude-result-prefixes="xs xdmp xfire-layout"
			extension-element-prefixes="xdmp xfire-layout">
	<xdmp:import-module href="/lib/layout.xqy" namespace="/xFire/layout"/>

	<xsl:template match="/response">
		<xsl:value-of select="xfire-layout:content-for('title', code/node())" />
		<div>
			<xsl:copy-of select="message/node()" />
		</div>
	</xsl:template>
</xsl:stylesheet>