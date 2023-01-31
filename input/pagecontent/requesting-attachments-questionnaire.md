

This page documents an *optional* solicited attachments transaction for requesting additional claims or prior authorization data from a Provider using FHIR [Questionnaire].\* The Payer uses the Task-based [CDex Task Attachment Request Profile] to request a Provider to complete a questionnaire. The Provider launches [Da Vinci DTR] to complete the questionnaire and, as documented in the [Sending Attachments] page, submits the completed questionnaire to the Payer using the [`$submit-attachment`] operation. In contrast to [Requesting Attachments Using Attachment Codes], a HIPAA-based request model using LOINC attachment codes, it supports using Questionnaire to define in more detail what data is missing. As a result, it avoids unnecessary documents. In addition, it leverages [Da Vinci DTR] functionality to fill out the Questionnaire reducing the time involved in reviewing documentation requirements.

\* {% include see-conf.md %}

### Request Attachments Data Using a FHIR Questionnaire

The [Task Based Approach] page documents why a Data Consumer should use Task for requesting attachments. For more background on Task-based transactions, see the [Requesting Exchange using Task] section of the Da Vinci HRex Implementation Guide. **For CDex attachment requests transactions, the Payer SHALL use the [CDex Task Attachment Request Profile] to solicit information from a Provider.** 
<!-- {% raw %} {{ site.data.resources.['StructureDefinition/cdex-task-attachment-request']['description'] }} {% endraw %} -->
For a detailed description of all the mandatory, [*must support*], and optional elements, as well as formal definitions and profile views, see the [CDex Task Data Request Profile] page.

 In contrast to [Requesting Attachments Using Attachment Codes], when a Payer references a FHIR Questionnaire as an input parameter, the Task represents a request for the Provider to complete the questionnaire (form). The [CDex Task Attachment Request Profile] defines a specific `Task.code` that directs the Provider to launch a [Da Vinci - Coverage Requirements Discovery (DTR)] application to use the Payer provided Questionnaire and results from any CQL execution to generate and complete a  QuestionnaireResponse. Figure 17 below summarizes the steps for requesting and completing a questionnaire using CDex Attachments and DTR, and the sequence diagram in the following section illustrates these transactions in more detail:

{% include img.html img="attachments-task-Q-summary.svg" caption = "Figure 17" %}

**Step 1:** The Payer POSTs a Task directly to the Provider. The Task is a request to complete a questionnaire.

**Step 2:** if the Task.code is "attachment-request-questionnaire", the Provider launches DTR and shares the Task as a launch parameter (i.e., DTR has access to read and update the Task and access to other resources to complete the QuestionnaireResponse in Step 3)

**Step 3:** DTR fetches the Task, which contains the link to the Questionnaire. Then fetches the Questionnaire (and any CQL rules defined within it) and proceeds to complete the QuestionnaireResponse. Refer to the [Da Vinci DTR] Implementation Guide for more information on how it generates a QuestionnaireResponse.

**Step 4:** After completing the QuestionnaireResponse, DTR POSTs it directly to the Provider's FHIR Server, updates Task.output to reference the QuestionnaireResponse it created, and updates Task.status to "completed".

**Step 5:** The Provider "pushes" the QuestionnaireResponse directly to the Payer-defined endpoint using the $submit-attachments operation. See the [Sending Attachments] page for Implementation Guide for more information on this transaction.

#### Using [Da Vinci DTR] to Complete the Questionnaire

The sequence diagram in the Figure 18 below depicts the the FHIR RESTful transactions  and processes involved between the Payer, Provider, and DTR application application needed to request, fill, and return a questionnaire using using CDex Attachments.  It references a "DTR Launch". If the DTR is a native EHR application, the launch is implementation specific. If DTR is a SMART on FHIR Application, the next ([DTR SMART App Launch]) section documents the launch sequence and parameters.

{% include img.html img="attachments-task-Q-sequencediagram.svg" caption = "Figure 18" %}

##### DTR SMART App Launch

