<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xdmp="http://marklogic.com/xdmp"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xfire-layout="/xFire/layout"
		exclude-result-prefixes="xs xdmp xfire-layout"
		extension-element-prefixes="xdmp xfire-layout">
	<xsl:output method="html" />
	<xdmp:import-module href="/lib/layout.xqy" namespace="/xFire/layout"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:copy-of select="xfire-layout:yield('title')" />
				</title>
			</head>
			<body>
				<xsl:copy-of select="xfire-layout:yield()" />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>