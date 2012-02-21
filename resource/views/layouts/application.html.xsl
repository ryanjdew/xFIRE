<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xdmp="http://marklogic.com/xdmp"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:layout="/xFire/layout"
		exclude-result-prefixes="xs xdmp layout"
		extension-element-prefixes="xdmp layout">
	<xsl:output method="html" />
	<xdmp:import-module href="/lib/layout.xqy" namespace="/xFire/layout"/>
	<xsl:param name="yield-map"/>
	<xsl:call-template name="xfire">
		<xsl:with-param name="content">
			<xsl:template match="/">
				<xsl:value-of select="layout:yield-map($yield-map)" />
				<html>
					<head>
						<title>
							<xsl:copy-of select="layout:yield('title')" />
						</title>
					</head>
					<body>
						<xsl:copy-of select="layout:yield()" />
					</body>
				</html>
			</xsl:template>
		</xsl:with-param>
	</xsl:call-template>
</xsl:stylesheet>