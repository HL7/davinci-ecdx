<!--
#### Scenario

Payer A Seeks Insured Person/Patient B's glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.

##### Preconditions and Assumptions:

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the *logical id* of the resource for Patient B
- Payer A knows the appropriate LOINC codes for searching for HbA1c test results (e.g.: 4548-5 *Hemoglobin A1c/Hemoglobin.total in Blood*)

Following guidance in US Core searches for all HbA1c test results by a date range using using the combination of the patient and code and date search parameters:

`GET [base]/Observation?patient=[reference]&code=[code]&date=gt[date]`
-->
##### Example:

**Request**
~~~
GET [base]/Observation?patient=06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b&code=4548-4&date=gt2020-01-01
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
Date: Fri, 23 Oct 2020 18:22:45 GMT
Content-Type: application/fhir+json;charset=utf-8
...(other headers)
~~~

**Response Body**

~~~
{
  "resourceType": "Bundle",
  "id": "3d4fdbbe-b73c-4c9f-89a0-4662506c4d25",
  "meta": {
    "lastUpdated": "2020-10-23T18:22:45.274+00:00"
  },
  "type": "searchset",
  "total": 4,
  "link": [ {
    "relation": "self",
    "url": "http://hapi.fhir.org/baseR4/Observation?code=4548-4&date=gt2020-01-01&patient=06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b"
  } ],
  "entry": [ {
    "fullUrl": "http://hapi.fhir.org/baseR4/Observation/cdex-2020-01-23-hba1c-example",
    "resource": {
      "resourceType": "Observation",
      "id": "cdex-2020-01-23-hba1c-example",
      "meta": {
        "versionId": "1",
        "lastUpdated": "2020-10-23T18:18:25.154+00:00",
        "source": "#ObC36PK40pQM6y5M",
        "profile": [ "http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab" ]
      },
      "status": "final",
      "category": [ {
        "coding": [ {
          "system": "http://terminology.hl7.org/CodeSystem/observation-category",
          "code": "laboratory",
          "display": "Laboratory"
        } ],
        "text": "Laboratory"
      } ],
      "code": {
        "coding": [ {
          "system": "http://loinc.org",
          "code": "4548-4",
          "display": "Hemoglobin A1c/Hemoglobin.total in Blood"
        }, {
          "system": "http://www.ama-assn.org/go/cpt",
          "code": "83036",
          "display": "Hemoglobin; glycosylated (A1c)"
        }, {
          "system": "http://example.org/lab-results",
          "code": "HBA1C",
          "display": "Hglycated hemoglobin (HbA1c)"
        } ],
        "text": "glycated hemoglobin (HbA1c)"
      },
      "subject": {
        "reference": "Patient/06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b",
        "display": "Elden718 Halvorson124"
      },
      "effectiveDateTime": "2020-01-23T10:21:08-07:00",
      "valueQuantity": {
        "value": 6.0,
        "unit": "%",
        "system": "http://unitsofmeasure.org/",
        "code": "%"
      }
    },
    "search": {
      "mode": "match"
    }
  }, {
    "fullUrl": "http://hapi.fhir.org/baseR4/Observation/cdex-2020-04-23-hba1c-example",
    "resource": {
      "resourceType": "Observation",
      "id": "cdex-2020-04-23-hba1c-example",
      "meta": {
        "versionId": "1",
        "lastUpdated": "2020-10-23T18:17:49.885+00:00",
        "source": "#n7aoEe76sAQUBlns",
        "profile": [ "http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab" ]
      },
      "status": "final",
      "category": [ {
        "coding": [ {
          "system": "http://terminology.hl7.org/CodeSystem/observation-category",
          "code": "laboratory",
          "display": "Laboratory"
        } ],
        "text": "Laboratory"
      } ],
      "code": {
        "coding": [ {
          "system": "http://loinc.org",
          "code": "4548-4",
          "display": "Hemoglobin A1c/Hemoglobin.total in Blood"
        }, {
          "system": "http://www.ama-assn.org/go/cpt",
          "code": "83036",
          "display": "Hemoglobin; glycosylated (A1c)"
        }, {
          "system": "http://example.org/lab-results",
          "code": "HBA1C",
          "display": "Hglycated hemoglobin (HbA1c)"
        } ],
        "text": "glycated hemoglobin (HbA1c)"
      },
      "subject": {
        "reference": "Patient/06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b",
        "display": "Elden718 Halvorson124"
      },
      "effectiveDateTime": "2020-04-23T10:21:08-07:00",
      "valueQuantity": {
        "value": 7.2,
        "unit": "%",
        "system": "http://unitsofmeasure.org/",
        "code": "%"
      }
    },
    "search": {
      "mode": "match"
    }
  }, {
    "fullUrl": "http://hapi.fhir.org/baseR4/Observation/cdex-2020-10-23-hba1c-example",
    "resource": {
      "resourceType": "Observation",
      "id": "cdex-2020-10-23-hba1c-example",
      "meta": {
        "versionId": "1",
        "lastUpdated": "2020-10-23T18:16:54.549+00:00",
        "source": "#fuIEQP7SJ9NfAlPN",
        "profile": [ "http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab" ]
      },
      "status": "final",
      "category": [ {
        "coding": [ {
          "system": "http://terminology.hl7.org/CodeSystem/observation-category",
          "code": "laboratory",
          "display": "Laboratory"
        } ],
        "text": "Laboratory"
      } ],
      "code": {
        "coding": [ {
          "system": "http://loinc.org",
          "code": "4548-4",
          "display": "Hemoglobin A1c/Hemoglobin.total in Blood"
        }, {
          "system": "http://www.ama-assn.org/go/cpt",
          "code": "83036",
          "display": "Hemoglobin; glycosylated (A1c)"
        }, {
          "system": "http://example.org/lab-results",
          "code": "HBA1C",
          "display": "Hglycated hemoglobin (HbA1c)"
        } ],
        "text": "glycated hemoglobin (HbA1c)"
      },
      "subject": {
        "reference": "Patient/06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b",
        "display": "Elden718 Halvorson124"
      },
      "effectiveDateTime": "2020-10-23T10:21:08-07:00",
      "valueQuantity": {
        "value": 7.0,
        "unit": "%",
        "system": "http://unitsofmeasure.org/",
        "code": "%"
      }
    },
    "search": {
      "mode": "match"
    }
  }, {
    "fullUrl": "http://hapi.fhir.org/baseR4/Observation/cdex-2020-07-23-hba1c-example",
    "resource": {
      "resourceType": "Observation",
      "id": "cdex-2020-07-23-hba1c-example",
      "meta": {
        "versionId": "1",
        "lastUpdated": "2020-10-23T18:16:17.687+00:00",
        "source": "#X2hXINwPYymTmEJc",
        "profile": [ "http://hl7.org/fhir/us/core/StructureDefinition/us-core-observation-lab" ]
      },
      "status": "final",
      "category": [ {
        "coding": [ {
          "system": "http://terminology.hl7.org/CodeSystem/observation-category",
          "code": "laboratory",
          "display": "Laboratory"
        } ],
        "text": "Laboratory"
      } ],
      "code": {
        "coding": [ {
          "system": "http://loinc.org",
          "code": "4548-4",
          "display": "Hemoglobin A1c/Hemoglobin.total in Blood"
        }, {
          "system": "http://www.ama-assn.org/go/cpt",
          "code": "83036",
          "display": "Hemoglobin; glycosylated (A1c)"
        }, {
          "system": "http://example.org/lab-results",
          "code": "HBA1C",
          "display": "Hglycated hemoglobin (HbA1c)"
        } ],
        "text": "glycated hemoglobin (HbA1c)"
      },
      "subject": {
        "reference": "Patient/06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b",
        "display": "Elden718 Halvorson124"
      },
      "effectiveDateTime": "2020-07-23T10:21:08-07:00",
      "valueQuantity": {
        "value": 7.0,
        "unit": "%",
        "system": "http://unitsofmeasure.org/",
        "code": "%"
      }
    },
    "search": {
      "mode": "match"
    }
  } ]
}
~~~