The sequence diagram in Figure 19 below depicts the transactions between the DTR Client, FHIR Server, and DTR application needed to launch a DTR SMART App.

Preconditions and Assumptions:
- The DTR Client, and FHIR Server are Provider (Data Source) roles.
- If the DTR is a native EHR application, the launch is implementation specific, and this diagram does not apply.
- A User kicks off [Smart Version 2.0.0 EHR launch flow].

<!-- {% raw %} {% include img.html img="SMART App Launch for DTR from CDEX.png" caption="Figure 19: My Notes on SMART App Launch for DTR from CDEX" %} {% endraw %} -->

{% include img.html img="dtr-launch.svg" caption="Figure 19" %}

**Step 1 (Optional):** The DTR App registers with DTR Client (may be out of band)

**Step 2,3:** If the Task.code is "attachment-request-questionnaire" (or "data-request-questionnaire" for a Task-based approach), a User initiates [Smart Version 2.0.0 EHR launch flow] to launch DTR (for example, clicks a button to launch DTR) and DTR Client sends a launch request to the DTR App

**Step 4:** DTR App retrieves the `.well-known/smart-configuration` from FHIR Server.

**Step 5:** DTR App request authorization code requesting the following scopes:
  - "launch"
  - "launch/patient"
  - "launch/task"
  - "patient/*.rs"
  - "patient/Task.u"
  - "patient/QuestionnaireResponse.cu"
  
**Step 6,7:** Assuming the authorization is granted, The DTR app requests an access token

**Step 8:**  DTR App obtains an access token and the launch contexts in the "fhirContext" array, including a local reference to the Task in step 2.

**Step 9:** The DTR App uses the Task reference obtained in step 8 to fetch it, the Questionnaire, and other resources to fill out a QuestionnaireResponse. See the [previous section](#using-da-vinci-dtr-to-complete-the-questionnaire) (or [this section](task-based-approach.html#using-da-vinci-dtr-to-complete-the-questionnaire) on the Task Based Approach page) for more detailed transactions.

### Data Elements for Requesting Attachments

The [Requesting Attachments Using Attachment Codes] page documents the data elements needed to associate an attachment to a claim or prior authorization.  However, there is no "LOINC Attachment Code" Data element when using Questionnaires to collect attachments-related data.

### *Step-by-Step* Solicited Attachment Transaction

<div class="bg-info" markdown="1">

In the following sections, A detailed look at an example *Solicited* attachment transaction illustrates how:
- The Payer uses a FHIR Questionnaire to communicate to the Provider what additional attachments-related data is needed.
- The Payer uses the CDex Task Attachment Request Profile to communicate to the Provider to complete the Questionniare.
- The Provider launches DTR to fill out the FHIR Questionnaire using QuestionnaireResponse.
- The DTR completes the QuestionaireResponse and updates the Task.
- The Provider uses the $submit-attachment operation to communicate the completed QuestionnaireResponse to the Payer.
</div><!-- bg-info -->

In this scenario, a Provider creates a prior authorization and sends it to the Payer. The Payer reviews the prior authorization and responds with a request to fill out a questionnaire for attachments-related data using the *CDex Attachment Request Profile*. After receiving the attachment request, the Provider launches DTR, which completes a QuestionnaireResponse. The Provider returns the QuestionnaireResponse using the [`$submit-attachment`] operation, posting it to the endpoint supplied in the request. The flow diagram in figure 20 below illustrates the scenario.


{% include img.html img="cdex-request-questionnaire-priorauth-flow.svg" caption="Figure 20: CDex Request Attachment for Prior-Auth Using Questionnaires" %}

In addition to the information needed to submit and associate the attachments to the claim successfully, the Payer supplies the following details about what information is necessary to complete the adjudication of the claim:

- link to the Questionnaire
- What line numbers on the claim the requested attachment(s) are for
- The specific purpose of use (POU) for the request

The table below summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters:

{% include q-attachments_to_requests.md %}

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

The following data elements are used to verify the patient's identity. (This guide does not cover how the Provider system verifies the patient's identity.) They are communicated in a  *contained* Patient resource using the [CDex Patient Demographics Profile]. The contained Patient is referenced in `Task.for.reference` using a fixed reference value of "#patient".

