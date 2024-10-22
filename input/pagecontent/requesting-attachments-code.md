This page documents a FHIR-based approach for requesting attachments for claims and prior authorization from a Provider.\*  This transaction is used for *solicited* attachments and uses the combination of a Task-based [CDex Task Attachment Request Profile] to request attachments and the [`$submit-attachment`] operation to submit the attachments to the Payer as documented in the [Sending Attachments] page. It is intended to be compatible with the X12n 277 Request for Additional Information (RFAI) and 278 response transactions. For more information on X12 defined transactions, see [X12 Transaction Sets]. 

\* {% include see-conf.md %}

### Requesting Attachments Background 

In the current state of healthcare data exchange, the Payer requests additional documentation to support a claim or prior authorization using an X12 transaction, fax, portal, or other capabilities. The Provider can submit these *solicited* attachments using Non-FHIR methods or can use the [`$submit-attachment`] operation to "push" the attachments directly to the Payer, as documented in the [Sending Attachments] page:

{% include img.html img="request-attachments-nonfhir-sequencediagram.svg" caption=" Figure 14: Request Attachment Sequence Diagram For Non-FHIR Requests" %}




### Requesting Attachments Using FHIR
 
{% include task-based-sections-to-review.md %}

### Requesting Attachments Using Attachment Codes


The CDex Task Attachment Request Profile defines a specific `Task.code` that communicates that the Payer is requesting attachments for a claim or prior authorization using:
- attachment codes or 
- additional data using FHIR Questionnaires.

Systems using CDex Attachments [*must support*] requesting attachments using attachment codes. ({% include see-conf.md %}) The rest of this page documents *solicited* attachment transactions using attachment codes. Using FHIR Questionnaires to request additional data is optional and covered on the [Requesting Attachments Using Questionnaires] page.

Requesting attachments using attachment codes defined by the LOINC Document Ontology or, for prior authorization, [X12] PWK01 Report Type Codes is a HIPAA-based request model. The Payer communicates the missing information for a claim or prior authorization with these codes, which typically represent data in document form (e.g., a PDF or CCDA). The sequence diagram in Figure 15 below summarizes the interaction between the Payer and Provider to request and receive attachments using the combination of the [CDex Task Attachment Request Profile] using attachment codes and the [`$submit-attachment`] operation.

{% include img.html img="request-attachments-cdex-sequencediagram.svg" caption="Figure 15" %}



### Data Elements for Requesting Attachments

When requesting attachments, the following data elements are needed to associate an attachment to a claim or prior authorization. They are mapped to the [CDex Task Attachment Request Profile] elements and the corresponding x12n 277 Request for Additional Information (RFAI) and x12n 278 response elements in the following table. {% include X12_IP.md %}  

{% include requests-277_278.md %}

### *Step-by-Step* Solicited Attachment Transaction

In the following sections, A detailed look at an example *Solicited* attachment transaction illustrates how the Payer uses the CDex Task Attachment Request Profile to communicate the required data elements to the Provider and how they use the $submit-attachment to communicate the response back to the Payer.
{: .bg-info}

In this scenario, a Provider creates a claim and sends it to the Payer. The Payer reviews the claim and responds with a request for supporting documentation/attachments using the  CDex Attachment Request Profile. The flow diagram for this transaction is shown in Figure 16 below:

{% include img.html img="cdex-request-attach-claim-flow.svg" caption=" Figure 16: CDex Request Attachments for Claims Using Attachments Codes" %}

 In addition to the information needed to submit and associate the attachments to the claim successfully, the Payer supplies the following information to complete the adjudication of the claim:

- The attachment code(s) for the requested documents.  These codes are [LOINC attachment codes] or, for prior authorization, [X12] PWK01 Report Type Codes 
- What line numbers on the claim the requested attachment (s) are for

After receiving the attachment request, the Provider collects the documentation and returns it using the [`$submit-attachment`] operation, posting it to the endpoint supplied in the request. The table below summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters: 


{% include attachments_to_requests.md %}


#### Payer Requests Attachments for Claim

The Payer POSTs the CDex Task Attachment Request Profile to the Provider endpoint.

~~~
POST [base]/Task
~~~

**Request Body**

##### Task Resource

<!-- The request body's various elements are annotated to show how the Payer communicates each data element to the Provider. -->

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=0 count=2 linenumber=true rel=true %}
~~~

##### Verifying Patient Identity

The following data elements are used to verify the patient's identity. (This guide does not cover how the Provider system verifies the patient's identity.) They are communicated in a  *contained* Patient resource using the [CDex Patient Demographics Profile]. The contained Patient is referenced in `Task.for.reference` using a fixed reference value of "#patient".

