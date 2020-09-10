name := "dfdl-bmp"
 
organization := "org.mitre"
 
version := "0.0.1"
 
scalaVersion := "2.12.11"
 
libraryDependencies ++= Seq(
  "org.apache.daffodil" %% "daffodil-tdml-processor" % "2.6.0" % "test",
  "com.novocode" % "junit-interface" % "0.11" % "test",
  "junit" % "junit" % "4.12" % "test",
  "com.helger" % "ph-schematron" % "5.6.1" % "test",
  "ch.qos.logback" % "logback-classic" % "1.2.3"
)

testOptions += Tests.Argument(TestFrameworks.JUnit, "-v")

crossPaths := false