|Data|HRex Patient Demographics Profile.|
|---|---|
|Member ID or Patient Account No.*|`Patient.identifier`|
|Patient Name|`Patient.name`|
|Patient DOB (optional)|`Patient.birthDate`|
{: .grid}

\* Patient Account Number is a Provider assigned identifier
 

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=7 count=51 linenumber=true %}
~~~

##### Supplying the Provider ID(s)

The Payer communicates the provider ID as either a unique organization/location identifier (e.g., Type 2 NPI) or unique provider identifier (e.g., Type 1 NPI) or both in a *contained* PractitionerRole resource using the [CDex PractitionerRole Profile]. This contained PractitionerRole is referenced in `Task.owner.reference` using a fixed reference value of "#practitionerrole".

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=58 count=22 linenumber=true %}
~~~

##### Supplying the Tracking ID

The mandatory `Task.identifier` *tracking-id* slice element represents the Payer tracking identifier. The tracking-id (also called the "re-association tracking control number") is an identifier that ties the attachments back to the claim or prior authorization. The Provider will echo it back to the Payer when submitting the attachments. 


~~~
{% include_relative includelines filename='cdex-task-example22.json' start=80 count=16 linenumber=true %}
~~~

##### Task *status* and *intent* Elements

These required Task infrastructure elements:

- Task.status
- Task.intent

convey the task status, and the intent of the request.  The Task.status value of "request" is typical when POSTing the Task-based attachment request. Note that the status will change as the Task moves through [different states](http://hl7.org/fhir/task.html#statemachine) in the workflow. Task.intent is fixed to "order".

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

|Actor|CDex Request Attachment Task Profile Element|
|---|---|
|payer ID|`Task.requester.identifier`|
|provider ID|(contained)PractitionerRole.practitioner.identifier and/or PractitionerRole.Organization.identifier|
|patient member ID or Patient Account No|(contained)Patient.identifier|
{: .grid}

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=107 count=14 linenumber=true %}
~~~

##### Claim Information

The Task communicates whether the attachments are for a claim or prior authorization, and the Payer identifies the claim or prior authorization with its business Identifier.

|Data|CDex Request Attachment Task Profile Element|
|---|---|
|Claim or Prior Authorization|`Task.reasonCode`|
|Claim or Prior Authorization ID|`Task.reasonReference.identifier`|
{: .grid}

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=121 count=16 linenumber=true %}
~~~

##### Attachment Due Date

The Payer communicates the due date for submitting the attachment in the `Task.restriction.period` element. Note that `Task.restriction.period.end` is the due date representing the time by which the Provider should have submitted the attachments.

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=137 count=5 linenumber=true %}
~~~

##### Using Questionnaire to Communicate What Attachments Data is Needed

In this scenario, the Payer supplies the URL of a questionnaire (FHIR Questionnaire) to communicate what attachments-related data is needed. Line item numbers may also be supplied to match the attachment to a line item in the claim or prior authorization. This information is represented in the “questionnaire” Task input element. The Provider launches the Documentation Templates and Rules (DTR) application to complete the Questionnaire. The code snippet below contains a URL to a Home Oxygen Therapy Questionnaire.

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=142 count=18 linenumber=true %}
~~~

<!-- {% raw %} ##### Communicating the Signature Requirements

 This Task.input "signature-flag" may be used to indicate that the attachments must be signed. See the [Signatures] and [Sending Attachments] page for more information about using Signatures in CDex.

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=154 count=11 linenumber=true %}
~~~ {% endraw %} -->

##### Supplying the $submit-attachment Operation Endpoint

The Payer supplies the URL endpoint as a Task input parameter. The Provider System will use this information as the endpoint for the [`$submit-attachment`] Operation to send the completed QuestionnaireResponse. Note that the endpoint is not necessarily a FHIR RESTful server endpoint.

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

