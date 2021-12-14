
**Request**
~~~
GET [base]/Condition?patient=06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b&clinical-status=active,recurrance,remission
~~~

**Request Headers**

~~~
Accept: application/fhir+json
Content-Type: application/fhir+json
...(other headers)
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: nginx/1.14.0 (Ubuntu)
Date: Fri, 23 Oct 2020 04:54:56 GMT
Content-Type: application/fhir+json;charset=utf-8
...(other headers)
~~~

**Response Body**

~~~
{
  "resourceType": "Bundle",
  "id": "d88e2910-3c95-469d-b1f4-ab5553b471fb",
  "meta": {
    "lastUpdated": "2020-10-23T04:54:56.048+00:00"
  },
  "type": "searchset",
  "total": 1,
  "link": [ {
    "relation": "self",
    "url": "http://hapi.fhir.org/baseR4/Condition?patient=06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b&clinical-status=active,recurrance,remission"
  } ],
  "entry": [ {
    "fullUrl": "http://hapi.fhir.org/baseR4/Condition/4ac41715-fcbd-421c-8796-9b2c9706dd3f",
    "resource": {
      "resourceType": "Condition",
      "id": "4ac41715-fcbd-421c-8796-9b2c9706dd3f",
      "meta": {
        "versionId": "10",
        "lastUpdated": "2020-04-28T20:28:00.008+00:00",
        "source": "#cabiJIK51sD2iz4N",
        "profile": [ "http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition" ]
      },
      "clinicalStatus": {
        "coding": [ {
          "system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
          "code": "active"
        } ]
      },
      "verificationStatus": {
        "coding": [ {
          "system": "http://terminology.hl7.org/CodeSystem/condition-ver-status",
          "code": "confirmed"
        } ]
      },
      "category": [ {
        "coding": [ {
          "system": "http://terminology.hl7.org/CodeSystem/condition-category",
          "code": "encounter-diagnosis",
          "display": "Encounter Diagnosis"
        } ]
      } ],
      "code": {
        "coding": [ {
          "system": "http://snomed.info/sct",
          "code": "1234",
          "display": "Examplitis"
        } ],
        "text": "Examplitis"
      },
      "subject": {
        "reference": "Patient/06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b"
      },
      "encounter": {
        "reference": "Encounter/5fe62cd5-bfcf-4d3b-a1e9-80d6f75d6f82"
      },
      "onsetDateTime": "2018-10-21T21:22:15-07:00",
      "recordedDate": "2018-10-21T21:22:15-07:00"
    },
    "search": {
      "mode": "match"
    }
  } ]
}
~~~
