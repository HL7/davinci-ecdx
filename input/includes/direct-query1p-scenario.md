<!--
#### Scenario

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C to confirm medical necessity.

##### Preconditions and Assumptions:

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the *logical id* of the resource for Patient B
- Payer A knows the appropriate codes for searching for active conditions

Following guidance in US Core searches for all active conditions using the combination of the patient and clinical-status search parameters:

`GET [base]/Condition?patient=[reference]&clinical-status=active,recurrance,remission
`
-->

##### Example:

**Request**
~~~
GET [base]/Condition?patient=06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b&clinical-status=active,recurrance,remission&_revinclude=Provenance:target
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
  "link": [
    {
      "relation": "self",
      "url": "http://hapi.fhir.org/baseR4/Condition?patient=06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b"
    }
  ],
  "entry": [
    {
      "fullUrl": "http://hapi.fhir.org/baseR4/Condition/4ac41715-fcbd-421c-8796-9b2c9706dd3f",
      "resource": {
        "resourceType": "Condition",
        "id": "4ac41715-fcbd-421c-8796-9b2c9706dd3f",
        "meta": {
          "versionId": "10",
          "lastUpdated": "2020-04-28T20:28:00.008+00:00",
          "source": "#cabiJIK51sD2iz4N",
          "profile": [
            "http://hl7.org/fhir/us/core/StructureDefinition/us-core-condition"
          ]
        },
        "clinicalStatus": {
          "coding": [
            {
              "system": "http://terminology.hl7.org/CodeSystem/condition-clinical",
              "code": "active"
            }
          ]
        },
        "verificationStatus": {
          "coding": [
            {
              "system": "http://terminology.hl7.org/CodeSystem/condition-ver-status",
              "code": "confirmed"
            }
          ]
        },
        "category": [
          {
            "coding": [
              {
                "system": "http://terminology.hl7.org/CodeSystem/condition-category",
                "code": "encounter-diagnosis",
                "display": "Encounter Diagnosis"
              }
            ]
          }
        ],
        "code": {
          "coding": [
            {
              "system": "http://snomed.info/sct",
              "code": "1234",
              "display": "Examplitis"
            }
          ],
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
    },
    {
      "fullUrl": "http://hapi.fhir.org/baseR4/Provenance/b2ce4584-b213-411b-bdc9-d515dc92eadf",
      "resource": {
        "resourceType": "Provenance",
        "id": "b2ce4584-b213-411b-bdc9-d515dc92eadf",
        "target": [
          {
            "reference": "Condition/4ac41715-fcbd-421c-8796-9b2c9706dd3f"
          }
        ],
        "recorded": "2018-10-21T21:22:15-07:00",
        "agent": [
          {
            "type": [
              {
                "coding": [
                  {
                    "system": "http://terminology.hl7.org/CodeSystem/provenance-participant-type",
                    "code": "author",
                    "display": "Author"
                  }
                ]
              }
            ],
            "who": {
              "reference": "Practitioner/Dr-Jones-12345"
            },
            "onBehalfOf": {
              "reference": "Organization/good-health-54321"
            }
          }
        ]
      },
      "search": {
        "mode": "include"
      }
    }
  ]
}
~~~