

This page documents a FHIR-based approach for requesting attachments for claims or prior authorization from a Provider.  This transaction is used for *solicited*  attachments and uses the combination of a Task-based [CDex Task Attachment Request Profile] to request attachments and the [`$submit-attachment`] operation to submit the attachments to the Payer as documented in the [Sending Attachments] page. It is intended to be compatible with the X12n <span class="bg-success" markdown="1">277 Request for Additional Information (RFAI)</span><!-- new-content --> and 278 response transactions. <span class="bg-success" markdown="1">For more information on X12 defined transactions, see [X12 Transaction Sets].</span><!-- new-content -->

### <span class="bg-success" markdown="1">Requesting Attachments Background</span><!-- new-content -->

In the current state of healthcare data exchange, the Payer requests additional documentation to support a claim or prior authorization using an X12 transaction, fax, portal, or other capabilities.  The Provider can submit these *solicited* attachments using a variety of Non-FHIR methods or can use the [`$submit-attachment`] operation to "push" the attachments directly to the Payer, as documented in the [Sending Attachments] page:

{% include img.html img="request-attachments-nonfhir-sequencediagram.svg" caption="Request Attachment Sequence Diagram For Non-FHIR Requests" %}

<div class="bg-success" markdown="1">

### <span class="bg-success" markdown="1">Requesting Attachments Using FHIR
</span><!-- new-content -->
To request attachments for claims and prior authorizations as a FHIR transaction, payers can use the [Task] based [CDex Task Attachment Request Profile]. It communicates the attachment request as either a:
  - a LOINC attachment code
  - a reference to a questionnaire or form.
  
When the task is completed, the provider submits the attachments to the payer supplied endpoint using the $[`$submit-attachment`] operation.

<!-- #### Using Task to Request Attachments -->

The [Task Based Approach section](http://hl7.org/fhir/us/davinci-cdex/STU2/task-based-approach.html#task-based-approach) documents the reasons for using Task for requesting attachments.  Details for Task-based transactions are described in the [Requesting Exchange using Task] section of the Da Vinci HRex Implementation Guide.

</div><!-- new-content -->


<div class="bg-success" markdown="1">

### Requesting Attachments Using Attachments Codes

{% include img-small.html img="todo.png" %}

The sequence diagram in the Figure below summarizes the basic interaction between the Payer and Provider to request and receive attachments using the combination of the [CDex Task Attachment Request Profile] and the [`$submit-attachment`] operation.

{% include img.html img="request-attachments-cdex-sequencediagram.svg" caption="Request Attachment Sequence Diagram Using CDex Task" %}

</div><!-- new-content -->
### CDex Attachment Request Profile

**For CDex attachment requests transactions the [CDex Task Attachment Request Profile] SHALL be used by the Payer to solicit information from a Provider.** 

{{ site.data.resources.['StructureDefinition/cdex-task-attachment-request']['description'] }}

See the [CDex Task Attachment Request Profile] formal definition for further details.

### Data Elements for Requesting Attachments

The following data elements are needed to associate an attachment to a claim or prior authorization when requesting attachments. <span class="bg-success" markdown="1">They are mapped to the [CDex Task Attachment Request Profile] elements and the corresponding x12n 277 Request for Additional Information (RFAI) and x12n 278 response elements in the following table. {% include X12_IP.md %} </span><!-- new-content -->

{% include requests-277_278.md %}

### *Step-by-Step* Solicited Attachment Transaction

In the following sections, A detailed look at an example *Solicited* attachment transaction illustrates how the CDex Task Attachment Request Profile is used to communicate the required data elements to the Provider and how the $submit-attachment is used to communicate the response back to the Payer.
{: .bg-info}

In this scenario, a Provider creates a claim and sends it to the Payer.  The Payer reviews the claim and responds with a request for <span class="bg-success" markdown="1">supporting documentation/attachments</span><!-- new-content --> using the  CDex Attachment Request Profile. The flow diagram for this transaction is shown in figure 3 below:

{% include img.html img="cdex-request-attach-claim-flow.svg" caption="Figure 3: CDex Request Attachments for Claims Using Attachments Codes" %}

 In addition to the information needed to successfully submit and associate the attachments to the claim, the payer supplies the following details about what information is needed to complete the adjudication of the claim:

- LOINC attachment code(s) for the requested documents
- What line numbers on the claim the requested attachment(s) are for

After receiving the attachment request, the Provider collects the documentation and returns them using the [`$submit-attachment`] operation, posting it to the endpoint supplied in the request. <span class="bg-success" markdown="1">The table below summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters:</span><!-- new-content -->

<div class="bg-success" markdown="1">
{% include attachments_to_requests.md %}
</div><!-- new-content -->

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

The following data elements are used to verify patient identity. (How the Provider system verifies the patient is not covered in this guide.) The Payer communicates them in a  *contained* Patient resource using the [CDex Patient Demographics Profile]. This contained Patient is referenced in `Task.for.reference` using a fixed reference value of "#patient".:

|Data|HRex Patient Demographics Profile.|
|---|---|
|Member ID or Patient Account No.*|`Patient.identifier`|
|Patient Name|`Patient.name`|
|Patient DOB (optional)|`Patient.birthDate`|
{: .grid}

\* <span class="bg-success" markdown="1">Patient Account Number is a Provider assigned identifier</span><!-- new-content -->


~~~
{% include_relative includelines filename='cdex-task-example19.json' start=7 count=37 linenumber=true %}
~~~

##### Supplying the Provider ID(s)

The Payer communicates the provider ID as either a unique organization/location identifier (e.g., Type 2 NPI) or unique provider identifier (e.g., Type 1 NPI) or both in a *contained* PractitionerRole resource using the [CDex PractitionerRole Profile]. This contained PractitionerRole is referenced in `Task.owner.reference` using a fixed reference value of "#practitionerrole".

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=43 count=21 linenumber=true %}
~~~

