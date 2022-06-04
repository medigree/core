The test plan contains all the 

### Environments:
```
@host1 = http://test.fhir.org/r4/
@host2 = http://hapi.fhir.org/baseR4/
@host3 = https://server.fire.ly/r4/
```
Let's start with the FHIR reference server
```
@host=`{{host1}}`
```

### Setup


#### 1. Create Patients:
Pne patient 
Patient/1545788
Patient/2081525


#### 2. Create MedicationStatements and a List:
```
PUT {{host2}}/List/p1023meds
Content-Type: application/fhir+json
Accept: application/fhir+json

{"resourceType":"List","id":"p1023meds","status":"current","mode":"snapshot","title":"Meds List","code":{"coding":[{"system":"http://hl7.org/fhir/list-example-use-codes","code":"meds"}]},"subject":{"reference":"Patient/1023"},"date":"2021-11-02T15:06:10-06:00","entry":[{"item":{"reference":"MedicationStatement/1"}},{"item":{"reference":"MedicationStatement/2"}},{"item":{"reference":"MedicationStatement/3"}},{"item":{"reference":"MedicationStatement/4"}},{"item":{"reference":"MedicationStatement/5"}},{"item":{"reference":"MedicationStatement/6"}},{"item":{"reference":"MedicationStatement/7"}}]}

```

### Test

#### 0. CapabilityStatement

```
GET {{host}}/CapabilityStatement
```


#### 1. Search all Patients
Get all Patients in a server
```
GET {{host}}/Patient
```
##### 1.1. When there are no patients 
##### 1.2. When there is one patient
##### 1.3. When there are patients


#### 2. GET a specific patient
```
GET {{host}}/Patient/1545788
Accept: application/fhir+json
```

#### 3. Search a patient by its _id
```
GET {{host}}/Patient?_id=1545788
```


#### 4. Search a patient by a logical identifier
```
GET {{host1}}/Patient?identifier=urn:trinhcongminh|123456 
```


#### 5. Get patients older than 21 years old
```
GET {{host}}/Patient?birthdate=lt2010-11-03
Accept: application/fhir+json
```

#### 6. Server-wide searches - Patient and Practitioner
```
GET {{host3}}/?name=r&_type=Practitioner,Patient
Accept: application/fhir+json
```


#### 7. POST search
```
POST {{host1}}/Patient/_search HTTP/1.1
Accept: application/fhir+json
Content-Type: application/x-www-form-urlencoded

_id=2081525
```

#### 8. Search non-existing parameter
> Will not work on HAPI, will be ignored on test.fhir.org  

```
GET {{host1}}/Patient?marital-status=http://terminology.hl7.org/CodeSystem/v3-MaritalStatus|U
Accept: application/fhir+json
```

#### 9. Return a JSON or XML response
```
GET {{host1}}/Patient/1545788?_format=json
```
```
GET {{host1}}/Patient/1545788?_format=_xml
```


#### 10. Return only summary
```
GET {{host}}/Patient?_summary=true
Accept: application/fhir+json
```


#### 11. Return only certain elements 
```
GET {{host}}/Patient?_elements=name,active,link
Accept: application/fhir+json
```

#### 12. Sort search results
```
GET {{host1}}/Patient?_sort=-birthdate,name
Accept: application/fhir+json
```


#### 13. Return more than the default 10 results
```
GET {{host3}}/?name=r&_type=Practitioner,Patient&_count=20
```




#### 14.Text search
```
GET {{host2}}/MedicationStatement?_text=%22John+Mark%22+NEAR+%22Gliclazide%22
Accept: application/fhir+json
Content-Type: application/x-www-form-urlencoded
```



#### 15. Get from a List
```
```

##### 15.1. Search for the list:
```
GET {{host2}}/List/p1023meds
Accept: application/fhir+json
```

#### 15.2. Get all items from a list
```
GET {{host2}}/MedicationStatement?_list=p1023meds
Accept: application/fhir+json
```



#### 16. Referenced resource - all Observations for a given patient
```
GET {{host2}}/Observation?subject=Patient/1024
Accept: application/fhir+json
```

#### 17. Get all MedicationStatements for a given patient given their identifier
```
GET {{host2}}/MedicationStatement?subject.identifier=http://trilliumbridge.eu/fhir/demos/eumfh/patient_id|EUR01P0004
Accept: application/fhir+json
```

#### 17.1. Get all Observations for a given patient given their identifier
HAPI
```
GET {{host1}}/Patient?identifier=urn:trinhcongminh|123456 
```


#### 18. Reverse Chaining - All Patients that have a MedRequest with intent=order
```
GET {{host}}/Patient?_has:MedicationRequest:subject:intent=order&_total=accurate
Accept: application/fhir+json
```


#### 19. get all MedRequests and **include** the referenced Patients
```
GET {{host}}/MedicationRequest?_include=MedicationRequest:patient
Accept: application/fhir+json
```


#### 20._revinclude : Get a Patient and include the observations that reference it
using _revinclude
```
GET {{host}}/Patient?_id=5&_revinclude=Observation:subject
Accept: application/fhir+json
```


#### 21. search contained
```
GET {{host2}}/Medication?_contained=true&_containedType=container
Accept: application/fhir+json
```


#### 22. Search type operators

##### 22.1 Search Patient by gender
```
GET {{host}}/Patient?gender=male
Accept: application/fhir+json
```

##### 22.2 Search Patient by gender (NOT)
```
GET {{host}}/Patient?gender:not=male
Accept: application/fhir+json
```

##### 22.3 Search patients above 65
```
GET {{host}}/Patient?birthdate=lt1956-11-03
Accept: application/fhir+json
```

##### 22.4 Search OR
```
GET {{host2}}/Patient?gender=male,unknown&_sort=gender
Accept: application/fhir+json
```

#### 22.5 Search: Composite
```
GET {{host2}}/DiagnosticReport?result.code-value-quantity=http://loinc.org|2823-3$gt5.4|http://unitsofmeasure.org|mmol/L
Accept: application/fhir+json
```




#### 23. GraphQL

#### 23.1. GraphQL
```
POST {{host2}}/Patient/$graphql HTTP/1.1
Accept: application/fhir+json
Content-Type: application/json

{"query":" { \n   Patient(id: 1023) { id, active } \n }","variables":{}}
```


##### 23.2 GraphQL
```
POST {{host2}}/Observation/11/$graphql HTTP/1.1
Accept: application/fhir+json
Content-Type: application/json

{"query":"  { id subject { reference resource(type : Patient) { gender name {given family}} }  code {coding {system code} } }","variables":{}}
```


### Teardown