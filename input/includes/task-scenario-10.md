


#### Step 1 - POST Task to Provider endpoint


**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include_relative Task-cdex-task-inline-example26.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example26/_history/1

...(other headers)

~~~

#### Step 2 - Provider Invokes DTR To Complete Questionnaire

If the Provider Launches DTR as a SMART on FHIR Application in SMART’s EHR launch flow, proceed to step 3
If the Provider launches a DTR within an EHR native application, skip to step 7

#### Step 3 - DTR App Fetches Task

**Request**

~~~

GET [base]/Task/cdex-task-example26

~~~

**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example26/_history/1

...(other headers)

~~~

**Response Body**


~~~

{% include_relative Task-cdex-task-example26.json %}

~~~

#### Step 4 - DTR App Inspects Task for Questionnaire Canonical URL and Fetches the Questionnaire


**Request**

~~~

GET http://example.org/FHIR/Questionnare/cdex-questionnaire-example1

~~~

**Response Headers**

~~~

HTTP/1.1 200 OK

Server: CDEX Example Questionnaire Endpoint

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

{% include_relative QuestionnaireResponse-cdex-questionnaireresponse-inline-example1.json %}

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

PUT [base]/Task/cdex-task-example-26

~~~


{% include request-headers.md %}


**Request Body**


~~~

{
  "resourceType": "Task",
  "id": "cdex-task-example26",
  "status": "in-progress",
  "intent": "order",
  "code": {
    "coding": [
      {
        "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
        "code": "data-request-questionnaire"
      }
    ]
  },
  "for": {
    "identifier": {
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
    }
  },
  "authoredOn": "2022-06-17T16:16:06+00:00",
  "lastModified": "2022-06-19T12:00:00+00:00",
  "requester": {
    "identifier": {
      "system": "http://example.org/cdex/payer/payer-ids",
      "value": "Payer123"
    }
  },
  "owner": {
    "identifier": {
      "system": "http://hl7.org/fhir/sid/us-npi",
      "value": "9941339108"
    }
  },
  "reasonReference": {
    "identifier": {
      "type": {
        "coding": [
          {
            "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
            "code": "FILL",
            "display": "Filler Identifier"
          }
        ],
        "text": "Payer Claim ID"
      },
      "system": "http://example.org/cdex/payer/claim-ids",
      "value": "Claim123"
    }
  },
  "input": [
    {
      "type": {
        "coding": [
          {
            "system": "http://hl7.org/fhir/uv/sdc/CodeSystem/temp",
            "code": "questionnaire"
          }
        ]
      },
      "questionnaire" : "http://example.org/cdex-questionnaire-example1"
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
            "code": "COVERAGE"
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

Location: http://example.org/FHIR/Task/cdex-task-example26/_history/2

...(other headers)

~~~

#### Step 8 - EHR Updates Task Status To "completed" When Questionnaire Response Status Is "completed" (Not Shown).

#### Step 9 - Data Consumer Polls Task


**Polling Request**

~~~

GET Task/cdex-task-example2

~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~

{
  "resourceType": "Task",
  "id": "cdex-task-example26",
  "status": "completed",
  "intent": "order",
  "code": {
    "coding": [
      {
        "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
        "code": "data-request-questionnaire"
      }
    ]
  },
  "for": {
    "identifier": {
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
    }
  },
  "authoredOn": "2022-06-17T16:16:06+00:00",
  "lastModified": "2022-06-19T12:00:00+00:00",
  "requester": {
    "identifier": {
      "system": "http://example.org/cdex/payer/payer-ids",
      "value": "Payer123"
    }
  },
  "owner": {
    "identifier": {
      "system": "http://hl7.org/fhir/sid/us-npi",
      "value": "9941339108"
    }
  },
  "reasonReference": {
    "identifier": {
      "type": {
        "coding": [
          {
            "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
            "code": "FILL",
            "display": "Filler Identifier"
          }
        ],
        "text": "Payer Claim ID"
      },
      "system": "http://example.org/cdex/payer/claim-ids",
      "value": "Claim123"
    }
  },
  "input": [
    {
      "type": {
        "coding": [
          {
            "system": "http://hl7.org/fhir/uv/sdc/CodeSystem/temp",
            "code": "questionnaire"
          }
        ]
      },
      "questionnaire" : "http://example.org/cdex-questionnaire-example1"
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
            "code": "COVERAGE"
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


#### Step 10 - Fetch QuestionnaireResponse


**Request**

~~~

GET [base]QuestinnaireResponse/cdex-questionnaireresponse-example1
~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~

{% include_relative QuestionnaireResponse-cdex-questionnaireresponse-example1.json %}

~~~

####  [Rendered QuestionnaireResponse](http://hl7.org/fhir/us/davinci-cdex/STU2/QuestionnaireResponse-cdex-questionnaireresponse-example1.html)
