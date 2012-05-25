<xsl:stylesheet version="2.0" 
			xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
			xmlns:xdmp="http://marklogic.com/xdmp"
			xmlns:map="http://marklogic.com/xdmp/map"
			xmlns:xs="http://www.w3.org/2001/XMLSchema"
			xmlns:layout="/xFire/layout"
			exclude-result-prefixes="xs xdmp map"
			extension-element-prefixes="xdmp layout"
			input-type-annotations = "strip">
	<xsl:strip-space elements="*" />
	<xsl:preserve-space elements="pre" />
	<!-- include extensions start -->
	<!-- include extensions end-->
	<xdmp:import-module href="/lib/layout.xqy" namespace="/xFire/layout"/>
	<xsl:param name="yield-map" />
	<xsl:param name="params-map" />
	<xsl:template name="xfire">
		<xsl:param name="content"/>
		<xsl:value-of select="layout:yield-map($yield-map)" />
		<xsl:value-of select="layout:params-map(map:map($params-map))" />
		<xsl:value-of select="$content//layout:content-for/(layout:content-for(string(./@area), ./node()))" />
		<xsl:apply-templates select='$content/node()' mode="xfire" />
	</xsl:template>
	<xsl:template match="layout:render-partial" mode="xfire" >
		<xsl:copy-of select="layout:render-partial(string(./@path), ./element())" />
	</xsl:template>
	<xsl:template match="layout:layout" mode="xfire" >
		<xsl:value-of select="layout:layout(string(./@path))" />
		<xsl:apply-templates mode="xfire"  />
	</xsl:template>
	<xsl:template match="layout:content-for" mode="xfire" >
	</xsl:template>
	<xsl:template match="layout:content-exists-for" mode="xfire" >
		<xsl:if test="layout:content-exists-for(string(./@area))">
			<xsl:apply-templates select="./node()" mode="xfire"  />
		</xsl:if>
	</xsl:template>
	<xsl:template match="layout:yield" mode="xfire" >
		<xsl:choose>
			<xsl:when test="exists(./@area)">
				<xsl:apply-templates select="layout:yield(string(./@area))" mode="xfire"  />
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="layout:yield()"  />
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates mode="xfire"  />
	</xsl:template>
	<xsl:template match="*" mode="xfire" >
		<xsl:element name="{node-name(.)}">
			<xsl:apply-templates select="./(attribute::node()|child::node())" mode="xfire" />
		</xsl:element>	
	</xsl:template>	
	<xsl:template match="@*" mode="xfire" >
		<xsl:copy />
	</xsl:template>
</xsl:stylesheet>