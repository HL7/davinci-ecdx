<!-- ---
tags: CDEX
title: Draft Rewritten Attachments Page 
---


# Draft Rewritten Attachments Page  -->

This page documents a FHIR based approach for exchanging *attachments* for claims or prior authorization directly to a Payer.

### Attachments (additional information) for Claims or Prior Authorization

Today claims typically come through [X12 transactions] or portal submissions. Payers may need additional information - referred to as "attachments" - from a Provider to determine if the service being billed (claim) or requested (prior authorization) is supported by medical benefits, or by policy benefits. In contrast to the Direct Query and Task Based approach, the CDex Attachments transaction is not a response to a CDex FHIR-based request for clinical/administrative data.  However, the additional information to support these claims or prior authorizations *may* be requested via a non-CDex FHIR based request such as an X12 transactions, fax, portal, or other capabilities.

Attachments for Claims or Prior Authorization can be divided into *solicited* and *unsolicited* workflows. The Sections below document the differences and similarities between these workflows and CDex transactions can be used for each. 

### *Unsolicited* Attachments

For an *unsolicited* attachment the Provider will submit additional information using CDex Attachments to support a claim or prior authorization based on Payer predefined rules without any type of request.  <span class="bg-success" markdown="1">The attachments may be submitted *before, at the same time as, or after* the claim or pre-authorization has been supplied to the Payer.</span><!-- new-content --> The attachment is then associated with the claim or prior authorization. The flow diagram for this transaction is shown in the figure below:


{% include img.html img="unsolicited-flow.svg" caption="Unsolicited Attachments Flow Diagram" %}

#### `$submit-attachment` Operation

<span class="bg-success" markdown="1">This guide defines a FHIR [Operation] for exchanging attachments using [`$submit-attachment`].</span><!-- new-content --> This operation replace the X12n 275 transaction. The operation accepts the clinical attachments and the necessary information needed to associate them to the claim or prior authorization, and returns a transaction layer http response. See the [`$submit-attachment`] operation definition and examples below for further details.


#### FHIR Technical Workflow


As shown in the figure 7 below, the attachments are “pushed” using the [`$submit-attachment`] operation directly to the Payer or an Intermediary.

<div class="bg-success" markdown="1">

{% include img.html img="attachments-sequencediagram.svg" caption="Figure 7" %}


1. Data Source assembles attachments and the meta data to associate the attachments to a claim or prior authorization
1. Data Source invokes [`$submit-attachment`] operation to submit attachments to Payer
1. Payer responds with an http transactional layer response either accepting or rejecting the transaction.
   - The Payer **SHOULD** return an informational OperationOutcome with the http accept response if the attachments can not be associated with a *current* claim or prior authorization and are being held for association with a *future* claim or prior authorization.  An OperationOutcome example is used in Scenario 1b below.
2. The Payer associates the attachments to the claim or prior authorization, and processes the claim.

</div><!-- new-content -->

#### Example Scenarios

1.	Additional information based on a set of pre-defined rules by the Payer or in state mandates without a specific request.
2.	Additional information for a claim that a Provider believes the Payer will need for processing.
3.	A Provider is under review and required to provide additional information for all claims.


In all of these cases, the Payer will require a trading partner agreement for sending attachments based on predefined rules.
{:.bg-warning}

#### Examples

In the following examples, a Provider creates a claim and sends supporting CCDA documents as *unsolicited attachments* using the FHIR operation, [`$submit-attachment`]:

`POST [base]/$submit-attachment`

##### Scenario 1a: CCDA Document Attachments

- Based on a set of pre-defined rules set by the Payer, Provider submits CCDA Documents as additional information for a claim.
  - Typically, when the attachments are CCDA documents as in this scenario, they are already digitally signed and supply provenance information. Therefore, FHIR signatures and external Provenance resources are not needed.
