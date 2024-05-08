This page documents a FHIR-based approach for requesting attachments for claims or prior authorization from a Provider.\*  This transaction is used for *solicited*  attachments and uses the combination of a Task-based [CDex Task Attachment Request Profile] to request attachments and the [`$submit-attachment`] operation to submit the attachments to the Payer as documented in the [Sending Attachments] page. It is intended to be compatible with the X12n 277 Request for Additional Information (RFAI) and 278 response transactions. For more information on X12 defined transactions, see [X12 Transaction Sets]. 

\* {% include see-conf.md %}

### Requesting Attachments Background 

In the current state of healthcare data exchange, the Payer requests additional documentation to support a claim or prior authorization using an X12 transaction, fax, portal, or other capabilities. The Provider can submit these *solicited* attachments using Non-FHIR methods or can use the [`$submit-attachment`] operation to "push" the attachments directly to the Payer, as documented in the [Sending Attachments] page:

{% include img.html img="request-attachments-nonfhir-sequencediagram.svg" caption="Figure 14: Request Attachment Sequence Diagram For Non-FHIR Requests" %}



### Requesting Attachments Using FHIR
 
Payers can request attachments and additional data for claims and prior authorizations as a FHIR transaction. Similar to the CDex [Task Based Approach], [Task] can be used to represent both the data request and the returned data and provides information such as why it needs to be completed, who is to complete it, who is asking for it, when it is due, etc. The Provider updates the Task’s status as the task is fulfilled. When the status is "completed", the Provider submits the *solicited* attachments to the payer-supplied endpoint using the [`$submit-attachment`] operation, which is documented on the [Sending Attachments] page.

#### CDex Attachment Request Profile

**For CDex attachment requests transactions, the Payer SHALL use the [CDex Task Attachment Request Profile] to solicit information from a Provider.** 
<!-- {% raw %} {{ site.data.resources.['StructureDefinition/cdex-task-attachment-request']['description'] }} {% endraw %} -->
For a detailed description of all the mandatory, [*must support*], and optional elements, as well as formal definitions and profile views, see the [CDex Task Data Request Profile] page.





### Requesting Attachments Using Attachment Codes

The [Task Based Approach section](http://hl7.org/fhir/us/davinci-cdex/STU2/task-based-approach.html#task-based-approach) documents the reasons for using Task for requesting attachments. In addition, details for Task-based transactions are described in the [Requesting Exchange using Task] section of the Da Vinci HRex Implementation Guide.

The CDex Task Attachment Request Profile defines a specific `Task.code` that communicates that the Payer is requesting attachments for a claim or prior authorization using:
- attachment codes or 
- additional data using a FHIR Questionnaire.

Systems using CDex Attachments [*must support*] requesting attachments using attachment codes. ({% include see-conf.md %}) The rest of this page documents *solicited* attachment transactions using attachment codes. Using a FHIR Questionnaire to request additional data is optional and covered on the [Requesting Attachments Using Questionnaires] page.

Requesting attachments using LOINC attachment codes defined by the LOINC Document Ontology is a HIPAA-based request model. The Payer communicates the missing information for a claim or prior authorization with these codes, which typically represent data in document form (e.g., a PDF or CCDA). The sequence diagram in Figure 15 below summarizes the interaction between the Payer and Provider to request and receive attachments using the combination of the [CDex Task Attachment Request Profile] using attachment codes and the [`$submit-attachment`] operation.

{% include img.html img="request-attachments-cdex-sequencediagram.svg" caption="Figure 15" %}



### Data Elements for Requesting Attachments

When requesting attachments, the following data elements are needed to associate an attachment to a claim or prior authorization. They are mapped to the [CDex Task Attachment Request Profile] elements and the corresponding x12n 277 Request for Additional Information (RFAI) and x12n 278 response elements in the following table. {% include X12_IP.md %}  

{% include requests-277_278.md %}

### *Step-by-Step* Solicited Attachment Transaction

In the following sections, A detailed look at an example *Solicited* attachment transaction illustrates how the Payer uses the CDex Task Attachment Request Profile to communicate the required data elements to the Provider and how they use the $submit-attachment to communicate the response back to the Payer.
{: .bg-info}

In this scenario, a Provider creates a claim and sends it to the Payer. The Payer reviews the claim and responds with a request for supporting documentation/attachments using the  CDex Attachment Request Profile. The flow diagram for this transaction is shown in Figure 16 below:

{% include img.html img="cdex-request-attach-claim-flow.svg" caption="Figure 16: CDex Request Attachments for Claims Using Attachments Codes" %}

 In addition to the information needed to submit and associate the attachments to the claim successfully, the Payer supplies the following information to complete the adjudication of the claim:

- LOINC attachment code(s) for the requested documents
- What line numbers on the claim the requested attachment(s) are for

After receiving the attachment request, the Provider collects the documentation and returns them using the [`$submit-attachment`] operation, posting it to the endpoint supplied in the request. The table below summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters: 


{% include attachments_to_requests.md %}


#### Payer Requests Attachments for Claim

The Payer POSTs the CDex Task Attachment Request Profile to the Provider endpoint.

~~~
POST [base]/Task
~~~

**Request Body**

##### Task Resource

The optional profile declaration shown below asserts that the resource conforms to the profile and contains all the necessary data elements listed above.

<!-- The request body's various elements are annotated to show how the Payer communicates each data element to the Provider. -->

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=0 count=7 linenumber=true rel=true %}
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
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=7 count=37 linenumber=true rel=true %}
~~~

