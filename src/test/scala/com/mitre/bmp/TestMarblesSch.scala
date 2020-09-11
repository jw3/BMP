package com.mitre.bmp

import java.io.ByteArrayOutputStream
import java.nio.charset.StandardCharsets

import com.helger.commons.io.resource.ClassPathResource
import com.helger.schematron.svrl.jaxb.SchematronOutputType
import com.helger.schematron.svrl.{SVRLMarshaller, SVRLNamespaceContext}
import com.helger.schematron.xslt.SchematronResourceXSLT
import org.junit.Assert.assertNotNull
import org.junit.Test

class TestMarblesSch {
  val sch = new ClassPathResource("/com/mitre/bmp/Marbles/MARBLES.BMP.xml")
  val infoset = "/com/mitre/bmp/Marbles/MARBLES.BMP.xml"

  @Test def test_Valid(): Unit = testBody()
  @Test def test_OneInvalid(): Unit = testBody("bad0")
  @Test def test_ManyInvalid(): Unit = testBody("bad1")

  def testBody(name: String = "") = {
    val res = SchematronResourceXSLT.fromClassPath(schematron(name))
    assert(res.isValidSchematron, "schematron is not valid")

    val sch = new ClassPathResource(infoset)
    val svrl: SchematronOutputType = res.applySchematronValidationToSVRL(sch)
    assertNotNull(svrl)

    // todo;; how to inspect svrl?
    printSvrl(svrl)
  }

  // take a look at the svrl
  def printSvrl(svrl: SchematronOutputType): Unit = {
    val aMarshaller = new SVRLMarshaller(false)
    aMarshaller.setFormattedOutput(true)
    aMarshaller.setNamespaceContext(SVRLNamespaceContext.getInstance)

    val bos = new ByteArrayOutputStream()
    aMarshaller.write(svrl, bos)
    val txt = bos.toString(StandardCharsets.UTF_8)
    println(txt)
  }

  def schematron(ext: String) = ext match {
    case "" => "/com/mitre/bmp/sch/bmp.xslt"
    case v => s"/com/mitre/bmp/sch/bmp.$ext.xslt"
  }
}
