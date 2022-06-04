Instance: TS1
InstanceOf: TestScript

* url = "medigree.net/fhir/testing/testscript-1"
* status = #active
* name = "A test script"

* extension[+]
  * url = "http://hl7.org/fhir/5.0/StructureDefinition/extension-TestScript.scope"
  * extension[+]
    * url = "artifact"
    * valueCanonical = Canonical(Req1)
  * extension[+]
    * url = "conformance"
    * valueCodeableConcept = http://terminology.hl7.org/CodeSystem/testscript-scope-conformance-codes#required "Required"


* test
  * name = "CapabilityStatement"
  * description = "Get a server's CapabilityStatement and validate response."
  * action[+].operation
    * type = http://terminology.hl7.org/CodeSystem/testscript-operation-codes#read
    * description = "Get the server's metadata"
    * accept = #xml
    * url = "http://test.fhir.org/r4/metadata"
    * params = "?_format=xml"
    * encodeRequestUrl = true

  * action[+].assert
    * description = "Confirm that the returned HTTP status is 200(OK)."
    * response = #okay
    * warningOnly = false

  * action[+].assert
    * description = "Confirm that the returned format is XML."
    * contentType = #xml
    * warningOnly = false

  * action[+].assert
    * description = "Confirm that the returned resource type is CapabilityStatement."
    * resource = #Bundle
    * warningOnly = false