##### Supplying the Tracking ID

The mandatory `Task.identifier` "tracking-id" slice element represents the Payer tracking identifier.  This is an identifier that ties the attachments back to the claim or prior authorization and is echoed back to the Payer when submitting the attachments.  It is often referred to as the “re-association tracking control number”.


~~~
{% include_relative includelines filename='cdex-task-example19.json' start=65 count=16 linenumber=true %}
~~~

##### Task *Infrastructure* Elements

These required Task *infrastructural* elements:

- Task.status
- Task.intent
- Task.code

convey what the task is about, its status, and the intent of the request.  The Task.status value of "request" is typical when POSTing the Task-based attachment request. Note that the status will change as the Task at is moves through [different states](http://hl7.org/fhir/task.html#statemachine) in the workflow. Task.intent is fixed to "order".  The Task.code is fixed to “attachment-request” to communicate that the Payer is requesting attachments for a claim or prior authorization and is expecting they will be submitted using the $submit-attachment operation to the endpoint provided in the “payer-url” input parameter.

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=81 count=11 linenumber=true %}
~~~

##### Identifying the Payer, Provider, and Patient

<div class="bg-success" markdown="1">
The attachment request will be directed to the same Provider who submitted the claim or prior authorization. Business identifiers are used to identify the Patient, the Payer, and the Provider who submitted the claim, and these identifiers are echoed back to the Payer when submitting the attachments.

As discussed above, the Patient id is in the contained Patient resource, referenced by the Task.for element, and the Provider id is in the contained PractitionerRole resource referenced by the Task.owner element.  The Provider id can be a Practitioner identifier (i,e., a Type1 NPI) or the Practitioner's Organization identifier (i,e., a Type2 NPI) or both.

(note the various Task dates in the request fragment below)
</div><!-- new-content -->

|Actor|CDex Claim Profile element|
|---|---|
|payer ID|`Task.reasonReference.identifier`|
|provider ID|(contained)PractitionerRole.practitioner.identifier and/or PractitionerRole.Organization.identifier|
|patient member ID or Patient Account No|(contained)Patient.identifier|
{: .grid}

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=92 count=14 linenumber=true %}
~~~

##### Claim Information

The Task communicates whether the attachments are for a claim or prior authorization and the claim or prior authorization ID is identified by its business Identifier. 

|Data|CDex Claim Profile element|
|---|---|
|Claim or Prior Authorization|`Task.reasonCode`|
|Claim or Prior Authorization ID|`Task.reasonReference.identifier`|
{: .grid}

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=105 count=16 linenumber=true %}
~~~

##### Attachment Due Date

The Due Date for attachment is communicated in the `Task.restriction.period`  element. Note that `Task.restriction.period.end` is the due date representing the time by which the attachments should be submitted.

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=122 count=5 linenumber=true %}
~~~

##### Communicating What Attachments are Needed

The payer supplies the [LOINC attachment codes] to communicate what attachments are needed.  Line item numbers may also be supplied to match the attachment to a line item in the claim or prior authorization.  This information is represented in the `Task.input` "code". The code snippet below shows a single request for line item 1 using a LOINC attachment code.  The codes and line items are echoed back to the Payer when submitting the attachments.


~~~
{% include_relative includelines filename='cdex-task-example19.json' start=131 count=38 linenumber=true %}
~~~