- Provider knows the Payer's endpoint for sending attachments.  Note that the [`$submit-attachment`] operation can be used by any HTTP endpoint, not just FHIR RESTful servers.
- An unsolicited workflow implies that the *Provider* assigns the claim and line item identifiers upon claim generation.
- <span class="bg-success" markdown="1">Payer associates attachments to the claim.</span><!-- new-content -->

{% include examplebutton_default.html example="attachment-scenario1a.md" b_title = "Click Here To See Example CCDA Document Attachments" %}

<div class="bg-success" markdown="1">

#### Scenario 1b: CCDA Document Attachments Submitted *Prior* to Claim

This Scenario is the same as Scenario 1a above except that the attachments are submitted *prior* to the claim.  The Payer accepts the attachments and returns an OperationOutcome informing the Provider system that the attachments are waiting for the claim.

{% include examplebutton_default.html example="attachment-scenario1b.md" b_title = "Click Here To See Example CCDA Document Attachments" %}

</div><!-- new-content -->



### *Solicited* Attachments

For a *solicited* attachment the Provider will submit additional information using to support a claim or prior authorization *in response to*  a Payor's request for additional documentation.  The submnitted attachments are then associated with the claim or prior authorization. The flow diagram for this transaction is shown in the figures below:


{% include img.html img="solicited-claim-flow.svg" caption="Solicited Attachments for a Claim" %}


{% include img.html img="solicited-prior-auth-flow.svg" caption="Solicited Attachments for a Prior Authorization" %}

### non-FHIR Request

When the Payer sends a portal, letter, X12n 277 or 278 response message or other type of request to the Provider for additional information to support a claim or prior authorization. Using the CDex the `$submit-attachment` Operation defined above, the additional documentation can be sent from the Provider to the Payer.  The attachments are then associated with the claim or prior authorization.

{% include img.html img="request-attachments-nonfhir-sequencediagram.svg" caption="Request Attachment Sequence Diagram Using Non-FHIR Request" %}

### Request Attachment Using CDEX and FHIR

Using CDex, the Payer can elect to send an attachment request as a FHIR transaction. The attachment request is communicated using CDEX Task based approach and the response through the CDex $submit-operation.  These FHIR based transactions are designed to be compliant with HIPAA Attachment rules for CMS and can replace the X12n 278response, 277 and 275 messages. ( Bob to edit ). 

{% include img.html img="request-attachments-cdex-sequencediagram.svg" caption="Request Attachment Sequence Diagram Using CDEX Task" %}

#### The CDEX Attachment Request Profile

The CDEX Attachment Request Profile is a specialization of the CDEX Task Profile for requesting attachments. The CDEX Task Profile is used communicate the request for a variety of use cases including requesting attachments, but The CDEX Attachment Request is defined specifically for requesting attachments for Claims and Prior Authorization that is compatible with existing X12n 277 and 278 response transactions. It communicates the necesary data elements for requesting attachments and associating them to a claim or prior authorization: 
##### Data Elements Needed to Request Attachments

It has been determined that these X12 + other elements are need to request attachments:

No.|Data Element|X12 277/278 ID|CDEX
---|---|---
1 | Payer ID - should be a business ID -requester.reference| NM108  |
2 | Payer URL| - | "code" Task.input
3 |  Claim/PreAuth ID (Provider or Payer Assigned) | -  | Task.reasonReference.identifier
4 |  Tracking ID (Provider or Payer Assigned)| REF02 | Task.identifier
5|   line item # nos | |  "code" Task.input.extension 
6 | Attachment LOINCs |  STC01-02  |  "code" Task.input
7|  Due Date|  DPT02  | Task.restriction.period
8|  Date of Service (encounter info) | DTP03  | "service-date" Task.input
9 |  Member ID (patient info)| X2100D NM | Patient.identifier
10 |  Patient Name (patient info) |  X2100D NM103-7  | Patient.name
11 |   Patient Account No. *PreAuth Only* (patient info) |CLM01(837) |  Patient.identifier
12 |   DOB *Optional* (patient info  |)X12  | Patient.birthDate
{: .grid}