|Data|HRex Patient Demographics Profile.|
|---|---|
|Member ID or Patient Account No.*|`Patient.identifier`|
|Patient Name|`Patient.name`|
|Patient DOB (optional)|`Patient.birthDate`|
{: .grid}

\* Patient Account Number is a Provider assigned identifier 


~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=2 count=22 linenumber=true rel=true %}
~~~

##### Supplying the Provider ID(s)

The Payer communicates the provider ID as a unique organization/location identifier (e.g., Type 2 NPI) or a unique provider identifier (e.g., Type 1 NPI) or both in a *contained* PractitionerRole resource using the [CDex PractitionerRole Profile]. The contained PractitionerRole is referenced in `Task.owner.reference` using a fixed reference value of "#practitionerrole".

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=24 count=16 linenumber=true rel=true %}
~~~

##### Supplying the Tracking ID

The mandatory `Task.identifier` *tracking-id* slice element represents the Payer tracking identifier. The tracking-id (the "re-association tracking control number") is an identifier that ties the attachments back to the claim or prior authorization. The Provider will echo it back to the Payer when submitting the attachments. 


~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=40 count=12 linenumber=true rel=true %}
~~~

##### Task *status* *intent* and *code* Elements

These required Task infrastructure elements:

- `Task.status`
- `Task.intent`
- `Task.code`

convey what the task is about, its status, and the intent of the request. The `Task.status` value of "request" is typical when POSTing the Task-based attachment request. The status will change as the Task moves through the workflow based on the [Task state machine]. `Task.intent` is fixed to "order".

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=52 count=2 linenumber=true rel=true %}
~~~

##### Task *code* Element

The `Task.code` communicates that the Payer is requesting attachments for a claim or prior authorization using a code or data request questionnaire. If the code is "attachment-request-code", as it is in this scenario, the provider system returns attachment(s) identified by the attachment code(s) in the "code" input parameter. If the code is "attachment-request-questionnaire", the provider system uses Documentation Templates and Rules (DTR) to complete the Questionnaire referenced in the "questionnaire" input parameter. The provider system uses the $submit-attachment operation to return the information to the endpoint provided in the `Task.input` "payer-url" parameter.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=54 count=7 linenumber=true rel=true %}
~~~

##### Identifying the Payer, Provider, and Patient


The Payer directs the attachment request to the same Provider who submitted the claim or prior authorization. Business identifiers are used to identify the Patient, the Payer, and the Provider who submitted the claim. The Provider echoes them back to the Payer when submitting the attachments.

As discussed above, the Patient ID is in the contained Patient resource, referenced by the `Task.for` element, and the Provider ID is in the contained PractitionerRole resource referenced by the `Task.owner` element. The Provider ID can be a Practitioner identifier (i.e., a Type1 NPI), a Practitioner's Organization identifier (i.e., a Type2 NPI), or both.

(note the various Task dates in the request fragment below)


|Actor|CDex Request Attachment Task Profile Element|
|---|---|
|payer ID|`Task.requester.identifier`|
|provider ID|(contained)PractitionerRole.practitioner. identifier or PractitionerRole.Organization.identifier|
|patient member ID or Patient Account No|(contained)Patient.identifier|
{: .grid}

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=61 count=14 linenumber=true rel=true %}
~~~

##### Claim Information

The Task communicates whether the attachments are for a claim or prior authorization, and the Payer identifies the claim or prior authorization with its business identifier.

|Data|CDex Request Attachment Task Profile Element|
|---|---|
|Claim or Prior Authorization|`Task.reasonCode`|
|Claim or Prior Authorization ID|`Task.reasonReference.identifier`|
{: .grid}

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=75 count=14 linenumber=true rel=true %}
~~~

##### Attachment Due Date

The Payer communicates the due date for submitting the attachment in the `Task.restriction.period` element. Note that `Task.restriction.period.end` represents the time when the Provider should have submitted the attachments.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=89 count=5 linenumber=true rel=true %}
~~~

##### Communicating What Attachments are Needed

The Payer supplies the attachment codes to communicate what attachments are needed. They may also provide the *line item numbers* to match the attachment to a line item in the claim or prior authorization. This information is represented in the `Task.input` "code" parameter. For example, the code snippet below shows a single request for line item 1 using a LOINC attachment code (for prior authorization, [X12] PWK01 Report Type Codes may also be used). When submitting the attachments, the Provider returns the codes and line items to the Payer.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=94 count=20 linenumber=true rel=true %}
~~~

##### Communicating the Signature Requirements

This `Task.input` "signature-flag" may indicate that the Provider must sign the attachments. For more information about using signatures in CDex, see the [Signatures] and [Sending Attachments] pages.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=114 count=9 linenumber=true rel=true %}
~~~



