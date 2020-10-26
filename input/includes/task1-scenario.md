#### Scenario

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C to confirm medical necessity.

##### Preconditions and Assumptions:
- The Appropriateness of the request needs to be determined or access to the data is limited
- No formal authorization (order) is needed

In this situation, there is human involvement needed to approve the release of the data:

Following the guidance in this guide and HRex, Getting Active Conditions from Provider is typically a two or three step process:

1. The Payer POSTS a Task to the Provider endpoint requesting Patient B's Active Conditions.  This can be done using FHIR RESTful query syntax or with natural language text.  (In the example below, the FHIR RESTful query syntax is used.)
2. The Payer then subsequently polls the Task resource until the `Task.status` indicates it is completed or rejected.
3. When the task is complete, the Payer fetches the data of interest which is referenced by `Task.output`.  It can either refer to a 'contained' search set Bundle - because the Bundle isn't something that would have any independent existence or to external resources which are subsequently fetched by the Payer use a RESTful GET. (In the example below, `Task.output` refers to external resources.)

##### Example:

###### Step 1 - POST Task to Provider endpoint

**Request**
~~~
POST [base]/Task
~~~

**Request Headers**

~~~
Accept: application/fhir+json
Content-Type: application/fhir+json
...(other headers)
~~~

**Request Body**

~~~
resourceType: Task
meta:
  profile:
    - >-
      http://hl7.org/fhir/us/davinci-cdex/StructureDefinition/cdex-task-data-request
basedOn:
  - reference: Claim/cdex-example-claim
status: requested
intent: order
code:
  coding:
    - system: 'http://hl7.org/fhir/us/davinci-hrex/CodeSystem/hrex-temp'
      code: data-request
for:
  reference: Patient/cdex-example-patient
authoredOn: '2020-10-26T02:58:55.179Z'
lastModified: '2020-10-26T02:58:55.179Z'
requester:
  reference: Organization/cdex-example-payer
owner:
  reference: Organization/cdex-example-payer
reasonCode:
  text: Support prior authorization decision-making
reasonReference:
  reference: Claim/cdex-example-claim
input:
  - type:
      coding:
        - system: 'http://hl7.org/fhir/us/davinci-hrex/CodeSystem/hrex-temp'
          code: data-query
    valueString: Condition?patient=cdex-example-patient&clinical-status=active,recurrance,remission
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: CDEX Example Server
Location: http://test.fhir.org/r4/Task/fbbef76a-1d16-f910-757d-847c489fc26c/_history/1
...(other headers)
~~~

###### Step 2 - Repeatedly Poll until Task.status is updated to "completed"

**Polling Request**
~~~
GET Task/fbbef76a-1d16-f910-757d-847c489fc26c
~~~

**Request Headers**

~~~
Accept: application/fhir+json
...(other headers)
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Content-Type: application/fhir+json;charset=utf-8
...(other headers)
~~~

**Response Body**

~~~
{
    "resourceType": "Task",
    "id": "fbbef76a-1d16-f910-757d-847c489fc26c",
    "meta": {
        "versionId": "3",
        "lastUpdated": "2020-10-26T04:04:52.000+00:00",
        "source": "#tgH2FoPFuCq0yjw5",
        "profile": [
            "http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-task-data-request"
        ]
    },
    "basedOn": [
        {
            "reference": "Claim/cdex-example-claim"
        }
    ],
    "status": "completed",
    "businessStatus": {
        "text": "Results reviewed for release"
    },
    "intent": "order",
    "code": {
        "coding": [
            {
                "system": "http://hl7.org/fhir/us/davinci-hrex/CodeSystem/hrex-temp",
                "code": "data-request"
            }
        ]
    },
    "for": {
        "reference": "Patient/cdex-example-patient"
    },
    "authoredOn": "2020-10-26T02:58:55.179Z",
    "lastModified": "2020-10-26T04:04:52.019Z",
    "requester": {
        "reference": "Organization/cdex-example-payer"
    },
    "owner": {
        "reference": "Organization/cdex-example-payer"
    },
    "reasonCode": {
        "text": "Support prior authorization decision-making"
    },
    "reasonReference": {
        "reference": "Claim/cdex-example-claim"
    },
    "input": [
        {
            "type": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/us/davinci-hrex/CodeSystem/hrex-temp",
                        "code": "data-query"
                    }
                ]
            },
            "valueString": "Condition?patient=cdex-example-patient&clinical-status=active"
        }
    ],
    "output": [
        {
            "type": {
                "coding": [
                    {
                        "system": "http://hl7.org/fhir/us/davinci-hrex/CodeSystem/hrex-temp",
                        "code": "data-value"
                    }
                ]
            },
            "valueReference": {
                "reference": "Condition/858"
            }
        }
    ]
}
~~~

###### Step 3 - Fetch Active Conditions

**Request**
~~~
POST [base]Condition/858
~~~

**Request Headers**

~~~
Accept: application/fhir+json
...(other headers)
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
...(other headers)
~~~

**Response Body**

~~~
...todo...
~~~