##### Supplying the Provider ID(s)

The Payer communicates the provider ID as either a unique organization/location identifier (e.g., Type 2 NPI) or unique provider identifier (e.g., Type 1 NPI) or both in a *contained* PractitionerRole resource using the [CDex PractitionerRole Profile]. The contained PractitionerRole is referenced in `Task.owner.reference` using a fixed reference value of "#practitionerrole".

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=43 count=21 linenumber=true rel=true %}
~~~

##### Supplying the Tracking ID

The mandatory `Task.identifier` *tracking-id* slice element represents the Payer tracking identifier. The tracking-id (also called the "re-association tracking control number") is an identifier that ties the attachments back to the claim or prior authorization. The Provider will echo it back to the Payer when submitting the attachments. 


~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=65 count=16 linenumber=true rel=true %}
~~~

##### Task *status* *intent* and *code* Elements

These required Task infrastructure elements:

- Task.status
- Task.intent
- Task.code

convey what the task is about, its status, and the intent of the request.  The Task.status value of "request" is typical when POSTing the Task-based attachment request. Note that the status will change as the Task moves through [different states](http://hl7.org/fhir/task.html#statemachine) in the workflow. Task.intent is fixed to "order".

The Task.code communicates that the Payer is requesting attachments for a claim or prior authorization using a code or data request questionnaire. If the code is “attachment-request-code”, as it is in this scenario, the provider system returns attachment(s) identified by the LOINC attachment code(s) in the “code” input parameter. If the code is “attachment-request-questionnaire”, the provider system uses Documentation Templates and Rules (DTR) to complete the Questionnaire referenced in the “questionnaire” input parameter. When either code is present, the provider system uses the $submit-attachment operation to return the information to the endpoint provided in “payer-url” input parameter.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=81 count=11 linenumber=true rel=true %}
~~~

##### Identifying the Payer, Provider, and Patient


The Payer directs the attachment request to the same Provider who submitted the claim or prior authorization. Business identifiers are used to identify the Patient, the Payer, and the Provider who submitted the claim. The Provider echoes them back to the Payer when submitting the attachments.

As discussed above, the Patient id is in the contained Patient resource, referenced by the Task.for element, and the Provider id is in the contained PractitionerRole resource referenced by the Task.owner element. The Provider id can be a Practitioner identifier (i,e., a Type1 NPI) or the Practitioner's Organization identifier (i,e., a Type2 NPI) or both.

(note the various Task dates in the request fragment below)


|Actor|CDex Request Attachment Task Profile Element|
|---|---|
|payer ID|`Task.requester.identifier`|
|provider ID|(contained)PractitionerRole.practitioner.identifier and/or PractitionerRole.Organization.identifier|
|patient member ID or Patient Account No|(contained)Patient.identifier|
{: .grid}

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=92 count=14 linenumber=true rel=true %}
~~~

##### Claim Information

The Task communicates whether the attachments are for a claim or prior authorization, and the Payer identifies the claim or prior authorization with its business Identifier.

|Data|CDex Request Attachment Task Profile Element|
|---|---|
|Claim or Prior Authorization|`Task.reasonCode`|
|Claim or Prior Authorization ID|`Task.reasonReference.identifier`|
{: .grid}

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=105 count=16 linenumber=true rel=true %}
~~~

##### Attachment Due Date

The Payer communicates the due date for submitting the attachment in the `Task.restriction.period` element. Note that `Task.restriction.period.end` is the due date representing the time by which the Provider should have submitted the attachments.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=122 count=5 linenumber=true rel=true %}
~~~

##### Communicating What Attachments are Needed

The Payer supplies the [LOINC attachment codes] to communicate what attachments are needed. They may also provide the *line item numbers* to match the attachment to a line item in the claim or prior authorization. This information is represented in the `Task.input` "code" parameter. For example, the code snippet below shows a single request for line item 1 using a LOINC attachment code. The Provider returns back the codes and line items to the Payer when submitting the attachments.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=131 count=38 linenumber=true rel=true %}
~~~

