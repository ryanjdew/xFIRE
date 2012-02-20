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
	<xsl:template match="/">
		<xsl:value-of select="layout:yield-map($yield-map)" />
		<xsl:value-of select="//layout:content-for/(layout:content-for(string(./@area), ./node()))" />
		<xsl:apply-templates select='./node()' />
	</xsl:template>
	<xsl:template match="layout:layout">
			<xsl:value-of select="layout:yield(string(./@path))" />
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="layout:content-for">
	</xsl:template>
	<xsl:template match="layout:yield">
		<xsl:choose>
			<xsl:when test="exists(./@area)">
				<xsl:value-of select="layout:yield(string(./@area))" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="layout:yield()" />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates />
	</xsl:template>
	<xsl:template match="*">
		<xsl:element name="{name(.)}">
			<xsl:apply-templates select="./node()" />
		</xsl:element>		
	</xsl:template>	
	<xsl:template match="@*">
		<xsl:copy-of select="." />		
	</xsl:template>	
</xsl:stylesheet>