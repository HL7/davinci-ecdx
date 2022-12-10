{% include draft_content_note.md  content="page" %}

This page documents a FHIR-based approach for requesting attachments for claims or prior authorization from a Provider.  This transaction is used for *solicited*  attachments and uses the combination of a Task-based [CDex Task Attachment Request Profile] to request attachments and the [`$submit-attachment`] operation to submit the attachments to the Payer as documented in the [Sending Attachments] page. It is intended to be compatible with the X12n 277 and 278 response transactions. <span class="bg-success" markdown="1">For more information on X12 defined transactions, see [X12 Transaction Sets].</span><!-- new-content -->

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

<!-- The following data elements are needed to associate an attachment to a claim or prior authorization when requesting attachments. They have been mapped to the [CDex Task Attachment Request Profile] elements and their corresponding x12n 277 and 278 response analogs in the following table:  -->

In a future version of this guide, the mapping between these data elements and the corresponding x12n 277 and 278 response fields will be added
{:.stu-note}

{% include requests-277_278.md %}

<!-- {% raw %}{% include data_elements_to_requests.md %} {% endraw %} -->

The data element mapping table is available as a [CSV](data-element-mapping.csv) and [Excel](data-element-mapping.xlsx) file.

### *Step-by-Step* Solicited Attachment Transaction

In the following sections, A detailed look at an example *Solicited* attachment transaction illustrates how the CDex Task Attachment Request Profile is used to communicate the required data elements to the Provider and how the $submit-attachment is used to communicate the response back to the Payer.
{: .bg-info}

In this scenario, a Provider creates a claim and sends it to the Payer.  The Payer reviews the claim and responds with a request for attachments using the  CDex Attachment Request Profile.  In addition to the information needed to successfully submit and associate the attachments to the claim, the payer supplies the following details about what information is needed to complete the adjudication of the claim:

- LOINC attachment code(s) for the requested documents
- What line numbers on the claim the requested attachment(s) are for

<!-- An endpoint where the Provider submits the attachments is supplied. This endpoint is used by the [`$submit-attachment`] operation and can be used by any HTTP endpoint, not just FHIR RESTful servers. The payer may also indicate whether a Digital Signature is required and whether the attachments need to be submitted in a single transaction. -->

After receiving the attachment request, the Provider collects the documentation and returns them using the [`$submit-attachment`] operation, posting it to the endpoint supplied in the request. <span class="bg-success" markdown="1">The table below summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters:</span><!-- new-content -->

<div class="bg-success" markdown="1">
{% include attachments_to_requests.md %}
</div><!-- new-content -->

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
{% include_relative includelines filename='cdex-task-example19.json' start=0 count=7 linenumber=true %}
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
{% include_relative includelines filename='cdex-task-example19.json' start=7 count=37 linenumber=true %}
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
{% include_relative includelines filename='cdex-task-example19.json' start=44 count=16 linenumber=true %}
~~~

##### Task *Infrastructure* Elements

These required Task *infrastructural* elements:

- Task.status
- Task.intent
- Task.code

convey what the task is about, its status, and the intent of the request.  The Task.status value of "request" is typical when POSTing the Task-based attachment request. Note that the status will change as the Task at is moves through [different states](http://hl7.org/fhir/task.html#statemachine) in the workflow. Task.intent is fixed to "order".  The Task.code is fixed to “attachment-request” to communicate that the Payer is requesting attachments for a claim or prior-authorization and is expecting they will be submitted using the $submit-attachment operation to the endpoint provided in the “payer-url” input parameter.

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=60 count=11 linenumber=true %}
~~~

##### Identifying the Payer, Provider, and Patient

<div class="bg-success" markdown="1">
The attachment request will be directed to the same Provider who submitted the claim or prior authorization. Business identifiers are used to identify the Patient, the Payer, and the Provider who submitted the claim, and these identifiers are echoed back to the Payer when submitting the attachments.

As discussed above, the Patient identifier is in the contained Patient resource, referenced by the Task.for element. The Provider identifier(s) are referenced in the Task.owner element for the Practitioner (i,e., a Type1 NPI) or the Practitioner's Organization (i,e., a Type2 NPI) or both. A contained PractitionerRole resource is used to communicate both identifiers if present.

(note the various Task dates in the request fragment below)
</div><!-- new-content -->

|Actor|CDex Claim Profile element|
|---|---|
|payer ID|`Task.reasonReference.identifier`|
|provider ID|`Task.owner.identifier`|
|patient member ID or Patient Account No|(contained)Patient.identifier|
{: .grid}

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=71 count=17 linenumber=true %}
~~~

##### Claim Information

The Task communicates whether the attachments are for a Claim or Prior Authorization and the Claim or Prior Authorization ID is identified by its business Identifier. 

