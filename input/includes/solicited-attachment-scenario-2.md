


#### Step 1 - POST Task to Provider endpoint


**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include_relative Task-cdex-task-inline-example22.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example22/_history/1

...(other headers)

~~~

#### Step 2 - Provider Invokes DTR To Complete Questionnaire

If the Provider Launches DTR as a SMART on FHIR Application in SMART’s EHR launch flow, proceed to step 3
If the Provider launches a DTR within an EHR native application, skip to step 7

#### Step 3 - DTR App Fetches Task

**Request**

~~~

GET [base]/Task/cdex-task-example22

~~~

**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example22/_history/1

...(other headers)

~~~

**Response Body**


~~~

{% include_relative Task-cdex-task-example22.json %}

~~~

#### Step 4 - DTR App Inspects Task for Questionnaire Canonical URL and fetches the "Questionnaire"


**Request**

~~~

GET http://example.org/FHIR/Questionnare/cdex-questionnaire-example1

~~~

**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Questionnare/cdex-questionnaire-example1

...(other headers)

~~~

**Response Body**


~~~

{% include_relative Questionnaire-cdex-questionnaire-example1.json %}

~~~

#### Step 5 - DTR App Fills QuestionnaireResponse

{% include img-small.html img='fill-form-icon.svg' %}


#### Step 6 - DTR App POSTs QuestionnaireResponse to Provider FHIR Server

**Request**

~~~

POST [base]/QuestionnaireResponse

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include_relative QuestionnaireResponse-cdex-questionnaireresponse-example1.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/QuestionnaireResponse/cdex-questionnaireresponse-inline-example1/_history/1

...(other headers)

~~~

#### Step 7 -  The DTR SMART App or EHR native application Updates Task.output to Reference QuestionnaireResponse

**Request**

~~~

PUT [base]/Task/cdex-task-example-22

~~~


{% include request-headers.md %}


**Request Body**

~~~

{
  "resourceType": "Task",
  "id": "cdex-task-example22,
  "contained": [
    {
      "resourceType": "Patient",
      "id": "patient",
      "meta": {
        "profile": [
          "http://hl7.org/fhir/us/davinci-cdex/StructureDefinition/cdex-patient-demographics"
        ]
      },
      "identifier": [
        {
          "use": "usual",
          "type": {
            "coding": [
              {
                "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
                "code": "MB",
                "display": "Member Number"
              }
            ],
            "text": "Member Number"
          },
          "system": "http://example.org/cdex/payer/member-ids",
          "value": "Member123"
        },
        {
          "use": "usual",
          "type": {
            "coding": [
              {
                "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBIdentifierType",
                "code": "pat",
                "display": "Patient Account Number"
              }
            ],
            "text": "Patient Account Number"
          },
          "system": "http://example.org/cdex/provider/patient-ids",
          "value": "PA-123"
        }
      ],
      "name": [
        {
          "family": "Shaw",
          "given": [
            "Amy"
          ]
        }
      ],
      "birthDate": "1987-02-20"
    },
    {
      "resourceType": "PractitionerRole",
      "id": "practitionerrole",
      "meta": {
        "profile": [
          "http://hl7.org/fhir/us/davinci-cdex/StructureDefinition/cdex-practitionerrole"
        ]
      },
      "practitioner": {
        "identifier": {
          "system": "http://hl7.org/fhir/sid/us-npi",
          "value": "9941339100"
        }
      },
      "organization": {
        "identifier": {
          "system": "http://hl7.org/fhir/sid/us-npi",
          "value": "1234567893"
        }
      }
    }
  ],
  "identifier": [
    {
      "type": {
        "coding": [
          {
            "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
            "code": "tracking-id",
            "display": "Tracking Id"
          }
        ],
        "text": "Re-Association Tracking Control Number"
      },
      "system": "http://example.org/payer",
      "value": "trackingid1012"
    }
  ],
  "status": "pending",
  "intent": "order",
  "code": {
    "coding": [
      {
        "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
        "code": "attachment-request-questionnaire"
      }
    ],
    "text": "Attachment Request Questionnaire"
  },
  "for": {
    "reference": "#patient"
  },
  "authoredOn": "2022-06-17T16:16:06+00:00",
  "lastModified": "2022-06-17T16:17:06+00:00",
  "requester": {
    "identifier": {
      "system": "http://example.org/cdex/payer/payer-ids",
      "value": "Payer123"
    }
  },
  "owner": {
    "reference": "#practitionerrole"
  },
  "reasonCode": {
    "coding": [
      {
        "system": "http://hl7.org/fhir/claim-use",
        "code": "preauthorization",
        "display": "Preauthorization"
      }
    ],
    "text": "preauthorization"
  },
  "reasonReference": {
    "identifier": {
      "system": "http://example.org/cdex/payer/claim-ids",
      "value": "Preauth123"
    }
  },
  "restriction": {
    "period": {
      "end": "2022-06-21"
    }
  },
  "input": [
    {
      "extension": [
        {
          "url": "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-paLineNumber",
          "valueInteger": 1
        }
      ],
      "type": {
        "coding": [
          {
            "system": "http://hl7.org/fhir/uv/sdc/CodeSystem/temp",
            "code": "questionnaire"
          }
        ]
      },
      "valueCanonical": "http://example.org/cdex-questionnaire-inline-example1|2.1.0-preview"
    },
    {
      "type": {
        "coding": [
          {
            "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
            "code": "payer-url"
          }
        ]
      },
      "valueUrl": "http://example.org/cdex/payer/$submit-attachment"
    },
    {
      "type": {
        "coding": [
          {
            "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
            "code": "purpose-of-use"
          }
        ]
      },
      "valueCodeableConcept": {
        "coding": [
          {
            "system": "http://terminology.hl7.org/CodeSystem/v3-ActReason",
            "code": "COVAUTH",
            "display": "coverage authorization"
          }
        ]
      }
    }
  ],
  "output": [
    {
      "type": {
        "coding": [
          {
            "system": "http://hl7.org/fhir/uv/sdc/CodeSystem/temp",
            "code": "questionnaire-response"
          }
        ]
      },
      "valueReference": {
        "reference": "QuestionnaireResponse/cdex-questionnaireresponse-example1"
      }
    }
  ]
}


~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example22/_history/2

...(other headers)

~~~

#### Step 8 - EHR Updates Task Status To "completed" When Questionnaire Response Status Is "completed" (Not Shown).

#### Step 9 - EHR POSTs `$submit-attachment` Operation to Payer endpoint



**Request**


~~~

POST [base]/$submit-attachment

~~~


**Request Headers**


{% include request-headers.md %}


**Request Body**


~~~

{% include_relative Parameters-cdex-parameters-example5.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Payer Server

Content-Type: application/fhir+json;charset=utf-8

...(other headers)

~~~


####  [Rendered QuestionnaireResponse](http://hl7.org/fhir/us/davinci-cdex/STU2/QuestionnaireResponse-cdex-questionnaireresponse-example1.html)
