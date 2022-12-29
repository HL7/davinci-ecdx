This page is new content for Da Vinci CDex 2.0.0
{:.new-content}

**The following page is DRAFT. It requires further community review and testing.**
{:.stu-note}

This page documents a FHIR-based approach for requesting attachments and additional data for claims or prior authorization from a Provider using FHIR [Questionnaire]. This *solicited*  attachments transaction uses the combination of a Task-based [CDex Task Attachment Request Profile] to request attachments and additional data and the [`$submit-attachment`] operation to submit them to the Payer as documented in the [Sending Attachments] page. In contrast to [Requesting Attachments Using Attachment Codes], a HIPAA-based request model using LOINC attachment codes, it supports requests for more detailed missing data and avoids unnecessary documents using Questionnaire. In addition, it leverages [Da Vinci DTR] functionality to fill out the Questionnaire reducing the time involved in reviewing documentation requirements.


### Request Attachments Data Using a FHIR Questionnaire

Payers can use a Questionnaire to ask for specific attachments-related data. The Task communicates the request to complete it using Da Vinci DTR. Figure 1 summarizes this workflow. The [Task Based Approach section](http://build.fhir.org/ig/HL7/davinci-ecdx/task-based-approach.html#task-based-approach) documents the reasons for using Task for requesting attachments. The [Requesting Exchange using Task] section of the Da Vinci HRex Implementation Guide describes the details for Task-based transactions. DTR gathers Questionnaire resources, retrieves FHIR resources from EHRs, runs rules (CQL), and completes a QuestionnaireResponse. See the following sections for launching DTR and the [Da Vinci DTR] Implementation Guide for more information about DTR. 

<!-- Although DTR is also associated with [Da Vinci Burden Reduction Workflow], using DTR with CDex is unrelated to it, and the [Da Vinci Prior Authorization Support (PAS)] and [Da Vinci - Coverage Requirements Discovery (DTR)] Implementation Guides.  -->

{% include img.html img="attachments-task-Q-summary.svg" caption = "Figure 1" %}

#### Sequence Diagram

The sequence diagram in the Figure below illustrates the FHIR RESTful transactions between the Payer and Provider and DTR application to request, fill, and return a questionnaire.

{% include img.html img="attachments-task-Q-sequencediagram.svg" caption = "Figure 2" %}

### CDex Attachment Request Profile

**For CDex attachment requests transactions the [CDex Task Attachment Request Profile] SHALL be used by the Payer to solicit information from a Provider.** 

{{ site.data.resources.['StructureDefinition/cdex-task-attachment-request']['description'] }}

See the [CDex Task Attachment Request Profile] formal definition for further details.

### Using [Da Vinci DTR] to Complete the Questionnaire

{% include img-small.html img="todo.png" %}

{% include img.html img="SMART App Launch for DTR from CDEX.png" caption="Figure 3: My Notes on SMART App Launch for DTR from CDEX" %}

### Data Elements for Requesting Attachments

The [Requesting Attachments Using Attachment Codes] page documents the data elements needed to associate an attachment to a claim or prior authorization.  However, there is no "LOINC Attachment Code" Data element when using Questionnaires to collect attachments-related data.

### *Step-by-Step* Solicited Attachment Transaction

In the following sections, A detailed look at an example *Solicited* attachment transaction illustrates how:

- The Payer uses a FHIR Questionnaire to communicate to the Provider what additional attachments-related data is needed.
- The Payer uses the CDex Task Attachment Request Profile to communicate to the Provider to complete the Questionniare.
- The Provider launches DTR to fill out the FHIR Questionnaire using QuestionnaireResponse.
- The DTR completes the QuestionaireResponse and updates the Task.
- The Provider uses the $submit-attachment operation to communicate the completed QuestionnaireResponse back to the Payer.

In this scenario, a Provider creates a prior-authorization and sends it to the Payer.  The Payer reviews the prior-authorization and responds with a request to fill out a questionnaire for attachments-related data using the *CDex Attachment Request Profile*. After receiving the attachment request, the Provider launches DTR which completes a QuestionnaireResponse.  The Provider returns the QuestionnaireResponse using the [`$submit-attachment`] operation, posting it to the endpoint supplied in the request. The flow diagram for this scenario is shown in figure 3 below.


{% include img.html img="cdex-request-questionnaire-priorauth-flow.svg" caption="Figure 3: CDex Request Attachment for Prior-Auth Using Questionnaires" %}

In addition to the information needed to successfully submit and associate the attachments to the claim, the Payer supplies the following details about what information is needed to complete the adjudication of the claim:

- link to the Questionnaire
- What line numbers on the claim the requested attachment(s) are for
- The specific purpose of use (POU) for the request

The table below summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters:

| Data Element | CDex $submit-attachment Parameter | CDex Request Attachment Task Profile Element |
|-----|----|---------|
| Tracking ID (Provider or Payer Assigned) | TrackingId | Task.identifier |
| Use | AttachTo | Task.reasonCode |
| Payer URL | (operation endpoint) | "payer-url" Task.input |
| Organization ID | OrganizationId | <span class="bg-success" markdown="1">PractitionerRole.practitioner.identifier</span><!-- new-content --> |
| Provider ID | ProviderId | <span class="bg-success" markdown="1">PractitionerRole.organization.identifier</span><!-- new-content --> |
| Line Item(s) | Attachment.LineItem | “code” Task.input.extension |
| Date of Service | ServiceDate | “service-date” Task.input |
| Member ID | MemberId | Patient.identifier |
|Questionnaire|-|“questionnaire” Task.input| 
|QuestionnaireResponse|Attachment.content|-|
{:.grid}

The data element mapping table is available as a [CSV](data-element-mapping.csv) and [Excel](data-element-mapping.xlsx) file.

#### Payer Requests Attachments for Prior Authorization

In the first FHIR transaction, the Payer POSTs the CDex Task Attachment Request Profile to the Provider endpoint.

~~~
POST [base]/Task
~~~

**Request Body**

##### Task Resource

The optional profile declaration shown below asserts that the resource conforms to the profile and contains all the necessary data elements listed above.

<!-- The request body's various elements are annotated to show how each of the data elements is communicated to the Provider. -->

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=0 count=7 linenumber=true %}
~~~

