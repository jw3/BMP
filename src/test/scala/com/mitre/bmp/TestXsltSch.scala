package com.mitre.bmp

import com.helger.schematron.xslt.SchematronResourceXSLT
import org.junit.Test

class TestXsltSch {

  @Test def test_Full(): Unit = {
    val res = SchematronResourceXSLT.fromFile("/home/wassj/dev/code/isis/BMP/src/main/resources/com/mitre/bmp/sch/bmp.xslt")
    assert(res.isValidSchematron, "schematron is not valid")
  }
}


