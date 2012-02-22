<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:layout="/xFire/layout"
			xmlns:i18n="/xFire/i18n"
			exclude-result-prefixes="xs xdmp layout i18n"
			extension-element-prefixes="xdmp layout">
	<xdmp:import-module href="/lib/layout.xqy" namespace="/xFire/layout"/>
	<xdmp:import-module href="/lib/i18n.xqy" namespace="/xFire/i18n"/>
	<xsl:param name="yield-map" />
	<xsl:template name="xfire">
		<xsl:param name="content"/>
		<xsl:value-of select="layout:yield-map($yield-map)" />
		<xsl:value-of select="$content//layout:content-for/(layout:content-for(string(./@area), ./node()))" />
		<xsl:apply-templates select='$content/node()' />
	</xsl:template>
	<xsl:template match="layout:layout">
		<xsl:value-of select="layout:layout(string(./@path))" />
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="layout:content-for">
	</xsl:template>
	<xsl:template match="layout:yield">
		<xsl:choose>
			<xsl:when test="exists(./@area)">
				<xsl:copy-of select="layout:yield(string(./@area))" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="layout:yield()" />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>	
	</xsl:template>	
</xsl:stylesheet>