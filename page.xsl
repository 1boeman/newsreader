<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xsl:output indent="yes"/>
<xsl:param name="data_path" />
<xsl:param name="conf_path" />

<xsl:variable name="menu" select="document(concat($conf_path,'/','menu.html'))/ul" />

<xsl:template name="start" match="/">
  <html>
    <title><xsl:value-of select="//title"/></title>
    <body>
      <xsl:copy-of select="$menu" />
      <xsl:apply-templates/>
    </body>
  </html>
</xsl:template>

<xsl:template match="title">
  <h1><xsl:value-of select="."/></h1>
</xsl:template>

<xsl:template match="section">
  <div class="section">
    <xsl:for-each select="./feed">
      <div class="feed">
      <xsl:apply-templates select="document(concat($data_path, replace(., '[^a-zA-Z0-9]', '_')))//item"/>
      </div>
    </xsl:for-each>
  </div>
</xsl:template>

<xsl:template match="item">
  <article class="item">
    <xsl:attribute name="data-pubDate">
      <xsl:value-of select="./pubDate" />
    </xsl:attribute>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="./link" />
      </xsl:attribute>
      <h2><xsl:value-of select="./title" /></h2>
      <p class="description">
        <xsl:value-of select="./description" />
      </p>
    </a>
  </article>
</xsl:template>
</xsl:stylesheet>

