<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:layout="/xFire/layout"
			exclude-result-prefixes="xs xdmp layout"
			extension-element-prefixes="xdmp">
	<xsl:include href="/lib/xview_transform.xsl"/>
	<xsl:output method="text" />
	<xsl:template match="/response">
		<xsl:call-template name="xfire">
			<xsl:with-param name="content">
				<layout:layout path='none' />
				<xsl:value-of select="xdmp:set-response-code(number(code),string(message))" />
		{
			code: <xsl:value-of select="code" />,
			message: '<xsl:value-of select="message" />'
		}
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>