[**Formal Views of The CDEX Attachment Request Profile Content Design 1 (contained Claim)**](http://build.fhir.org/ig/HL7/davinci-ecdx/StructureDefinition-cdex-task-attachment-request.html)

[**Formal Views of The CDEX Attachment Request Profile Content Design 2(reasonCode and Service-date input)**](http://build.fhir.org/ig/HL7/davinci-ecdx/StructureDefinition-cdex-task-attachment-request2.html)


### Example Attachment Request

In the following sections, An example CDEX Attachment Request is looked at in detail to document how this profile is used to communicate the required data elements and how they are used in $submit-attachment response back to the payer.
{: .bg-info}

In this example, a Provider creates a claim and sends to the Payer.  The Payer responds with request for attachments using the The CDEX Attachment Request Profile. This replaces the X12n 277 transactions.  In addition to the various identifiers needed to associate the attachments to the claim, the payer supplies details about what information is need to complete the adjudication of the claim:

- LOINC code(s) for the requested attachment
- What line numbers on the claim the requested attachment(s) are for

The payer also indicates whether a Digital Signature is required and supplies an endpoint where the Provider should submit the attachments. After receiving the attachment request, the Provider collects the documentation and returns them using the `$submit-attachment operation` which replaces the X12n 275 transaction. The flow diagram for this transaction is shown in the figure below:

{% include img.html img="cdex-request-attach-claim-flow.svg" caption="CDex Request Attachment Overview for a Claim" %}

#### Step 1: POST a CDEX Attachment Request to the Provider Endpoint

~~~
POST [base]/Task
~~~

##### Request Body

<!-- The request body's various elements are annotated to show how each of the data elements is communicated to the Provider. -->

###### Declaring the Profile and Work Queue Hints

The Provider receives the Attachments request.  The profile declaration asserts that the resource conforms to the profile and contains all the necessary data elements listed above.  Work Queue Hints are and optional element are displayed here to show how they can be used by a Payer in a claims attachment request.

~~~
  1:  {
  2:      "resourceType": "Task",
  3:      "meta": {
  4:          "profile": [
  5:              "http://hl7.org/fhir/us/davinci-cdex/StructureDefinition/cdex-task-attachment-request2"
  6:          ],
  7:          "tag": [
  8:              {
  9:                  "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
 10:                  "code": "claims-processing"
 11:              }
 12:          ]
 13:      },
~~~

###### Verifying Patient Identity

The following data elements are used to verify patient identity for compliance regulations (such as HIPAA). (How the Provider system verify the patient in not covered in this guide.) The Payer communicates them in a `contained` Patient resource using the [**CDex Patient Demographics Profile**](http://build.fhir.org/ig/HL7/davinci-ecdx/StructureDefinition-cdex-patient-demographics.html).  This contained Patient is referenced in `Task.for.reference` using the a fixed reference value of "#patient".:

|Data|HRex Patient Demographics Profile.|
|---|---|
|Member ID or Patient Account No.|`Patient.identifier`|
|Patient Name|`Patient.name`|
|Patient DOB (optional)|`Patient.birthDate`|
|Sex |`Patient.gender`|
{: .grid}

~~~
 14:      "contained": [
 15:          {
 16:              "resourceType": "Patient",
 17:              "id": "patient",
 18:              "meta": {
 19:                  "profile": [
 20:                      "http://hl7.org/fhir/us/davinci-cdex/StructureDefinition/cdex-patient-demographics"
 21:                  ]
 22:              },
 23:              "identifier": [
 24:                  {
 25:                      "use": "usual",
 26:                      "type": {
 27:                          "coding": [
 28:                              {
 29:                                  "system": "http://hl7.org/fhir/us/davinci-hrex/CodeSystem/hrex-temp",
 30:                                  "code": "UMB",
 31:                                  "display": "Member Number"
 32:                              }
 33:                          ],
 34:                          "text": "Member Number"
 35:                      },
 36:                      "system": "http://example.org/cdex/payer/member-ids",
 37:                      "value": "Member123"
 38:                  },
 39:                  {
 40:                      "use": "usual",
 41:                      "type": {
 42:                          "coding": [
 43:                              {
 44:                                  "system": "http://hl7.org/fhir/us/carin-bb/CodeSystem/C4BBIdentifierType",
 45:                                  "code": "pat",
 46:                                  "display": "Patient Account Number"
 47:                              }
 48:                          ],
 49:                          "text": "Patient Account Number"
 50:                      },
 51:                      "system": "http://example.org/cdex/provider/patient-ids",
 52:                      "value": "PA-123"
 53:                  }
 54:              ],
 55:              "name": [
 56:                  {
 57:                      "family": "Shaw",
 58:                      "given": [
 59:                          "Amy"
 60:                      ]
 61:                  }
 62:              ],
 63:              "gender": "female",
 64:              "birthDate": "1987-02-20"
 65:          }
 66:      ],
~~~

<!-- ##### Supplying the Claim/PreAuthorization Data

The Payer supplies the necessary Claim/PreAuthorization Data so the Provider can locate the claim.  The data is communicated in a `contained` Claim resource using the [**CDex Claim Profile**](http://build.fhir.org/ig/HL7/davinci-ecdx/StructureDefinition-cdex-claim.html). This contained Claim is referenced in `Task.reasonReference.reference` using the a fixed reference value of "#claim".   In addition to required (min=1) elements inherited from the FHIR Base resource, these elements are required:

|Data|CDex Claim Profile element|
|---|---|
|claim/pre-auth id|`Claim.identifer`|
|claim or preauthorization|`Claim.use`|
|date of service|`Claim.supportingInfo.timing[x]`|
|patient member id or patient account no|`Claim.patient.identifier` (note: this is the same  value as `Task.for.identifier`)|
|provider id|`Claim.provider.identifier` (note: this is the same  value as `Task.owner.identifier`)|
{: .grid}
-->



###### Supplying the Tracking ID

The mandatory `Task.identifier` "tracking-id" slice element represents the payers tracking identifier.  This is an identifier that ties the attachments back to the claim or pre-auth and is echoed back to the Payer when submitting the attachments.  It is often referred to as the “re-association tracking control number”.

~~~
 67:      "identifier": [
 68:          {
 69:              "type": {
 70:                  "coding": [
 71:                      {
 72:                          "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
 73:                          "code": "tracking-id",
 74:                          "display": "Tracking Id"
 75:                      }
 76:                  ],
 77:                  "text": "Re-Association Tracking Control Number"
 78:              },
 79:              "system": "http://example.org/payer",
 80:              "value": "trackingid123"
 81:          }
 82:      ],
~~~

###### Task *Infrastructure* Elements

These required Task *infrastructural* elements:

- Task.status
- Task.intent
- Task.code

convey what the task is about, its status and the intent of the request.  The values shown below are typical for the attachment request. Note that the status will change as the Task at is moves through [different states](http://hl7.org/fhir/task.html#statemachine) in the workflow. 

~~~
 83:      "status": "requested",
 84:      "intent": "order",
 85:      "code": {
 86:          "coding": [
 87:              {
 88:                  "system": "http://hl7.org/fhir/us/davinci-hrex/CodeSystem/hrex-temp",
 89:                  "code": "data-request"
 90:              }
 91:          ],
 92:          "text": "Data Request"
 93:      },
~~~


###### Identifying the Payer, Provider and Patient

Business idenfiers are used to identify the Payer, Patient and if present  the Provider ID  which is an optional element in the profile. Note that the Patient identifier is in both Task profile and the contained Patient profile. These IDs are echoed back to the Payer when submitting the attachments. (note the various Task dates as well)

|Actor|CDex Claim Profile element|
|---|---|
|payer ID|`Task.reasonReference.identifier`|
|provider ID (optional)|`Task.owner.identifier`|
|patient member ID or patient account no|`Task.for.identifier` and/or`Task.for.reference`|
{: .grid}

~~~
 94:      "for": {
 95:          "reference": "#patient",
 96:          "identifier": {
 97:              "system": "http://example.org/cdex/payer/member-ids",
 98:              "value": "Member123"
 99:          }
100:      },
101:      "authoredOn": "2022-06-17T16:16:06Z",
102:      "lastModified": "2022-06-17T16:16:06Z",
103:      "requester": {
104:          "identifier": {
105:              "system": "http://example.org/cdex/payer/payer-ids",
106:              "value": "Payer123"
107:          }
108:      },
109:      "owner": {
110:          "identifier": {
111:              "system": "http://hl7.org/fhir/sid/us-npi",
112:              "value": "9941339108"
113:          }
114:      },
~~~

##### Claim Information

The Task communicates whether the attachments are for a Claim or Prior Authorization and  the Claim or Prior Authorization ID is identified by its business Identifier. 

|Data|CDex Claim Profile element|
|---|---|
|Claim or Prior Authorization|`Task.reasonCode`|
|Claim or Prior Authorization ID|`Task.reasonReference.identifier`|
{: .grid}

~~~
115:      "reasonCode": {
116:          "coding": [
117:              {
118:                  "system": "http://hl7.org/fhir/claim-use",
119:                  "code": "claim",
120:                  "display": "Claim"
121:              }
122:          ],
123:          "text": "claim"
124:      },
125:      "reasonReference": {
126:          "identifier": {
127:              "system": "http://example.org/cdex/payer/claim-ids",
128:              "value": "Claim123"
129:          }
130:      },
~~~

##### Communicating Attachments Due Date

The Due Date for attachment is communicated in the `Task.restriction.period`  element. Note that `Task.restriction.period.end` is the due date representing the time by which the attachments should be submitted.

~~~
131:      "restriction": {
132:          "period": {
133:              "end": "2022-06-21"
134:          }
135:      },
~~~

##### Communicating What Attachments are Needed

The payer supplies either LOINCs or non-coded data a Task input parameters to indicate what attachments are needed.  Line item numbers may also be supplied to match the attachment to a line item in the claim or pre-auth.  This information is represented in the `Task.input` "code" or "query" slices.  Note that free text requests use the "code" slice and FHIR search based syntax the "query" slice.  The code snippet below shows a single request for line item 1 using a LOINC attachment code.  The codes and line items are echoed back to the Payer when submitting the attachments.


~~~
136:      "input": [
137:          {
138:              "type": {
139:                  "coding": [
140:                      {
141:                          "system": "http://hl7.org/fhir/us/davinci-hrex/CodeSystem/hrex-temp",
142:                          "code": "data-code"
143:                      }
144:                  ]
145:              },
146:              "valueCodeableConcept": {
147:                  "coding": [
148:                      {
149:                          "system": "http://loinc.org",
150:                          "code": "34117-2",
151:                          "display": "History and physical note"
152:                      }
153:                  ],
154:                  "text": "History and Physical"
155:              },
156:              "extension": [
157:                  {
158:                      "url": "http://hl7.org/fhir/us/davinci-pas/StructureDefinition/extension-serviceLineNumber",
159:                      "valuePositiveInt": 1
160:                  }
161:              ]
162:          },
~~~

###### Communicating the Signature Requirements

See the [Signature page](#) for more information

~~~
163:          {
164:              "type": {
165:                  "coding": [
166:                      {
167:                          "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
168:                          "code": "signature-flag"
169:                      }
170:                  ]
171:              },
172:              "valueBoolean": true
173:          },
~~~

###### Indicating the $submit-attachment Operation Endpoint

When the Payer supplies the url endpoint as a Task input parameter, it triggers the Provider System to use it as the endpoint for the $submit-attachment Operation defined above.  If no url endpoint is supplied the attachments are provided either as references or contained Task resource and the requester needs to poll/subscribe to the Task to retrieve when done.

~~~
174:          {
175:              "type": {
176:                  "coding": [
177:                      {
178:                          "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
179:                          "code": "payer-url"
180:                      }
181:                  ]
182:              },
183:              "valueUrl": "http://example.org/cdex/payer/$submit-attachment"
184:          },
~~~

###### Date of Service for the Claim

A Task.input element represents the date of service or starting date of the service for the claim or prior authorization.


~~~
185:          {
186:              "type": {
187:                  "coding": [
188:                      {
189:                          "system": "http://hl7.org/fhir/us/davinci-cdex/CodeSystem/cdex-temp",
190:                          "code": "service-date"
191:                      }
192:                  ]
193:              },
194:              "valueDate": "2022-06-13"
195:          }
196:      ]
197:  }
~~~


#### Step 2 - Submit Solicited Attachments to Payer endpoint

As stated above, the Payer endpoint is communicated to the Payer using the Task.input element.  This endpoint is the target for the $submit-attachment operation when the provider sends the requested attachment to the payer.  The following table maps the information communicated in the CDex Attachment Request to the corresponding parameter in the body of $submit-attachment operation:


|Parameter|CDex Request Attachment Element|X12 Element|Description|
|---|---|---|---|
|foo|bar|baz|biz|
{: .grid}


These parameters are documented in more detail below.


**Request**

~~~
POST [base]/$submit-attachment
~~~


**Request Body**

##### Use the `$submit-attachment` Operation Defined Above

The attachments along with the metadata needed to associate the attachment to the Claim or Pre-Auth are in the $submit-attachments payload, a Parameters resource.

~~~yaml=
resourceType: Parameters
parameter:
~~~

##### Echoing back the Tracking ID and whether is a claim or preaut
These data elements are taken from `Task.identifier` "tracking-id" slice and contained `Claim.use` elements respectively.

~~~yaml=+
  - name: TrackingId
    valueString: targetid123
  - name: AttachTo
    valueCode: claim
~~~    

##### Supplying the Payer, Provider, Organization and Patient ids

The Payer and Patient IDs should be the same as communicated in the request.  See above for details. For the Provider and Organization IDs the NPI should be used if not supplied in the request.

~~~yaml=+
  - name: PayerId
    valueIdentifier:
      system: 'http://example.org/cdex/payer-ids'
      value: payer123
  - name: OrganizationId
    valueIdentifier:
      system: 'http://hl7.org/fhir/sid/us-npi'
      value: '1407071236'
  - name: ProviderId
    valueIdentifier:
      system: 'http://hl7.org/fhir/sid/us-npi'
      value: '9941339108'
  - name: MemberId
    valueIdentifier:
      system: 'http://example.org/cdex/member-ids'
      value: '234567'
~~~

##### Echo back the Service date

The service date taken from the contained `Claim.supportingInfo.timingDate` element in the CDEX Attachment request.

~~~yaml=+
  - serviceDate: '2022-06-16'
~~~

##### Supply the Requested Attachments for Each Line Item and Code

the Requested Attachments and the corresponding coded or non-coded requests and/or line item numbers are communicated back as Attachment parameter parts. The actual attachment is communicated as a FHIR resource in the Attachment.content parameter part, often a DocumentReference containing Base64 encoded FHIR and non-FHIR documents. What attachments are returned are determined by the CDEX Attachment requests in `Task.input` "code" or "query" slices.  These may be coded in LOINC or non-LOINC, free text, or FHIR RESTful search syntax queries.  Codes are represented in the Attachment.code parameter part in the `valueCodeableConcept.Coding` field and free text or FHIR RESTful search syntax queries are represented in `valueCodeableConcept.text` field. Line item numbers associated with a requested item are communicated in the Attachment.LineItem parameter part.
 

~~~yaml=+
  - name: Attachment
    part:
      - name: LineItem
        valueString: '1'
      - name: Code
        valueCodeableConcept:
          - coding:
                system: 'http://loinc.org'
                code: 34117-2
      - name: Content
        resource:
          - resourceType: DocumentReference
            id: cdex-example-doc1
            status: current
            type:
              coding:
                - system: 'http://loinc.org'
                  code: 34117-2
                  display: History and physical note
              text: History and Physical
            category:
              - coding:
                  - system: >-
                      http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category
                    code: clinical-note
                    display: Clinical Note
                text: Clinical Note 1
            date: '2021-12-03T18:30:56-08:00'
            content:
              - attachment:
                  contentType: application/pdf
                  data: '>>>>>>Base64 here<<<<<<'
                  title: sample1.pdf
~~~


**Full example Task request in JSON:**

<!--{%raw%} {%gist Healthedata1/9bc715de1ebab524a95b4c679e5894fe%}{%endraw%} -->


**Full example Response in JSON ($submit-attachment Parameters Payload):**

<!--{%raw%}{%gist Healthedata1/ff729585f6d369e821d90854813c9b97%}{%endraw%} -->




---

### Signatures

Some data consumers may require that the data they receive are signed. When performing CDex Attachments transactions and signatures are required, the following general rules apply:

- The signature **SHALL** represent a *human provider* signature on resources attesting that the information is true and accurate.
- The returned object is either already inherently signed (for example, a wet signature on a PDF or a digitally signed CCDA) or it **SHALL** be transformed into a signed [FHIR Document](http://hl7.org/fhir/documents.html) and `Bundle.signature`  **SHALL** be used to exchange the signature.

#### The Data Consumer Requirements

When an electronic or digital signature is required for CDex Attachments, the Data Consumer **SHALL**:

- *Pre-negotiate* the signature requirement with the organization representing the Data Source.
   - If the signature requirement is pre-negotiated, it **SHALL** be assumed that *all* attachments will be signed.
   - Conversely, it **SHOULD** be assumed that no CDex Attachments transaction will be signed unless there exists a pre-negotiated agreement
   - Based on the agreement, *electronic* or *digital* signatures **MAY** be used  
- Follow the documentation in the [Signatures] page for validating signatures.


#### Data Source Requirements

Refer to the [Data Source/Responder Requirements](task-based-approach.html#data-sourceresponder-requirements) section in the Task Based Approach to signatures.

#### Example: *Signed* FHIR Resource Attachments

- This example is the same as Scenario 1 above except that the attachment is a FHIR resource and a FHIR digital signature is required.
  - Unlike Scenario 1 which uses DocumentReference resource to index the CCDA attachment, FHIR resources representing the clinical/administrative data are transformed into a FHIR Document bundle and the bundle is digitally signed.
- See the [Signatures] page for complete examples on how the signature was created.

{% include examplebutton_default.html example="attachment-scenario2.md" b_title = "Click Here To See Example *Signed* FHIR Resource Attachments" %}


### How Does CDex fit into the DaVinci Burden Reduction/PAS Workflow


In PAS, the expection is that a final decision is generated immediately and automatically in the majority of cases.  The flow below depicts the cases where the result is "pended" and additional data is needed.  In these cases the Payer or Provider may elect to use a CDex Transaction to request or submit attachments.
{: .bg-info}


There is no direct intersection with [DTR/CRD workflow](http://hl7.org/fhir/us/davinci-dtr/index.html). In DTR, the [Q/QR is held] until any [required Tasks](http://hl7.org/fhir/us/davinci-dtr/specification__behaviors__task_creation.html) are completed and the question is answered which not compatible with the CDex attachments workflow.
{: .bg-warning}

{% include img.html img="burden-reduction-flow.svg" caption="CDex in DaVinci Burden Reduction Workflow" %}


#### PAS Workflow for Pended Transaction

{% include img.html img="pas-pended-flow.svg" caption="CDex in DaVinci PAS 'Pended' Workflow" %}


{% include link-list.md %}
