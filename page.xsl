<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<xsl:output indent="yes"/>
<xsl:template name="start" match="/">
  <html>
    <body>
      <xsl:apply-templates/>
    </body>
  </html>
</xsl:template>

<xsl:template match="section">
  <div class="section">
    <xsl:for-each select="./feed">
      <div class="feed">
      <xsl:apply-templates select="document(concat('../nieuws_iswaar_data/', replace(., '[^a-zA-Z0-9]', '_')))//item"/>
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