##### Verifying Patient Identity

The following data elements are used to verify patient identity for compliance regulations (such as HIPAA). (How the Provider system verifies the patient is not covered in this guide.) The Payer communicates them in a  *contained* Patient resource using the [CDex Patient Demographics Profile]. This contained Patient is referenced in `Task.for.reference` using a fixed reference value of "#patient".:

|Data|HRex Patient Demographics Profile.|
|---|---|
|Member ID or Patient Account No.*|`Patient.identifier`|
|Patient Name|`Patient.name`|
|Patient DOB (optional)|`Patient.birthDate`|
{: .grid}

\* Patient Account No is a Provider assigned identifier and is only present for Prior-Auth use cases.


~~~
{% include_relative includelines filename='cdex-task-example22.json' start=7 count=51 linenumber=true %}
~~~

##### Supplying the Provider ID(s)

The Payer communicates the provider ID as either a unique organization/location identifier (e.g., Type 2 NPI) or unique provider identifier (e.g., Type 1 NPI) or both in a *contained* PractitionerRole resource using the [CDex PractitionerRole Profile]. This contained PractitionerRole is referenced in `Task.owner.reference` using a fixed reference value of "#practitionerrole".

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=58 count=22 linenumber=true %}
~~~

##### Supplying the Tracking ID

The mandatory `Task.identifier` "tracking-id" slice element represents the Payer tracking identifier.  This is an identifier that ties the attachments back to the claim or prior-auth and is echoed back to the Payer when submitting the attachments.  It is often referred to as the “re-association tracking control number”.


~~~
{% include_relative includelines filename='cdex-task-example22.json' start=80 count=16 linenumber=true %}
~~~

##### Task *status* and *intent* Elements

These required Task *infrastructural* elements:

- Task.status
- Task.intent

convey what the task status, and the intent of the request.  The Task.status value of "request" is typical when POSTing the Task-based attachment request. Note that the status will change as the Task at is moves through [different states](http://hl7.org/fhir/task.html#statemachine) in the workflow. Task.intent is fixed to "order".

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=96 count=2 linenumber=true %}
~~~

##### Task *code* Element

The Task.code communicates that the Payer is requesting attachments for a claim or prior authorization using a code or data request questionnaire. If the code is “attachment-request-code”, the provider system returns attachment(s) identified by the LOINC attachment code(s) in the “code” input parameter. If the code is “attachment-request-questionnaire”, as it is in this scenario, the provider system uses Documentation Templates and Rules (DTR) to complete the Questionnaire referenced in the “questionnaire” input parameter. When either code is present, the provider system uses the $submit-attachment operation to return the information to the endpoint provided in “payer-url” input parameter.

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=98 count=9 linenumber=true %}
~~~

##### Identifying the Payer, Provider, and Patient

The attachment request will be directed to the same Provider who submitted the claim or prior authorization. Business identifiers are used to identify the Patient, the Payer, and the Provider who submitted the claim, and these identifiers are echoed back to the Payer when submitting the attachments.

As discussed above, the Patient id is in the contained Patient resource, referenced by the Task.for element, and the Provider id is in the contained PractitionerRole resource referenced by the Task.owner element.  The Provider id can be a Practitioner identifier (i,e., a Type1 NPI) or the Practitioner's Organization identifier (i,e., a Type2 NPI) or both.

(note the various Task dates in the request fragment below)

