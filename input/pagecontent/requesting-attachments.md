{% include draft_content_note.md  content="page" %}

This page documents a FHIR-based approach for requesting attachments for claims or prior authorization from a Provider.  This transaction is used for *solicited*  attachments and uses the combination of a Task-based [CDex Task Attachment Request Profile] to request attachments and the [`$submit-attachment`] operation to submit the attachments to the Payer as documented in the [Sending Attachments] page. It is intended to be compatible with the [X12n 277 and 278 response transactions].

### Non-FHIR Request

In the current state of healthcare data exchange, the Payer requests additional documentation to support a claim or prior authorization using an X12 transaction, fax, portal, or other capabilities.  The Provider can submit these *solicited* attachments using a variety of Non-FHIR methods or can use the [`$submit-attachment`] operation to "push" the attachments directly to the Payer, as documented in the [Sending Attachments] page:

{% include img.html img="request-attachments-nonfhir-sequencediagram.svg" caption="Request Attachment Sequence Diagram For Non-FHIR Requests" %}

### CDex Attachment Request Profile

Using CDex, the Payer can send an attachment request as a FHIR transaction. The attachment request is communicated using the Task-based [CDex Task Attachment Request Profile].  {{ site.data.resources.['StructureDefinition/cdex-task-attachment-request']['description'] }}

See the [CDex Task Attachment Request Profile] formal definition for further details.

### Technical Workflow

The sequence diagram in the Figure below summarizes the basic interaction between the Payer and Provider to request and receive attachments using the combination of the [CDex Task Attachment Request Profile] and [`$submit-attachment`] operation.

{% include img.html img="request-attachments-cdex-sequencediagram.svg" caption="Request Attachment Sequence Diagram Using CDex Task" %}

### Data Elements for Requesting Attachments

The following data elements are needed to associate an attachment to a claim or prior authorization when requesting attachments.  They have been mapped to the [CDex Task Attachment Request Profile] elements and their corresponding x12n 277 and 278 response analogs in the following table:

The mapping between these data elements and the corresponding x12n 277 and 278 response fields is incomplete. It will be added before the STU publication of this guide.
{:.note-to-balloters}

{% include requests-277_278.md %}

The data element mapping table is available as a [CSV](data-element-mapping.csv) and [Excel](data-element-mapping.xlsx) file.

### *Step-by-Step* Solicited Attachment Transaction

In the following sections, A detailed look at an example *Solicited* attachment transaction illustrates how the CDex Task Attachment Request Profile is used to communicate the required data elements to the Provider and how the $submit-attachment is used to communicate the response back to the Payer.
{: .bg-info}

In this scenario, a Provider creates a claim and sends it to the Payer.  The Payer reviews the claim and responds with a request for attachments using the  CDex Attachment Request Profile.  In addition to the information needed to successfully submit and associate the attachments to the claim, the payer supplies the following details about what information is needed to complete the adjudication of the claim:

- LOINC attachment code(s) for the requested documents
- What line numbers on the claim the requested attachment(s) are for

<!-- An endpoint where the Provider submits the attachments is supplied. This endpoint is used by the `[$submit-attachment]` operation and can be used by any HTTP endpoint, not just FHIR RESTful servers. The payer may also indicate whether a Digital Signature is required and whether the attachments need to be submitted in a single transaction. -->

After receiving the attachment request, the Provider collects the documentation and returns them using the `[$submit-attachment]` operation, posting it to the endpoint supplied in the request.


The flow diagram for this transaction is shown in the figure below:

{% include img.html img="cdex-request-attach-claim-flow.svg" caption="CDex Request Attachment Overview for a Claim" %}

#### Payer Requests Attachments for Claim

The Payer POSTs the CDex Task Attachment Request Profile to the Provider endpoint.

~~~
POST [base]/Task
~~~

**Request Body**

##### Task Resource

The optional profile declaration shown below asserts that the resource conforms to the profile and contains all the necessary data elements listed above.

<!-- The request body's various elements are annotated to show how each of the data elements is communicated to the Provider. -->