This optional Task.input element represents the request's purpose of use (POU).  In this example, it is to support a request for a claim, "CLMATTCH".  When requesting attachments for prior authorization, it would be "COVAUTH".

~~~
{% include_relative includelines filename='cdex-task-example22.json' start=171 count=21 linenumber=true %}
~~~

#### Provider Launches DTR

The Payer used a Questionnaire to ask for specific attachments-related data. They indicated it with a Task code "attachment-request-questionnaire" and supplied the URL of the questionnaire (FHIR Questionnaire) as an input parameter. Becasue these conditions are met, the Payer launches [Da Vinci DTR], a SMART on FHIR App or native EHR application. If the Provider launches a DTR within an EHR native application, skip to the step [DTR App Updates Task](#dtr-app-updates-task) below. If the Provider Launches DTR as a SMART on FHIR Application, it follows the [Smart Version 2.0.0 EHR launch flow] with the Task as the launch content. The next several steps describe the DTR SMART App functionality.

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

When the Task is completed, the Provider POSTs the [`$submit-attachment`] operation and its payload to the Payer's endpoint. As stated above, the Payer communicates the operation endpoint to the Payer in the CDex Task Attachment Request Profile. The operation payload contains the completed QuestionnaireResponse and echoes many data elements sent in the request. The table in the introduction to this section summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters. The documentation below describes and demonstrates the [`$submit-attachment`] parameters.

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

The QuestionnaireResponse along with the metadata needed to associate it to the claim or prior authorization are in the $submit-attachments payload, a [Parameters] resource.

~~~
{% include_relative includelines filename='cdex-parameters-example5.json' start=0 count=3 linenumber=true %}
~~~

##### Tracking ID and Indicating a Claim or Prior Authorization
The TrackingId parameter represents the identifier that ties the attachments to the claim or prior authorization. It is often referred to as the "re-association tracking control number". The operation must indicate whether the attachments are for claim or prior authorization. These data elements are taken from the CDex request as follows:

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|TrackingID|Task.identifier|TrackingId|
|Use|Task.reasonCode|AttachTo|
{:.grid}

~~~
{% include_relative includelines filename='cdex-parameters-example5.json' start=3 count=11 linenumber=true %}
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
{% include_relative includelines filename='cdex-parameters-example5.json' start=14 count=28 linenumber=true %}
~~~ 


<!-- {% raw %} ##### The Service Date

The service date parameter is taken from the “service-date” Task.input element in the CDex Attachment request.


|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|Date of Service|“service-date” Task.input|ServiceDate|
{:.grid}

~~~
{% include_relative includelines filename='cdex-parameters-example5.json' start=42 count=4 linenumber=true %}
~~~  {% endraw %} -->


##### Supply the QuestionnaireResponse

The completed QuestionnaireResponse and the corresponding line item numbers are communicated as named parts of the multi-part Attachment parameter. The Attachment.content parameter represents the QuestionnaireResponse as an inline FHIR resource. The Attachment.LineItem parameter lists the line item numbers associated with it.

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|line item(s)|“code”Task.input.extension|Attachment.LineItem|
|QuestionnaireResponse|-|Attachment.content
{:.grid}

~~~
{% include_relative includelines filename='cdex-parameters-example5.json' start=42 count=69 linenumber=true %}
~~~



### Complete *Solicited* Attachment Transaction

The example below shows the complete *solicited* attachment transaction. A Payer uses the CDex Task Attachment Request Profile to request the attachment using an attachment code, and the Provider uses the [`$submit-attachment`] operation to submit the attachments to the Payer:

{% include examplebutton_default.html example="solicited-attachment-scenario-2.md" b_title = "Click Here To See FHIR Based Solicited Attachment Example" %}

### Signatures

Refer to the [Signatures section](sending-attachments.html#signatures) in the Sending Attachments page.  

{% include link-list.md %}