|Data|CDex Claim Profile element|
|---|---|
|Claim or Prior Authorization|`Task.reasonCode`|
|Claim or Prior Authorization ID|`Task.reasonReference.identifier`|
{: .grid}

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=88 count=16 linenumber=true %}
~~~

##### Attachment Due Date

The Due Date for attachment is communicated in the `Task.restriction.period`  element. Note that `Task.restriction.period.end` is the due date representing the time by which the attachments should be submitted.

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=104 count=5 linenumber=true %}
~~~

##### Communicating What Attachments are Needed

The payer supplies the [LOINC attachment codes] to communicate what attachments are needed.  Line item numbers may also be supplied to match the attachment to a line item in the claim or pre-auth.  This information is represented in the `Task.input` "code". The code snippet below shows a single request for line item 1 using a LOINC attachment code.  The codes and line items are echoed back to the Payer when submitting the attachments.


~~~
{% include_relative includelines filename='cdex-task-example19.json' start=109 count=38 linenumber=true %}
~~~

##### Communicating the Signature Requirements

 This Task.input "signature-flag" may be used to indicate that the attachments must be signed. See the [Signatures] and [Sending Attachments] page for more information about using Signatures in CDex.

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=136 count=11 linenumber=true %}
~~~

##### Supplying the $submit-attachment Operation Endpoint

The Payer supplies the url endpoint as a Task input parameter. The Provider System will use this information as the endpoint for the [`$submit-attachment`] Operation.

<!-- If no url endpoint is supplied the attachments are provided either as references or contained Task resources and the requester needs to poll/subscribe to the Task to retrieve when done. -->

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=147 count=11 linenumber=true %}
~~~

##### Date of Service for the Claim

A Task.input element represents the date of service or starting date of the service for the claim or prior authorization.

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=158 count=13 linenumber=true %}
~~~

#### Provider Submits Solicited Attachments

The Provider POSTs the [`$submit-attachment`] operation and its payload to the Payer's endpoint. As stated above, the Payer endpoint is communicated to the Payer in the CDex Task Attachment Request Profile. The same data elements sent in the request for attachments are echoed back when submitting the attachments using the [`$submit-attachment`] operation. The table in the introduction to this section summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters. These parameters are documented in more detail below.

**Request**

~~~
POST [base]/$submit-attachment
~~~

**Request Body**

##### The Submit Attachment Operation Payload

The attachments along with the metadata needed to associate the attachment to the Claim or Pre-Auth are in the $submit-attachments payload, a [Parameters] resource.

~~~
{% include_relative includelines filename='cdex-parameters-example3.json' start=0 count=3 linenumber=true %}
~~~

##### Tracking ID and Indicating a Claim or Prior Authorization
The Tracking ID is an identifier that ties the attachments back to the claim or pre-auth.  It is often referred to as the “re-association tracking control number”.  The operation needs to indicate whether the attachments are for claim or prior-authorization. These data elements are taken from the CDex request as follows:

|Data Element|CDex Request Element|CDex #submit-attachment Parameter|
|---|---|---|
|TrackingID|Task.identifier|TrackingId|
|Use|Task.reasonCode|AttachTo|
{:.grid}

~~~
{% include_relative includelines filename='cdex-parameters-example3.json' start=3 count=11 linenumber=true %}
~~~   

##### Identifying the Payer, Provider, Organization, and Patient

As documented above, business identifiers are used to identify the Patient, the Payer, and the Provider who submitted the Claim. These should be the same as communicated in the request.  The NPI should be used for the Practitioner and Organization IDs.

|Data Element|CDex Request Element|CDex #submit-attachment Parameter|
|---|---|---|
|Payer URL|"payer-url"Task.input|(operation endpoint)|
|Organization ID|-|OrganizationId|
|Provider ID|Task.owner.identifier|ProviderId|
|Member ID|Patient.identifier|MemberId|
{:.grid}

~~~
{% include_relative includelines filename='cdex-parameters-example3.json' start=14 count=28 linenumber=true %}
~~~ 


##### The Service Date

The service date parameter is taken from the “service-date” Task.input element in the CDex Attachment request.


~~~
{% include_relative includelines filename='cdex-parameters-example3.json' start=42 count=4 linenumber=true %}
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
{% include_relative includelines filename='cdex-parameters-example3.json' start=46 count=65 linenumber=true %}
~~~



### Complete *Solicited* Attachment Transaction

The complete *solicited* attachment transaction using the combination of a Task-based CDex Task Attachment Request Profile to request attachments and the [`$submit-attachment`] operation to submit the attachments to the Payer is shown below:

{% include examplebutton_default.html example="task-scenario-8.md" b_title = "Click Here To See FHIR Based Solicited Attachment Example" %}

### Signatures

Refer to the [Signatures section](sending-attachments.html#signatures) in the Sending Attachments page.

{% include link-list.md %}