##### Communicating the Signature Requirements

This Task.input "signature-flag" may be used to indicate that the Provider must sign the attachments. See the [Signatures] and [Sending Attachments] pages for more information about using Signatures in CDex.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=154 count=11 linenumber=true rel=true %}
~~~



##### Supplying the $submit-attachment Operation Endpoint

The Payer supplies the URL endpoint as a Task input parameter. The Provider System will use this information as the endpoint for the [`$submit-attachment`] Operation. Note that the endpoint is not necessarily a FHIR RESTful server endpoint.

<!-- If no url endpoint is supplied the attachments are provided either as references or contained Task resources and the requester needs to poll/subscribe to the Task to retrieve when done. -->

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=165 count=11 linenumber=true rel=true %}
~~~



##### Date of Service for the Claim

This Task.input element represents the service date or the service's starting date for the claim or prior authorization.  It SHALL be present and precise to the day if the attachment is for a claim. It is optional if the attachment is for prior authorization.  

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=174 count=13 linenumber=true rel=true %}
~~~


##### Purpose of Use for the Request

This optional Task.input element represents the request's purpose of use (POU).  In this example, it is to support a request for a claim, "CLMATTCH".  When requesting attachments for prior authorization, it would be "COVAUTH".

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example19.json' start=188 count=21 linenumber=true rel=true %}
~~~


#### Provider Submits Solicited Attachments

When the Task is completed, the Provider POSTs the [`$submit-attachment`] operation and its payload to the Payer's endpoint. As stated above, the Payer communicates the operation endpoint to the Payer in the CDex Task Attachment Request Profile. The operation payload contains the requested attachments and echoes many data elements sent in the request. The table in the introduction to this section summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters. The documentation below describes and demonstrates the [`$submit-attachment`] parameters.

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

The attachments and metadata needed to associate the attachment to the claim or prior authorization are in the $submit-attachments payload, a [Parameters] resource.

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example3.json' start=0 count=3 linenumber=true rel=true %}
~~~

##### Tracking ID and Indicating a Claim or Prior Authorization
The TrackingId parameter represents the identifier that ties the attachments to the claim or prior authorization. It is often referred to as the "re-association tracking control number". The operation must indicate whether the attachments are for claim or prior authorization. These data elements are taken from the CDex request as follows:

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|TrackingID|Task.identifier|TrackingId|
|Use|Task.reasonCode|AttachTo|
{:.grid}

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example3.json' start=3 count=11 linenumber=true rel=true %}
~~~   

##### Identifying the Payer, Provider, Organization, and Patient

As documented above, The Payer uses business identifiers to identify itself, the Patient, and Provider (i.e., the practitioner) and Organization (i.e., the provider organization) who submitted the claim or prior authorization. The Provider uses these same identifiers when submitting the attachments.

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|Payer ID|Task.requester.identifier|PayerId|
|Organization ID|PractitionerRole.organization.identifier|OrganizationId|
|Provider ID|PractitionerRole.practitioner.identifier|ProviderId|
|Member ID|Patient.identifier|MemberId|
{:.grid}

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example3.json' start=14 count=28 linenumber=true rel=true %}
~~~ 


##### The Service Date

The service date parameter is taken from the “service-date” Task.input element in the CDex Attachment request.

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|Date of Service|“service-date” Task.input|ServiceDate|
{:.grid}

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example3.json' start=42 count=4 linenumber=true rel=true %}
~~~ 


##### Supply the Requested Attachments for Each Line Item and Code

The Requested Attachments, the corresponding coded requests, and line item numbers are communicated as Attachment parameter parts. The attachment is communicated as a FHIR resource in the Attachment.content parameter part, often a [DocumentReference] containing Base64 encoded FHIR and non-FHIR documents. The [LOINC attachment codes] represented in the Task.input "code" slice, define the document(s) that are to be returned via submit_attachment. Line item numbers associated with a requested item are communicated in the Attachment.LineItem parameter part.

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|line item(s)|“code”Task.input.extension|Attachment.LineItem|
|LOINC Attachment Code|“code”Task.input|Attachment.Code|
|Attachments|-|Attachment.content
{:.grid}

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example3.json' start=46 count=65 linenumber=true rel=true %}
~~~



### Complete *Solicited* Attachment Transaction

The example below shows the complete *solicited* attachment transaction. A Payer uses the CDex Task Attachment Request Profile to request the attachment using an attachment code, and the Provider uses the [`$submit-attachment`] operation to submit the attachments to the Payer:

{% include examplebutton_default.html example="solicited-attachment-scenario-1.md" b_title = "Click Here To See FHIR Based Solicited Attachment Example" %}

### Signatures

Refer to the [Signatures section](sending-attachments.html#signatures) on the Sending Attachments page.

{% include link-list.md %}