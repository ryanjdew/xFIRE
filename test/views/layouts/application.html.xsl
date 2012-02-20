<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xdmp="http://marklogic.com/xdmp"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:layout="/xFire/layout"
		exclude-result-prefixes="xs xdmp"
		extension-element-prefixes="xdmp layout">
	<xsl:output method="html" />
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<layout:yield area="title" />
				</title>
			</head>
			<body>
				<layout:yield />
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>