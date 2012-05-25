<xsl:stylesheet version="2.0"
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:layout="/xFire/layout"
			exclude-result-prefixes="xs xdmp layout"
			extension-element-prefixes="xdmp">
	<xsl:include href="/lib/xview_transform.xsl"/>
	<xsl:output method="html"/>
	<xsl:template match="/">
		<xsl:call-template name="xfire">
			<xsl:with-param name="content">
				<html>
					<head>
						<title>
							<layout:yield area="title" />
						</title>
					</head>
					<body>
						<layout:yield />
						<layout:content-exists-for area="right-sash">
							<div class="right-sash">
								<layout:yield area="right-sash"/>
							</div>
						</layout:content-exists-for>
					</body>
				</html>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>