<xsl:stylesheet version="2.0"
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp">
	<xsl:param name="locale"/>
	<xsl:param name="orig-path"/>
	<xsl:template match="/">
		<cts:element-query xmlns:cts="http://marklogic.com/cts">
			<cts:element>article</cts:element>
			<cts:and-query>
				<cts:element-attribute-value-query>
					<cts:element>article</cts:element>
					<cts:attribute>locale</cts:attribute>
					<cts:text><xsl:value-of select="$locale"/></cts:text>
					<cts:option>case-sensitive</cts:option>
					<cts:option>diacritic-sensitive</cts:option>
					<cts:option>punctuation-sensitive</cts:option>
					<cts:option>whitespace-sensitive</cts:option>
					<cts:option>unstemmed</cts:option>
					<cts:option>unwildcarded</cts:option>
				</cts:element-attribute-value-query>
				<cts:element-attribute-value-query>
					<cts:element>article</cts:element>
					<cts:attribute>uri</cts:attribute>
					<cts:text><xsl:value-of select="$orig-path"/></cts:text>
					<cts:option>case-sensitive</cts:option>
					<cts:option>diacritic-sensitive</cts:option>
					<cts:option>punctuation-sensitive</cts:option>
					<cts:option>whitespace-sensitive</cts:option>
					<cts:option>unstemmed</cts:option>
					<cts:option>unwildcarded</cts:option>
				</cts:element-attribute-value-query>
			</cts:and-query>
		</cts:element-query>
	</xsl:template>
</xsl:stylesheet>