|Actor|CDex claim Profile element|
|---|---|
|payer ID|`Task.reasonReference.identifier`|
|provider ID|(contained)PractitionerRole.practitioner.identifier and/or PractitionerRole.Organization.identifier|
|patient member ID or Patient Account No|(contained)Patient.identifier|
{: .grid}

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=107 count=14 linenumber=true %}
~~~

##### Claim Information

The Task communicates whether the attachments are for a claim or prior authorization and the claim or prior authorization ID is identified by its business Identifier. 

|Data|CDex Claim Profile element|
|---|---|
|Claim or Prior Authorization|`Task.reasonCode`|
|Claim or Prior Authorization ID|`Task.reasonReference.identifier`|
{: .grid}

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=121 count=16 linenumber=true %}
~~~

##### Attachment Due Date

The Due Date for attachment is communicated in the `Task.restriction.period`  element. Note that `Task.restriction.period.end` is the due date representing the time by which the attachments should be submitted.

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=137 count=5 linenumber=true %}
~~~

##### Using Questionnaire to Communicate What Attachments Data is Needed

In this scenario, the Payer supplies the URL of a questionnaire (FHIR Questionnaire) to communicate what attachments-related data is needed. Line item numbers may also be supplied to match the attachment to a line item in the claim or prior-auth. This information is represented in the “questionnaire” Task input element. The Provider launches the Documentation Templates and Rules (DTR) application to complete the Questionnaire. The code snippet below contains a URL to a Home Oxygen Therapy Questionnaire.

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=142 count=18 linenumber=true %}
~~~

<!-- {% raw %} ##### Communicating the Signature Requirements

 This Task.input "signature-flag" may be used to indicate that the attachments must be signed. See the [Signatures] and [Sending Attachments] page for more information about using Signatures in CDex.

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=154 count=11 linenumber=true %}
~~~ {% endraw %} -->

##### Supplying the $submit-attachment Operation Endpoint

The Payer supplies the url endpoint as a Task input parameter. The Provider System will use this information as the endpoint for the [`$submit-attachment`] Operation to send the completed QestionnaireResponse.

<!-- If no url endpoint is supplied the attachments are provided either as references or contained Task resources and the requester needs to poll/subscribe to the Task to retrieve when done. -->

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=160 count=11 linenumber=true %}
~~~

<!-- {% raw %} ##### Date of Service for the Claim

This Task.input element represents the service date or the service's starting date for the claim or prior authorization.  It SHALL be present and precise to the day if the attachment is for a claim. It is optional if the attachment is for prior authorization.

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=174 count=13 linenumber=true %}
~~~ {% endraw %} -->

##### Purpose of Use for the Request

This optional Task.input element represents the request's purpose of use (POU).  In this example, it is to support a request for a claim, "CLMATTCH".  When requesting attachments for prior-auth, it would be "COVAUTH".

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=171 count=21 linenumber=true %}
~~~

#### Provider Launches DTR

