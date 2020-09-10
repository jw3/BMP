package com.mitre.bmp

import java.nio.charset.StandardCharsets

import com.helger.commons.io.stream.StringInputStream
import com.helger.schematron.pure.SchematronResourcePure
import com.helger.schematron.pure.errorhandler.LoggingPSErrorHandler
import org.junit.Test

class TestPureSch {
  import TestPureSch._

  @Test def test_Simple(): Unit = {
    val res = SchematronResourcePure.fromInputStream(new StringInputStream(simple, StandardCharsets.UTF_8))
    res.validateCompletely(new LoggingPSErrorHandler())
    assert(res.isValidSchematron, "schematron is not valid")
  }

  @Test def test_Full() {
    val res = SchematronResourcePure.fromInputStream(new StringInputStream(full, StandardCharsets.UTF_8))
    res.validateCompletely(new LoggingPSErrorHandler())
    assert(res.isValidSchematron, "schematron is not valid")

    // fails with:
    // javax.xml.xpath.XPathExpressionException: net.sf.saxon.trans.XPathException: Cannot find a 1-argument function named Q{}integer(). External function calls have been disabled
  }
}

object TestPureSch {
  val simple =
    """<?xml version="1.0" encoding="iso-8859-1"?>
      |<iso:schema xmlns="http://purl.oclc.org/dsdl/schematron"
      |            xmlns:iso="http://purl.oclc.org/dsdl/schematron"
      |            xmlns:sch="http://www.ascc.net/xml/schematron"
      |            xmlns:math="http://www.w3.org/2005/xpath-functions/math"
      |            queryBinding="xslt2"
      |            schemaVersion="ISO19757-3">
      |
      |    <iso:ns uri="http://www.w3.org/2005/xpath-functions/math" prefix="math"/>
      |
      |    <iso:pattern id="Magic-Number">
      |        <iso:rule context="BMP">
      |            <iso:assert test="Identifier = ('BM', 'BA', 'CI', 'CP', 'IC', 'PT')">
      |                The Identifier must be one of these values: BM, BA, CI, CP, IC, PT.
      |            </iso:assert>
      |        </iso:rule>
      |    </iso:pattern>
      |
      |</iso:schema>
      |
      |
      |""".stripMargin

  val full =
    """<?xml version="1.0" encoding="iso-8859-1"?>
      |<iso:schema xmlns="http://purl.oclc.org/dsdl/schematron"
      |            xmlns:iso="http://purl.oclc.org/dsdl/schematron"
      |            xmlns:sch="http://www.ascc.net/xml/schematron"
      |            xmlns:math="http://www.w3.org/2005/xpath-functions/math"
      |            queryBinding="xslt2"
      |            schemaVersion="ISO19757-3">
      |
      |    <iso:ns uri="http://www.w3.org/2005/xpath-functions/math" prefix="math"/>
      |
      |    <iso:pattern id="Magic-Number">
      |        <iso:rule context="BMP">
      |            <iso:assert test="Identifier = ('BM', 'BA', 'CI', 'CP', 'IC', 'PT')">
      |                The Identifier must be one of these values: BM, BA, CI, CP, IC, PT.
      |            </iso:assert>
      |        </iso:rule>
      |    </iso:pattern>
      |
      |    <iso:pattern id="Reserved_Fields">
      |        <iso:rule context="Reserved">
      |            <iso:assert test="xs:integer(.) eq 0">
      |                The Reserved field must be set to zero.
      |            </iso:assert>
      |        </iso:rule>
      |    </iso:pattern>
      |
      |    <iso:pattern id="Padding_Fields">
      |        <iso:rule context="Padding">
      |            <iso:assert test="xs:integer(.) eq 0">
      |                The Padding field must be set to zero.
      |            </iso:assert>
      |        </iso:rule>
      |    </iso:pattern>
      |
      |    <iso:pattern id="Color_Encoding">
      |        <iso:rule context="Color_Encoding">
      |            <iso:assert test="xs:integer(.) eq 0">
      |                The color encoding field must be set to zero.
      |            </iso:assert>
      |        </iso:rule>
      |    </iso:pattern>
      |
      |    <iso:pattern id="Number_of_Color_Planes">
      |        <iso:rule context="Number_of_Color_Planes">
      |            <iso:assert test="xs:integer(.) eq 1">
      |                The number of color planes must be 1.
      |            </iso:assert>
      |        </iso:rule>
      |    </iso:pattern>
      |
      |    <iso:pattern id="Number_of_Bits_per_Pixel">
      |        <iso:rule context="Number_of_Bits_per_Pixel">
      |            <iso:assert test="xs:integer(.) = (1, 4, 8, 16, 24, 32)">
      |                The number of bits per pixel must be 1, 4, 8, 16, 24, or 32.
      |            </iso:assert>
      |        </iso:rule>
      |        <iso:rule context="BITMAPCOREHEADER">
      |            <iso:assert test="not(xs:integer(Number_of_Bits_per_Pixel) = (16, 32))">
      |                OS/2 1.x bitmaps are uncompressed and cannot be 16 or 32 bpp.
      |            </iso:assert>
      |        </iso:rule>
      |        <iso:rule context="*[Number_of_Colors_in_the_Color_Palette]">
      |            <iso:assert test="xs:integer(Number_of_Colors_in_the_Color_Palette) le math:pow(2, Number_of_Bits_per_Pixel)">
      |                The number of colors in the color palette must be less than
      |                or equal to 2**Number_of_Bits_per_Pixel.
      |            </iso:assert>
      |        </iso:rule>
      |    </iso:pattern>
      |
      |    <iso:pattern id="Compression_Method">
      |        <iso:rule context="Compression_Method[. eq 'RLE 8-bit/pixel']">
      |            <iso:assert test="xs:integer(../Number_of_Bits_per_Pixel) eq 8">
      |                A compression method of RLE 8-bit/pixel can be used only with 8-bit/pixel bitmaps.
      |            </iso:assert>
      |        </iso:rule>
      |        <iso:rule context="Compression_Method[. eq 'RLE 4-bit/pixel']">
      |            <iso:assert test="xs:integer(../Number_of_Bits_per_Pixel) eq 4">
      |                A compression method of RLE 8-bit/pixel can be used only with 4-bit/pixel bitmaps.
      |            </iso:assert>
      |        </iso:rule>
      |    </iso:pattern>
      |
      |</iso:schema>
      |
      |
      |""".stripMargin
}