##### Supplying the $submit-attachment Operation Endpoint

The Payer supplies the URL endpoint in the `Task.input` "payer-url" parameter. The Provider System uses this endpoint for the [`$submit-attachment`] operation. Note that it is not necessarily a FHIR RESTful server endpoint.

<!-- If no url endpoint is supplied the attachments are provided either as references or contained Task resources and the requester needs to poll/subscribe to the Task to retrieve when done. -->

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=123 count=9 linenumber=true rel=true %}
~~~



##### Date of Service for the claim

This `Task.input` element represents the service date or the service's starting date for the claim or prior authorization. If the attachment is for a claim, it **SHALL** be present and precise to the day. It is optional if the attachment is for a prior authorization.  

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=132 count=9 linenumber=true rel=true %}
~~~


##### Purpose of Use for the Request

This optional `Task.input` element represents the request's purpose of use (POU). This example supports a request for a claim, "CLMATTCH". When requesting attachments for prior authorization, it would be "COVAUTH".

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=141 count=21 linenumber=true rel=true %}
~~~


#### Provider Submits Solicited Attachments

When the Task is completed, the Provider POSTs the [`$submit-attachment`] operation and its payload to the Payer's endpoint communicated in the `Task.input` "payer-url" parameter. The operation payload contains the requested attachments and echoes many data elements sent in the request. The table in the introduction to this section summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters. The documentation below describes and demonstrates the [`$submit-attachment`] parameters.

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|Payer URL|"payer-url"Task.input|(operation endpoint)|
{:.grid}

**Request**

~~~
POST [base]/$submit-attachment
~~~

**Request Body**

##### The Submit Attachment Operation Payload

The attachments and metadata needed to associate the attachment to the claim or prior authorization are in the [`$submit-attachment`] payload, a [Parameters] resource.

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example3.json' start=0 count=3 linenumber=true rel=true %}
~~~

##### Tracking ID and Indicating a Claim or Prior Authorization
The "TrackingId" parameter represents the identifier that ties the attachments to the claim or prior authorization. It is often referred to as the "re-association tracking control number". The operation must indicate whether the attachments are for claim or prior authorization. These data elements are taken from the CDex request as follows:

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|TrackingID|Task.identifier|TrackingId|
|Use|Task.reasonCode|AttachTo|
{:.grid}

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example3.json' start=3 count=10 linenumber=true rel=true %}
~~~   

##### Identifying the Payer, Provider, Organization, and Patient

As documented above, The Payer uses business identifiers to identify itself, the Patient, the Provider (i.e., the practitioner), and the Organization (i.e., the provider organization) who submitted the claim or prior authorization. The Provider uses these same identifiers when submitting the attachments.

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|Payer ID|Task.requester.identifier|PayerId|
|Organization ID|PractitionerRole.organization.identifier|OrganizationId|
|Provider ID|PractitionerRole.practitioner.identifier|ProviderId|
|Member ID|Patient.identifier|MemberId|
{:.grid}

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example3.json' start=13 count=28 linenumber=true rel=true %}
~~~ 


##### The Service Date

The service date parameter is taken from the "service-date" `Task.input` element in the CDex Attachment request.

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|Date of Service|“service-date” Task.input|ServiceDate|
{:.grid}

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example3.json' start=41 count=4 linenumber=true rel=true %}
~~~ 


##### Supply the Requested Attachments for Each Line Item and Code

The requested attachments, the corresponding coded requests, and line item numbers are communicated as "Attachment" parameter parts. The attachment is communicated as a FHIR resource in the `Attachment.Content` parameter part, often a [DocumentReference] containing Base64 encoded FHIR and non-FHIR documents. The attachment code(s) in the `Task.input` "code" slice defines the document(s) that are to be returned via submit_attachment and are communicated in the `Attachment.Code`. Line item numbers associated with a requested item are sent in the `Attachment.LineItem` parameter part.

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|line item(s)|“code”Task.input.extension|Attachment.LineItem|
|Attachment Code|“code”Task.input|Attachment.Code|
|Attachments|-|Attachment.Content
{:.grid}

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example3.json' start=45 count=65 linenumber=true rel=true %}
~~~



### Complete *Solicited* Attachment Transaction

The example below shows the complete *solicited* attachment transaction. A Payer uses the CDex Task Attachment Request Profile to request the attachment using an attachment code, and the Provider uses the [`$submit-attachment`] operation to submit the attachments to the Payer:

{% include examplebutton_default.html example="solicited-attachment-scenario-1.md" b_title = "Click Here To See FHIR Based Solicited Attachment Example" %}

### Signatures

Refer to the [Signatures section](sending-attachments.html#signatures) on the Sending Attachments page.

<br/><br/>

{% include link-list.md %}