~~~
 1:  {
  2:      "resourceType": "Task",
  3:      "meta": {
  4:          "profile": [
  5:              "http://hl7.org/fhir/us/davinci-cdex/StructureDefinition/cdex-task-attachment-request"
  6:          ]
  7:      },
~~~

##### Verifying Patient Identity

The following data elements are used to verify patient identity for compliance regulations (such as HIPAA). (How the Provider system verifies the patient is not covered in this guide.) The Payer communicates them in a `contained` Patient resource using the [CDex Patient Demographics Profile]. This contained Patient is referenced in `Task.for.reference` using a fixed reference value of "#patient".:

|Data|HRex Patient Demographics Profile.|
|---|---|
|Member ID or Patient Account No.*|`Patient.identifier`|
|Patient Name|`Patient.name`|
|Patient DOB (optional)|`Patient.birthDate`|
{: .grid}

\* Patient Account No is a Provider assigned identifier and is only present for Prior-Auth use cases.

~~~
  8:      "contained": [
  9:          {
 10:              "resourceType": "Patient",
 11:              "id": "patient",
 12:              "meta": {
 13:                  "profile": [
 14:                      "http://hl7.org/fhir/us/davinci-cdex/StructureDefinition/cdex-patient-demographics"
 15:                  ]
 16:              },
 17:              "identifier": [
 18:                  {
 19:                      "use": "usual",
 20:                      "type": {
 21:                          "coding": [
 22:                              {
 23:                                  "system": "http://hl7.org/fhir/us/davinci-hrex/CodeSystem/hrex-temp",
 24:                                  "code": "UMB",
 25:                                  "display": "Member Number"
 26:                              }
 27:                          ],
 28:                          "text": "Member Number"
 29:                      },
 30:                      "system": "http://example.org/cdex/payer/member-ids",
 31:                      "value": "Member123"
 32:                  }
 33:              ],
 34:              "name": [
 35:                  {
 36:                      "family": "Shaw",
 37:                      "given": [
 38:                          "Amy"
 39:                      ]
 40:                  }
 41:              ],
 42:              "birthDate": "1987-02-20"
 43:          }
 44:      ],
~~~

<!-- ##### Supplying the Claim/PreAuthorization Data

The Payer supplies the necessary Claim/PreAuthorization Data so the Provider can locate the claim.  The data is communicated in a `contained` Claim resource using the [**CDex Claim Profile**](http://build.fhir.org/ig/HL7/davinci-ecdx/StructureDefinition-cdex-claim.html). This contained Claim is referenced in `Task.reasonReference.reference` using a fixed reference value of "#claim".   In addition to required (min=1) elements inherited from the FHIR Base resource, these elements are required:

|Data|CDex Claim Profile element|
|---|---|
|claim/pre-auth id|`Claim.identifer`|
|claim or preauthorization|`Claim.use`|
|date of service|`Claim.supportingInfo.timing[x]`|
|patient member id or patient account no|`Claim.patient.identifier` (note: this is the same  value as `Task.for.identifier`)|
|provider id|`Claim.provider.identifier` (note: this is the same  value as `Task.owner.identifier`)|
{: .grid}
-->



##### Supplying the Tracking ID

The mandatory `Task.identifier` "tracking-id" slice element represents the Payer tracking identifier.  This is an identifier that ties the attachments back to the claim or prior-auth and is echoed back to the Payer when submitting the attachments.  It is often referred to as the “re-association tracking control number”.

~~~
 45:      "identifier": [
 46:          {
 47:              "type": {
 48:                  "coding": [
 49:                      {
 50:                          "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
 51:                          "code": "tracking-id", 
 52:                          "display": "Tracking Id"
 53:                      }
 54:                  ],
 55:                  "text": "Re-Association Tracking Control Number"
 56:              },
 57:              "system": "http://example.org/payer",
 58:              "value": "trackingid123"
 59:          }
 60:      ],
~~~

##### Task *Infrastructure* Elements

These required Task *infrastructural* elements:

- Task.status
- Task.intent
- Task.code

convey what the task is about, its status, and the intent of the request.  The Task.status value of "request" is typical when POSTing the Task-based attachment request. Note that the status will change as the Task at is moves through [different states](http://hl7.org/fhir/task.html#statemachine) in the workflow. Task.intent is fixed to "order".  The Task.code is fixed to “attachment-request” to communicate that the Payer is requesting attachments for a claim or prior-authorization and is expecting they will be submitted using the $submit-attachment operation to the endpoint provided in the “payer-url” input parameter.

~~~
 61:      "status": "requested",
 62:      "intent": "order",
 63:      "code": {
 64:          "coding": [
 65:              {
 66:                  "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
 67:                  "code": "attachment-request"
 68:              }
 69:          ],
 70:          "text": "Attachment Request"
 71:      },
~~~


##### Identifying the Payer, Provider, and Patient

Business identifiers are used to identify the Patient, the Payer, and the Provider who submitted the claim.  The attachment request will be directed to the same Provider who submitted the claim or prior authorization. As discussed above, the Patient identifier is in the contained Patient resource which is referenced by the Task.for element. These IDs are echoed back to the Payer when submitting the attachments. (note the various Task dates as well)

|Actor|CDex Claim Profile element|
|---|---|
|payer ID|`Task.reasonReference.identifier`|
|provider ID|`Task.owner.identifier`|
|patient member ID or Patient Account No|(contained)Patient.identifier|
{: .grid}

~~~
 72:      "for": {
 73:          "reference": "#patient"
 74:      },
 75:      "authoredOn": "2022-06-17T16:16:06Z",
 76:      "lastModified": "2022-06-17T16:16:06Z",
 77:      "requester": {
 78:          "identifier": {
 79:              "system": "http://example.org/cdex/payer/payer-ids",
 80:              "value": "Payer123"
 81:          }
 82:      },
 83:      "owner": {
 84:          "identifier": {
 85:              "system": "http://hl7.org/fhir/sid/us-npi",
 86:              "value": "9941339108"
 87:          }
 88:      },
~~~

##### Claim Information

The Task communicates whether the attachments are for a Claim or Prior Authorization and the Claim or Prior Authorization ID is identified by its business Identifier. 

|Data|CDex Claim Profile element|
|---|---|
|Claim or Prior Authorization|`Task.reasonCode`|
|Claim or Prior Authorization ID|`Task.reasonReference.identifier`|
{: .grid}

~~~
 89:      "reasonCode": {
 90:          "coding": [
 91:              {
 92:                  "system": "http://hl7.org/fhir/claim-use",
 93:                  "code": "claim",
 94:                  "display": "Claim"
 95:              }
 96:          ],
 97:          "text": "claim"
 98:      },
 99:      "reasonReference": {
100:          "identifier": {
101:              "system": "http://example.org/cdex/payer/claim-ids",
102:              "value": "Claim123"
103:          }
104:      },
~~~

##### Attachment Due Date

The Due Date for attachment is communicated in the `Task.restriction.period`  element. Note that `Task.restriction.period.end` is the due date representing the time by which the attachments should be submitted.

~~~
105:      "restriction": {
106:          "period": {
107:              "end": "2022-06-21"
108:          }
109:      },
~~~

##### Communicating What Attachments are Needed

The payer supplies the [LOINC attachment codes] to communicate what attachments are needed.  Line item numbers may also be supplied to match the attachment to a line item in the claim or pre-auth.  This information is represented in the `Task.input` "code". The code snippet below shows a single request for line item 1 using a LOINC attachment code.  The codes and line items are echoed back to the Payer when submitting the attachments.


~~~
110:      "input": [
111:          {
112:              "type": {
113:                  "coding": [
114:                      {
115:                          "system": "http://hl7.org/fhir/us/davinci-hrex/CodeSystem/hrex-temp",
116:                          "code": "data-code"
117:                      }
118:                  ]
119:              },
120:              "valueCodeableConcept": {
121:                  "coding": [
122:                      {
123:                          "system": "http://loinc.org",
124:                          "code": "11506-3",
125:                          "display": "Progress note"
126:                      }
127:                  ],
128:                  "text": "Progress note"
129:              },
130:              "extension": [
131:                  {
132:                      "url": "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-serviceLineNumber",
133:                      "valuePositiveInt": 1
134:                  }
135:              ]
136:          },
~~~

##### Communicating the Signature Requirements

 This Task.input "signature-flag" may be used to indicate that the attachments must be signed. See the [Signatures] and [Sending Attachments] page for more information about using Signatures in CDex.

~~~
137:          {
138:              "type": {
139:                  "coding": [
140:                      {
141:                          "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
142:                          "code": "signature-flag"
143:                      }
144:                  ]
145:              },
146:              "valueBoolean": false
147:          },
~~~

##### Supplying the $submit-attachment Operation Endpoint

The Payer supplies the url endpoint as a Task input parameter. The Provider System will use this information as the endpoint for the `[$submit-attachment]` Operation.

<!-- If no url endpoint is supplied the attachments are provided either as references or contained Task resources and the requester needs to poll/subscribe to the Task to retrieve when done. -->

~~~
148:          {
149:              "type": {
150:                  "coding": [
151:                      {
152:                          "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
153:                          "code": "payer-url"
154:                      }
155:                  ]
156:              },
157:              "valueUrl": "http://example.org/cdex/payer/$submit-attachment"
158:          },
~~~

##### Date of Service for the Claim

A Task.input element represents the date of service or starting date of the service for the claim or prior authorization.


~~~
159:          {
160:              "type": {
161:                  "coding": [
162:                      {
163:                          "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
164:                          "code": "service-date"
165:                      }
166:                  ]
167:              },
168:              "valueDate": "2022-06-13"
169:          }
170:      ]
171:  }
~~~


#### Provider Submits Solicited Attachments

The Provider POSTs the `[$submit-attachment]` operation and its payload to the Payer's endpoint.  As stated above, the Payer endpoint is communicated to the Payer in the CDex Task Attachment Request Profile. The same data elements sent in the request for attachments are echoed back when submitting the attachments using the `[$submit-attachment]` operation. The mappings between the corresponding data communicated in the CDex Request Attachment Profile elements and the `[$submit-attachment]` parameters are shown in the table below:

{% include attachments_to_requests.md %}

These parameters are documented in more detail below.

**Request**

~~~
POST [base]/$submit-attachment
~~~

**Request Body**

##### The Submit Attachment Operation Payload

The attachments along with the metadata needed to associate the attachment to the Claim or Pre-Auth are in the $submit-attachments payload, a [Parameters] resource.

~~~
 1:  {
 2:      "resourceType": "Parameters",
 3:      "parameter": [
~~~

##### Tracking ID and Indicating a Claim or Prior Authorization
The Tracking ID is an identifier that ties the attachments back to the claim or pre-auth.  It is often referred to as the “re-association tracking control number”.  The operation needs to indicate whether the attachments are for claim or prior-authorization. These data elements are taken from the CDex request as follows:

|Data Element|CDex Request Element|CDex #submit-attachment Parameter|
|---|---|---|
|TrackingID|Task.identifier|TrackingId|
|Use|Task.reasonCode|AttachTo|
{:.grid}

~~~
  4:          {
  5:              "name": "TrackingId",
  6:              "valueString": "targetid123"
  7:          },
  8:          {
  9:              "name": "AttachTo",
 10:              "valueCode": "claim"
 11:          },
~~~    

##### Identifying the Payer, Provider, Organization, and Patient

As documented above, business identifiers are used to identify the Patient, the Payer, and the Provider who submitted the Claim. These should be the same as communicated in the request.  The NPI should be used for the Provider and Provider Organization IDs.

|Data Element|CDex Request Element|CDex #submit-attachment Parameter|
|---|---|---|
|Payer URL|"payer-url"Task.input|(operation endpoint)|
|Organiztion ID|-|OrganizationId|
|Provider ID|Task.owner.identifier|ProviderId|
|Member ID|Patient.identifier|MemberId|
{:.grid}

~~~
 12:          {
 13:              "name": "PayerId",
 14:              "valueIdentifier": {
 15:                  "system": "http://example.org/cdex/payer-ids",
 16:                  "value": "payer123"
 17:              }
 18:          },
 19:          {
 20:              "name": "OrganizationId",
 21:              "valueIdentifier": {
 22:                  "system": "http://hl7.org/fhir/sid/us-npi",
 23:                  "value": "1407071236"
 24:              }
 25:          },
 26:          {
 27:              "name": "ProviderId",
 28:              "valueIdentifier": {
 29:                  "system": "http://hl7.org/fhir/sid/us-npi",
 30:                  "value": "9941339108"
 31:              }
 32:          },
 33:          {
 34:              "name": "MemberId",
 35:              "valueIdentifier": {
 36:                  "system": "http://example.org/cdex/member-ids",
 37:                  "value": "234567"
 38:              }
 39:          },
~~~

##### The Service Date

The service date parameter is taken from the “service-date” Task.input element in the CDex Attachment request.

~~~
40:          {
 41:              "name": "ServiceDate",
 42:              "valueDate": "2022-06-16"
 43:          },
~~~

##### Supply the Requested Attachments for Each Line Item and Code

The Requested Attachments and the corresponding coded requests and/or line item numbers are communicated back as Attachment parameter parts. The actual attachment is communicated as a FHIR resource in the Attachment.content parameter part, often a [DocumentReference] containing Base64 encoded FHIR and non-FHIR documents.  What attachments are returned are determined by the [LOINC attachment codes] in the CDex Attachment requests in Task.input "code" slice.   Line item numbers associated with a requested item are communicated in the Attachment.LineItem parameter part.

 <!-- What attachments are returned are determined by the CDex Attachment requests in `Task.input` "code" or "query" slices.  These may be coded in LOINC or non-LOINC, free text, or FHIR RESTful search syntax queries.  Codes are represented in the Attachment.code parameter part in the `valueCodeableConcept.Coding` field and free text or FHIR RESTful search syntax queries are represented in `valueCodeableConcept.text` field. Line item numbers associated with a requested item are communicated in the Attachment.LineItem parameter part.
  -->

|Data Element|CDex Request Element|CDex #submit-attachment Parameter|
|---|---|---|
|line item(s)|“code”Task.input.extension|Attachment.LineItem|
|LOINC Attachment Code|“code”Task.input|Attachment.Code|
|Attachments|-|Attachment.content
{:.grid}

~~~
 44:          {
 45:              "name": "Attachment",
 46:              "part": [
 47:                  {
 48:                      "name": "LineItem",
 49:                      "valueString": "1"
 50:                  },
 51:                  {
 52:                      "name": "Code",
 53:                      "valueCodeableConcept": {
 54:                          "coding": [
 55:                              {
 56:                                  "system": "http://loinc.org",
 57:                                  "code": "11506-3",
 58:                                  "display": "Progress note"
 59:                              }
 60:                          ],
 61:                          "text": "Progress note"
 62:                      }
 63:                  },
 64:                  {
 65:                      "name": "Content",
 66:                      "resource": {
 67:                          "resourceType": "DocumentReference",
 68:                          "id": "cdex-example-doc1",
 69:                          "status": "current",
 70:                          "type": {
 71:                              "coding": [
 72:                                  {
 73:                                      "system": "http://loinc.org",
 74:                                      "code": "11506-3",
 75:                                      "display": "Progress note"
 76:                                  }
 77:                              ],
 78:                              "text": "Progress note"
 79:                          },
 80:                          "category": [
 81:                              {
 82:                                  "coding": [
 83:                                      {
 84:                                          "system": "http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category",
 85:                                          "code": "clinical-note",
 86:                                          "display": "Clinical Note"
 87:                                      }
 88:                                  ],
 89:                                  "text": "Clinical Note 1"
 90:                              }
 91:                          ],
 92:                          "date": "2021-12-03T18:30:56-08:00",
 93:                          "content": [
 94:                              {
 95:                                  "attachment": {
 96:                                      "contentType": "application/pdf",
 97:                                      "data": ">>>>>>Base64 here<<<<<<",
 98:                                      "title": "sample1.pdf"
 99:                                  }
100:                              }
101:                          ]
102:                      }
103:                  }
104:              ]
105:          }
106:      ]
107:  }
~~~


### Complete *Solicited* Attachment Transaction

The complete *solicited* attachment transaction using the combination of a Task-based CDex Task Attachment Request Profile to request attachments and the [`$submit-attachment`] operation to submit the attachments to the Payer is shown below:

{% include examplebutton_default.html example="task-scenario-8.md" b_title = "Click Here To See FHIR Based Solicited Attachment Example" %}

### Signatures

Refer to the [Signatures section](sending-attachments.html#signatures) in the Sending Attachments page.

{% include link-list.md %}