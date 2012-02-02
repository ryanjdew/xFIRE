<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:layout="/xFire/layout"
			exclude-result-prefixes="xs xdmp layout"
			extension-element-prefixes="xdmp layout">
	<xdmp:import-module href="/lib/layout.xqy" namespace="/xFire/layout"/>
	<xsl:param name="yield-map"/>
	<xsl:output method="text" />
	<xsl:template match="/response">
		<xsl:value-of select="layout:yield-map($yield-map)" />
		<xsl:value-of select="layout:layout('none')" />
		<xsl:value-of select="xdmp:set-response-code(number(code),string(message))" />
		{
			code: <xsl:value-of select="code" />,
			message: '<xsl:value-of select="message" />'
		}
	</xsl:template>
</xsl:stylesheet>