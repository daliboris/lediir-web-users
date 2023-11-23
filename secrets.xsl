<xsl:stylesheet
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:r="http://exist-db.org/xquery/repo"
     exclude-result-prefixes="r"
    version="1.0">

 <!-- 
  TODO: crate local.secrets.xsl file (see <xsl:import /> 
  with template called permissions, eg.
    
  <xsl:template name="permissions">
   <permissions user="username" password="userpassword" group="tei" mode="rw-r\-\-r\-\-" /> 
  </xsl:template>
  
  Or you can use this definition of the element
  <xsl:element name="permissions" namespace="http://exist-db.org/xquery/repo">
   <xsl:attribute name="user">
    <xsl:text>username</xsl:text>
   </xsl:attribute>
   <xsl:attribute name="password">
    <xsl:text>userpassword</xsl:text>
   </xsl:attribute>
   <xsl:attribute name="group">
    <xsl:text>tei</xsl:text>
   </xsl:attribute>
   <xsl:attribute name="mode">
    <xsl:text>rw-r-\-r-\-</xsl:text>
   </xsl:attribute>
  </xsl:element>
  
  NOTE: remove backslashes ("\") in the @mode attribute,
  two dashes are not allowed in XML comments.
 -->

 <xsl:import href="local.secrets.xsl"/>
 
 <xsl:output method="xml" indent="yes"/>
 <xsl:param name="phase" select="'clean'" />
 <xsl:strip-space elements="*"/>

 <xsl:template match="r:meta">
  <xsl:copy>
   <xsl:copy-of select="@*"/>
   <xsl:apply-templates />
   <xsl:if test="not(r:permissions)">
    <xsl:call-template name="add-permissions" />
   </xsl:if>
  </xsl:copy>
 </xsl:template>

 <xsl:template match="r:permissions" name="add-permissions">
  <xsl:if test="$phase = 'prepare' and not(@user)">
   <xsl:call-template name="permissions" />
  </xsl:if>
  <xsl:if test="@user">
   <xsl:copy-of select="."/>
  </xsl:if>
 </xsl:template>

 
 <xsl:template match="node() | @*">
  <xsl:copy>
   <xsl:apply-templates select="node() | @*"/>
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="comment()" priority="2" />
 
 
</xsl:stylesheet>