##### Communicating the Signature Requirements

 This Task.input "signature-flag" may be used to indicate that the attachments must be signed. See the [Signatures] and [Sending Attachments] page for more information about using Signatures in CDex.

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=154 count=11 linenumber=true %}
~~~

<div class="bg-success" markdown="1">

##### Supplying the $submit-attachment Operation Endpoint

The Payer supplies the url endpoint as a Task input parameter. The Provider System will use this information as the endpoint for the [`$submit-attachment`] Operation.

<!-- If no url endpoint is supplied the attachments are provided either as references or contained Task resources and the requester needs to poll/subscribe to the Task to retrieve when done. -->

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=165 count=11 linenumber=true %}
~~~

</div><!-- new-content -->

##### Date of Service for the Claim

This Task.input element represents the service date or the service's starting date for the claim or prior authorization. <span class="bg-success" markdown="1"> It SHALL be present and precise to the day if the attachment is for a claim. It is optional if the attachment is for prior authorization. </span><!-- new-content -->

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=174 count=13 linenumber=true %}
~~~

<div class="bg-success" markdown="1">
##### Purpose of Use for the Request

This optional Task.input element represents the request's purpose of use (POU).  In this example, it is to support a request for a claim, "CLMATTCH".  When requesting attachments for prior authorization, it would be "COVAUTH".

~~~
{% include_relative includelines filename='cdex-task-example19.json' start=188 count=21 linenumber=true %}
~~~
</div><!-- new-content -->

#### Provider Submits Solicited Attachments

The Provider POSTs the [`$submit-attachment`] operation and its payload to the Payer's endpoint. As stated above, the Payer endpoint is communicated to the Payer in the CDex Task Attachment Request Profile. The same data elements sent in the request for attachments are echoed back when submitting the attachments using the [`$submit-attachment`] operation. <span class="bg-success" markdown="1">The table in the introduction to this section summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters.</span><!-- new-content --> These parameters are documented in more detail below.

**Request**

~~~
POST [base]/$submit-attachment
~~~

**Request Body**

##### The Submit Attachment Operation Payload

The attachments along with the metadata needed to associate the attachment to the claim or prior authorization are in the $submit-attachments payload, a [Parameters] resource.

~~~
{% include_relative includelines filename='cdex-parameters-example3.json' start=0 count=3 linenumber=true %}
~~~

##### Tracking ID and Indicating a Claim or Prior Authorization
The Tracking ID is an identifier that ties the attachments back to the claim or prior authorization.  It is often referred to as the “re-association tracking control number”.  The operation needs to indicate whether the attachments are for claim or prior authorization. These data elements are taken from the CDex request as follows:

|Data Element|CDex Request Element|CDex #submit-attachment Parameter|
|---|---|---|
|TrackingID|Task.identifier|TrackingId|
|Use|Task.reasonCode|AttachTo|
{:.grid}

~~~
{% include_relative includelines filename='cdex-parameters-example3.json' start=3 count=11 linenumber=true %}
~~~   

##### Identifying the Payer, Provider, Organization, and Patient

As documented above, business identifiers are used to identify the Patient, the Payer, and the Provider who submitted the claim or prior authorization. These should be the same as communicated in the request.  The NPI should be used for the Practitioner and Organization IDs.

|Data Element|CDex Request Element|CDex #submit-attachment Parameter|
|---|---|---|
|Payer URL|"payer-url"Task.input|(operation endpoint)|
|Organization ID|PractitionerRole.organization.identifier|OrganizationId|
|Provider ID|PractitionerRole.practitioner.identifier|ProviderId|
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

The Requested Attachments and the corresponding coded requests and/or line item numbers are communicated back as Attachment parameter parts. The actual attachment is communicated as a FHIR resource in the Attachment.content parameter part, often a [DocumentReference] containing Base64 encoded FHIR and non-FHIR documents. <span class="bg-success" markdown="1">The [LOINC attachment codes] represented in the Task.input “code” slice, define the document(s) that are to be returned via submit_attachment.</span><!-- new-content --> Line item numbers associated with a requested item are communicated in the Attachment.LineItem parameter part.

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

The complete *solicited* attachment transaction is shown below. A CDex Task Attachment Request Profile is used to request the attachment using an attachment code, and the [`$submit-attachment`] operation is used to submit the attachments to the Payer:

{% include examplebutton_default.html example="solicited-attachment-scenario-1.md" b_title = "Click Here To See FHIR Based Solicited Attachment Example" %}

### Signatures

Refer to the [Signatures section](sending-attachments.html#signatures) in the Sending Attachments page.

{% include link-list.md %}