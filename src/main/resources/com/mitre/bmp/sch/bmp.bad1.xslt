<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:saxon="http://saxon.sf.net/" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

<xsl:param name="archiveDirParameter" />
  <xsl:param name="archiveNameParameter" />
  <xsl:param name="fileNameParameter" />
  <xsl:param name="fileDirParameter" />
  <xsl:variable name="document-uri">
    <xsl:value-of select="document-uri(/)" />
  </xsl:variable>

<!--PHASES-->


<!--PROLOG-->
<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" />

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="." />
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">
        <xsl:value-of select="name()" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*:</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>[namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])" />
    <xsl:text>[</xsl:text>
    <xsl:value-of select="1+ $preceding" />
    <xsl:text>]</xsl:text>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()" />
</xsl:when>
      <xsl:otherwise>
        <xsl:text>@*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>' and namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="parent::*">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path" />
  <xsl:template match="text()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
  </xsl:template>
  <xsl:template match="comment()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
  </xsl:template>
  <xsl:template match="processing-instruction()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.@', name())" />
  </xsl:template>
  <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:text>.</xsl:text>
    <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
  </xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
  <xsl:template match="*" mode="generate-id-2" priority="2">
    <xsl:text>U</xsl:text>
    <xsl:number count="*" level="multiple" />
  </xsl:template>
  <xsl:template match="node()" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>n</xsl:text>
    <xsl:number count="node()" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="string-length(local-name(.))" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="translate(name(),':','.')" />
  </xsl:template>
<!--Strip characters-->  <xsl:template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<xsl:template match="/">
    <svrl:schematron-output schemaVersion="" title="">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="math" uri="http://www.w3.org/2005/xpath-functions/math" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">Magic-Number</xsl:attribute>
        <xsl:attribute name="name">Magic-Number</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M1" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">Reserved_Fields</xsl:attribute>
        <xsl:attribute name="name">Reserved_Fields</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M2" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">Padding_Fields</xsl:attribute>
        <xsl:attribute name="name">Padding_Fields</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M3" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">Color_Encoding</xsl:attribute>
        <xsl:attribute name="name">Color_Encoding</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M4" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">Number_of_Color_Planes</xsl:attribute>
        <xsl:attribute name="name">Number_of_Color_Planes</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M5" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">Number_of_Bits_per_Pixel</xsl:attribute>
        <xsl:attribute name="name">Number_of_Bits_per_Pixel</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M6" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:attribute name="id">Compression_Method</xsl:attribute>
        <xsl:attribute name="name">Compression_Method</xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M7" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN Magic-Number-->


	<!--RULE -->
<xsl:template match="BMP" mode="M1" priority="1000">
    <svrl:fired-rule context="BMP" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="Identifier = ('FOO', 'BAR')" />
      <xsl:otherwise>
        <svrl:failed-assert test="Identifier = ('FOO', 'BAR')">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The Identifier must be one of these values: FOO, BAR.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M1" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M1" priority="-1" />
  <xsl:template match="@*|node()" mode="M1" priority="-2">
    <xsl:apply-templates mode="M1" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN Reserved_Fields-->


	<!--RULE -->
<xsl:template match="Reserved" mode="M2" priority="1000">
    <svrl:fired-rule context="Reserved" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:integer(.) eq 999" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:integer(.) eq 999">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The Reserved field must be set to zero.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M2" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M2" priority="-1" />
  <xsl:template match="@*|node()" mode="M2" priority="-2">
    <xsl:apply-templates mode="M2" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN Padding_Fields-->


	<!--RULE -->
<xsl:template match="Padding" mode="M3" priority="1000">
    <svrl:fired-rule context="Padding" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:integer(.) eq 999" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:integer(.) eq 999">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The Padding field must be set to zero.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M3" priority="-1" />
  <xsl:template match="@*|node()" mode="M3" priority="-2">
    <xsl:apply-templates mode="M3" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN Color_Encoding-->


	<!--RULE -->
<xsl:template match="Color_Encoding" mode="M4" priority="1000">
    <svrl:fired-rule context="Color_Encoding" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:integer(.) eq 999" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:integer(.) eq 999">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The color encoding field must be set to zero.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M4" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M4" priority="-1" />
  <xsl:template match="@*|node()" mode="M4" priority="-2">
    <xsl:apply-templates mode="M4" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN Number_of_Color_Planes-->


	<!--RULE -->
<xsl:template match="Number_of_Color_Planes" mode="M5" priority="1000">
    <svrl:fired-rule context="Number_of_Color_Planes" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:integer(.) eq 999" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:integer(.) eq 999">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The number of color planes must be 1.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M5" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M5" priority="-1" />
  <xsl:template match="@*|node()" mode="M5" priority="-2">
    <xsl:apply-templates mode="M5" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN Number_of_Bits_per_Pixel-->


	<!--RULE -->
<xsl:template match="Number_of_Bits_per_Pixel" mode="M6" priority="1002">
    <svrl:fired-rule context="Number_of_Bits_per_Pixel" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:integer(.) = (999)" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:integer(.) = (999)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The number of bits per pixel must be 1, 4, 8, 16, 24, or 32.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="BITMAPCOREHEADER" mode="M6" priority="1001">
    <svrl:fired-rule context="BITMAPCOREHEADER" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="not(xs:integer(Number_of_Bits_per_Pixel) = (1, 2))" />
      <xsl:otherwise>
        <svrl:failed-assert test="not(xs:integer(Number_of_Bits_per_Pixel) = (1, 2))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                OS/2 1.x bitmaps are uncompressed and cannot be 16 or 32 bpp.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="*[Number_of_Colors_in_the_Color_Palette]" mode="M6" priority="1000">
    <svrl:fired-rule context="*[Number_of_Colors_in_the_Color_Palette]" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:integer(Number_of_Colors_in_the_Color_Palette) le math:pow(299, Number_of_Bits_per_Pixel)" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:integer(Number_of_Colors_in_the_Color_Palette) le math:pow(2, Number_of_Bits_per_Pixel)">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                The number of colors in the color palette must be less than
                or equal to 2**Number_of_Bits_per_Pixel.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M6" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M6" priority="-1" />
  <xsl:template match="@*|node()" mode="M6" priority="-2">
    <xsl:apply-templates mode="M6" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN Compression_Method-->


	<!--RULE -->
<xsl:template match="Compression_Method[. eq 'RLE 8-bit/pixel']" mode="M7" priority="1001">
    <svrl:fired-rule context="Compression_Method[. eq 'RLE 8-bit/pixel']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:integer(../Number_of_Bits_per_Pixel) eq 9998" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:integer(../Number_of_Bits_per_Pixel) eq 9998">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                A compression method of RLE 8-bit/pixel can be used only with 8-bit/pixel bitmaps.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>

	<!--RULE -->
<xsl:template match="Compression_Method[. eq 'RLE 4-bit/pixel']" mode="M7" priority="1000">
    <svrl:fired-rule context="Compression_Method[. eq 'RLE 4-bit/pixel']" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="xs:integer(../Number_of_Bits_per_Pixel) eq 9994" />
      <xsl:otherwise>
        <svrl:failed-assert test="xs:integer(../Number_of_Bits_per_Pixel) eq 9994">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
                A compression method of RLE 8-bit/pixel can be used only with 4-bit/pixel bitmaps.
            </svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M7" priority="-1" />
  <xsl:template match="@*|node()" mode="M7" priority="-2">
    <xsl:apply-templates mode="M7" select="*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
