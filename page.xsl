<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output indent="yes"/>
  <xsl:param name="data_path" />
  <xsl:param name="conf_path" />
  <xsl:variable name="menu" select="document(concat($conf_path,'/','menu.html'))/ul" />

  <xsl:template name="start" match="/">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>
    <html>
      <head>
        <title><xsl:value-of select="//title"/></title>
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
        <script src="https://code.jquery.com/jquery-3.1.1.min.js" integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8=" crossorigin="anonymous">//comment </script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous">//comment </script>
        <script src="/resources/js/main.js">//comment</script>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="title">
      <div class="col-md-12">
        <h1><xsl:value-of select="."/></h1>
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
      </p>
    </article>
  </xsl:template>
</xsl:stylesheet>

