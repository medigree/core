Instance: TS1
InstanceOf: TestScript
* url = "medigree.net/fhir/testing/testscript-1"
* status = #active
* name = "A test script"

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

