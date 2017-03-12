<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="html" encoding="utf-8" indent="yes" />
  <xsl:param name="data_path" />
  <xsl:param name="conf_path" />
  <xsl:variable name="menu" select="document(concat($conf_path,'/','menu.html'))/ul" />
  <xsl:template name="start" match="/">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
    <html>
      <head>
        <title><xsl:value-of select="//title"/></title>
          <meta http-equiv="cache-control" content="no-cache, must-revalidate, post-check=0, pre-check=0" />
          <meta http-equiv="expires" content="Sat, 31 Oct 2014 00:00:00 GMT" />
          <meta http-equiv="pragma" content="no-cache" />

        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous" />
        <link rel="stylesheet" href="/resources/css/main.css" />
      </head>
      <body>
        <div class="container">
          <div class="row">
            <xsl:copy-of select="$menu" />
          </div>
          <div class="row">
            <xsl:apply-templates/>
          </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.1.1.min.js" integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8=" crossorigin="anonymous"></script>
        <script src="/resources/js/main.js"></script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="title">
      <div class="col-md-12">
        <h1><xsl:value-of select="."/></h1>
        <p><em>Laatste update: <xsl:value-of select="current-time()" /></em></p>
      </div>
  </xsl:template>

  <xsl:template match="section">
    <div class="section col-md-4">
     <xsl:for-each select="./feed">
        <xsl:if test="doc-available(concat($data_path,'/',replace(., '[^a-zA-Z0-9]', '_')))"> 
        <div class="feed">
          <xsl:apply-templates select="document(concat($data_path,'/',replace(., '[^a-zA-Z0-9]', '_')))/*"/>
        </div>
        </xsl:if>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="//feed_title">
    <h2><xsl:value-of select="." /></h2>
  </xsl:template>

  <xsl:template match="//item">
    <article class="item">
      <h3><a>
        <xsl:attribute name="href">
          <xsl:value-of select="./link" />
        </xsl:attribute>
        <xsl:value-of select="./title" />
        </a>
      </h3>
      <p class="description">
        <xsl:value-of select="./description" />
        <br />
        <a target="_blank" class="external_link">
          <xsl:attribute name="href">
            <xsl:value-of select="./link" />
          </xsl:attribute>
            <span class="glyphicon glyphicon-new-window"></span>
            <span>&#160;
            <xsl:value-of select="./link" />
            </span>
        </a>
      </p>
    </article>
  </xsl:template>
</xsl:stylesheet>