The Payer used a Questionnaire to ask for specific attachments-related data. They indicated it with a Task code "attachment-request-questionnaire" and supplied the URL of the questionnaire (FHIR Questionnaire) as an input parameter. Becasue these conditions are met, the Payer launches [Da Vinci DTR], a SMART on FHIR App or native EHR application. If the Provider launches a DTR within an EHR native application, skip to the step [DTR App Updates Task](#dtr-app-updates-task) below. If the Provider Launches DTR as a SMART on FHIR Application, it follows the [SMART's EHR launch flow] with the Task as the launch content. The next several steps describe the DTR SMART App functionality.

##### DTR SMART App Fetches Task

As part of the DTR launch, the local reference to the Task is passed to the DTR App.  The DTR App fetches the Task and inspects it for the Questionnaire URL.

**Request**

~~~
GET [base]/Task/cdex-task-example22
~~~

**Response Body**

~~~
{% include_relative includelines filename='cdex-task-example22.json' start="1,142" count="2,18" linenumber=true %}....
~~~

##### DTR SMART App Fetches Questionnaire

Upon discovery of the Questionnaire URL, the DTR App fetches the Questionnaire.

**Request**

~~~
GET http://example.org/FHIR/Questionnare/cdex-questionnaire-example1
~~~

**Response Body**

~~~
{% include_relative includelines filename='cdex-questionnaire-example1.json' linenumber=true %}
~~~

##### DTR App Fills QuestionnaireResponse

To complete the Questionnaire, the DTR App retrieves FHIR resources from EHRs, runs rules (CQL), and completes a QuestionnaireResponse.  See the [Da Vinci DTR] Implementation Guide for more information.

{% include img-small.html img="fill-form-icon.svg" %}

##### DTR App POSTs QuestionnaireResponse to Provider FHIR Server

The completed QuestionnaireResponse is saved in the Provider's FHIR Server.

**Request**

~~~
POST [base]/$QuestionnaireResponse
~~~

**Request Body**

~~~
{% include_relative includelines filename='cdex-questionnaireresponse-example1.json' linenumber=true %}
~~~

##### DTR App Updates Task

The DTR SMART App or EHR native application Updates Task.output to Reference the completed QuestionnaireResponse and Task.status to “completed”


~~~
PUT [base]/Task/cdex-task-example-22
~~~

**Request Body**

~~~
{% include_relative includelines filename='cdex-task-example24-updateid.json' start="0,96,189" count="3,1,15" linenumber=true %}
~~~


#### Provider Submits Solicited Attachments

When the Task is completed, the Provider POSTs the [`$submit-attachment`] operation and its payload to the Payer's endpoint. As stated above, the CDex Task Attachment Request Profile communicates the Payer endpoint to the Provider. The operation payload contains the completed QuestionnaireResponse and echoes many data elements sent in the request. The table in the introduction to this section summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters. The documentation below describes and demonstrates the [`$submit-attachment`] parameters.

**Request**

~~~
POST [base]/$submit-attachment
~~~

**Request Body**

##### The Submit Attachment Operation Payload

The QuestionnaireRespsonse along with the metadata needed to associate it to the claim or Pre-Auth are in the $submit-attachments payload, a [Parameters] resource.

~~~
{% include_relative includelines filename='cdex-parameters-example5.json' start=0 count=3 linenumber=true %}
~~~

##### Tracking ID and Indicating a Claim or Prior Authorization
The Tracking ID is an identifier that ties the attachments back to the claim or prior-auth.  It is often referred to as the “re-association tracking control number”.  The operation needs to indicate whether the attachments are for claim or prior-authorization. These data elements are taken from the CDex request as follows:

|Data Element|CDex Request Element|CDex #submit-attachment Parameter|
|---|---|---|
|TrackingID|Task.identifier|TrackingId|
|Use|Task.reasonCode|AttachTo|
{:.grid}

~~~
{% include_relative includelines filename='cdex-parameters-example5.json' start=3 count=11 linenumber=true %}
~~~   

##### Identifying the Payer, Provider, Organization, and Patient

As documented above, business identifiers are used to identify the Patient, the Payer, and the Provider who submitted the claim. These should be the same as communicated in the request.  The NPI should be used for the Practitioner and Organization IDs.

|Data Element|CDex Request Element|CDex #submit-attachment Parameter|
|---|---|---|
|Payer URL|"payer-url"Task.input|(operation endpoint)|
|Organization ID|PractitionerRole.organization.identifier|OrganizationId|
|Provider ID|PractitionerRole.practitioner.identifier|ProviderId|
|Member ID|Patient.identifier|MemberId|
{:.grid}

~~~
{% include_relative includelines filename='cdex-parameters-example5.json' start=14 count=28 linenumber=true %}
~~~ 


##### The Service Date

The service date parameter is taken from the “service-date” Task.input element in the CDex Attachment request.


~~~
{% include_relative includelines filename='cdex-parameters-example5.json' start=42 count=4 linenumber=true %}
~~~ 


##### Supply the QuestionnaireResponse

The completed QuestionnaireResponse and the corresponding line item numbers are communicated as named parts of the multi-part Attachment parameter. The Attachment.content parameter represents the QuestionnaireResponse as an inline FHIR resource. The Attachment.LineItem parameter lists the line item numbers associated with it.

 <!-- What attachments are returned are determined by the CDex Attachment requests in `Task.input` "code" or "query" slices.  These may be coded in LOINC or non-LOINC, free text, or FHIR RESTful search syntax queries.  Codes are represented in the Attachment.code parameter part in the `valueCodeableConcept.Coding` field and free text or FHIR RESTful search syntax queries are represented in `valueCodeableConcept.text` field. Line item numbers associated with a requested item are communicated in the Attachment.LineItem parameter part.
  -->

|Data Element|CDex Request Element|CDex #submit-attachment Parameter|
|---|---|---|
|line item(s)|“code”Task.input.extension|Attachment.LineItem|
|QuestionnaireResponse|-|Attachment.content
{:.grid}

~~~
{% include_relative includelines filename='cdex-parameters-example5.json' start=46 count=69 linenumber=true %}
~~~



### Complete *Solicited* Attachment Transaction

The complete *solicited* attachment transaction using the combination of a Task-based CDex Task Attachment Request Profile to request attachments and the [`$submit-attachment`] operation to submit the attachments to the Payer is shown below:

{% include examplebutton_default.html example="solicited-attachment-scenario-2.md" b_title = "Click Here To See FHIR Based Solicited Attachment Example" %}

### Signatures

<!-- Update signatures section when using QuestionnaireResponse -->

Refer to the [Signatures section](sending-attachments.html#signatures) in the Sending Attachments page.  

{% include link-list.md %}