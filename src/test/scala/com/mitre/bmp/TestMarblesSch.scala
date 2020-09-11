package com.mitre.bmp

import com.helger.commons.io.resource.ClassPathResource
import com.helger.schematron.xslt.SchematronResourceXSLT
import org.junit.Assert.assertNotNull
import org.junit.Test

class TestMarblesSch {

  @Test def test_Full(): Unit = {
    val res = SchematronResourceXSLT.fromClassPath("/com/mitre/bmp/sch/bmp.xslt")
    assert(res.isValidSchematron, "schematron is not valid")

    val sch = new ClassPathResource("/com/mitre/bmp/Marbles/MARBLES.BMP.xml")
    val svrl = res.applySchematronValidation(sch)
    assertNotNull(svrl)

    // todo;; inspect the results further
  }
}
