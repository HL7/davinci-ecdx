

This page documents an *optional* solicited attachments transaction for requesting additional claims or prior authorization data from a Provider using FHIR [Questionnaire].\* The Payer uses the Task-based [CDex Task Attachment Request Profile] to request a Provider to complete one or more questionnaires. The Provider launches [Da Vinci DTR] to complete the questionnaires and, as documented in the [Sending Attachments] page, submits the completed questionnaires to the Payer using the [`$submit-attachment`] operation. In contrast to [Requesting Attachments Using Attachment Codes], a HIPAA-based request model using attachment codes, it supports using FHIR Questionnaire to define in more detail what data is missing. As a result, it avoids unnecessary documents. In addition, it leverages [Da Vinci DTR] functionality to fill out the FHIR Questionnaire, reducing the time spent reviewing documentation requirements.

\* {% include see-conf.md %}



### Requesting Attachments Using FHIR

{% include task-based-sections-to-review.md %}

### Requesting Attachments Using FHIR Questionnaires



 In contrast to [Requesting Attachments Using Attachment Codes], when a Payer references one or more FHIR Questionnaires  as input parameters, the Task represents a request for the Provider to complete the questionnaires. The [CDex Task Attachment Request Profile] defines a specific `Task.code` that directs the Provider to launch a [Da Vinci - Documentation Templates and Rules (DTR)] application to use the Payer provided Questionnaires and results from any CQL execution to generate and complete a  QuestionnaireResponse. Figure 17 below summarizes the steps for requesting and completing a questionnaire using CDex Attachments and DTR, and the sequence diagram in the following section illustrates these transactions in more detail:

{% include img.html img="attachments-task-Q-summary.svg" caption = "Figure 17" %}

**Step 1:** The Payer POSTs a Task to the Provider. The Task is a request to complete a questionnaire.

**Step 2:** If the `Task.code` is "attachment-request-questionnaire", the Provider launches DTR and shares the Task as a launch parameter (i.e., DTR has access to read and update the Task and access to other resources to complete the QuestionnaireResponse in Step 3)

**Step 3:** DTR fetches the Task, which contains the link to the Questionnaire. Then, it fetches the Questionnaire (and any CQL rules defined within it) and completes the QuestionnaireResponse. Refer to the [Da Vinci DTR] Implementation Guide for more information on how it generates a QuestionnaireResponse.

**Step 4:** DTR creates and updates the QuestionnaireResponse directly to the Data Source's FHIR Server and updates `Task.output` to reference the QuestionnaireResponse it created..

**Step 5:**  When the QuestionnaireResponse is completed, the Provider "pushes"  the QuestionnaireResponse directly to the Payer-defined endpoint using the $submit-attachments operation. See the [Sending Attachments] page for Implementation Guide for more information on this transaction.

**Step 6:** The Provider updates the Task to "completed" when complete - e.g., when the data has been submitted or the information gathered.


#### Using [Da Vinci DTR] to Complete the Questionnaire

The sequence diagram in Figure 18 below depicts the FHIR RESTful transactions and processes involved between the Payer, Provider, and DTR application application needed to request, fill, and return one or more questionnaires using using CDex Attachments.  It references a "DTR Launch". If the DTR is a native EHR application, the launch is implementation specific. If DTR is a SMART on FHIR Application, the next ([DTR SMART App Launch]) section documents the launch sequence and parameters.

{% include img.html img="attachments-task-Q-sequencediagram.svg" caption = "Figure 18" %}

##### DTR SMART App Launch

The sequence diagram in Figure 19 below depicts the transactions between the DTR Client, FHIR Server, and DTR application needed to launch a DTR SMART App.

Preconditions and Assumptions:
- The DTR Client and FHIR Server are Provider (Data Source) roles.
- If the DTR is a native EHR application, the launch is implementation specific and this diagram does not apply.
- A User kicks off [Smart Version 2.0.0 EHR launch flow].

<!-- {% raw %} {% include img.html img= "SMART App Launch for DTR from CDEX.png" caption=" Figure 19: My Notes on SMART App Launch for DTR from CDEX" %} {% endraw %} -->

{% include img.html img="dtr-launch.svg" caption="Figure 19" %}

**Step 1 (Optional):** The DTR App registers with DTR Client (may be out of band)

**Step 2,3:** If the `Task.code` is "attachment-request-questionnaire" (or "data-request-questionnaire" for the Task Based Approach), a User initiates [Smart Version 2.0.0 EHR launch flow] to launch DTR (for example, clicks a button to launch DTR) and DTR Client sends a launch request to the DTR App

**Step 4:** The DTR App retrieves the `.well-known/smart-configuration` from FHIR Server.

**Step 5:** The DTR App requests an authorization code with the following scopes:
  - "launch"
  - "launch/patient"
  - "launch/task"
  - "patient/*.rs"
  - "patient/Task.u"
  - "patient/QuestionnaireResponse.cu"
  
**Step 6,7:** Assuming the authorization is granted, The DTR app requests an access token

**Step 8:** The DTR App obtains an access token and the launch contexts in the "fhirContext" array, including a local reference to the Task in step 2.

**Step 9:** The DTR App uses the Task reference obtained in step 8 to fetch the Task, Questionnaire(s), and other resources it needs to fill out a QuestionnaireResponse(s). See the [previous section](#using-da-vinci-dtr-to-complete-the-questionnaire) (or [this section](task-based-approach.html#using-da-vinci-dtr-to-complete-the-questionnaire) on the Task Based Approach page) for more detailed transactions.

### Data Elements for Requesting Attachments

The [Requesting Attachments Using Attachment Codes] page documents the data elements needed to associate an attachment to a claim or prior authorization.  However, there is no "Attachment Code" Data element when using Questionnaires to collect attachments-related data.

### *Step-by-Step* Solicited Attachment Transaction

<div class="bg-info" markdown="1">

In the following sections, A detailed look at an example *Solicited* attachment transaction illustrates how:
- The Payer uses a FHIR Questionnaire to communicate to the Provider what additional attachments-related data is needed.
- The Payer uses the CDex Task Attachment Request Profile to communicate to the Provider to complete the Questionnaire.
- The Provider launches DTR to fill out the FHIR Questionnaire using QuestionnaireResponse.
- The DTR completes the QuestionaireResponse and updates the Task.
- The Provider uses the $submit-attachment operation to communicate the completed QuestionnaireResponse to the Payer.
</div><!-- bg-info -->

In this scenario, a Provider creates a prior authorization and sends it to the Payer. The Payer reviews the prior authorization and responds with a request to fill out a questionnaire for attachments-related data using the *CDex Attachment Request Profile*. After receiving the attachment request, the Provider launches DTR, which completes a QuestionnaireResponse. The Provider returns the QuestionnaireResponse using the [`$submit-attachment`] operation, posting it to the endpoint supplied in the request. The flow diagram in figure 20 below illustrates the scenario.


{% include img.html img="cdex-request-questionnaire-priorauth-flow.svg" caption=" Figure 20: CDex Request Attachment for Prior-Auth Using Questionnaires" %}

In addition to the information needed to submit and associate the attachments to the claim successfully, the Payer supplies the following details about what information is necessary to complete the adjudication of the claim:

- A link to the Questionnaire(s)
- Line numbers on the claim the requested attachment(s) are for
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

<!-- The request body's various elements are annotated to show how each data element is communicated to the Provider. -->

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=0 count=2 linenumber=true rel=true %}
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
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=2 count=35 linenumber=true rel=true %}
~~~

##### Supplying the Provider ID(s)

The Payer communicates the provider ID as either a unique organization/location identifier (e.g., Type 2 NPI), unique provider identifier (e.g., Type 1 NPI), or both in a *contained* PractitionerRole resource using the [CDex PractitionerRole Profile]. This contained PractitionerRole is referenced in `Task.owner.reference` using a fixed reference value of "#practitionerrole".

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=37 count=15 linenumber=true rel=true %}
~~~

##### Supplying the Tracking ID

The mandatory `Task.identifier` *tracking-id* slice element represents the Payer tracking identifier. The tracking-id (the "re-association tracking control number") is an identifier that ties the attachments back to the claim or prior authorization. The Provider will echo it back to the Payer when submitting the attachments. 


~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=53 count=12 linenumber=true rel=true %}
~~~

##### Task *status* and *intent* Elements

These required Task infrastructure elements:

- `Task.status`
- `Task.intent`

convey the task status and the intent of the request.  The `Task.status` value of "request" is typical when POSTing the Task-based attachment request. The status will change as the Task moves through the workflow based on the [Task state machine]. `Task.intent` is fixed to "order".

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=65 count=2 linenumber=true rel=true %}
~~~

##### Task *code* Element

The `Task.code` communicates that the Payer is requesting attachments for a claim or prior authorization using a code or data request questionnaire. If the code is "attachment-request-code", the provider system returns attachment(s) identified by the attachment code(s) in the "code" input parameter. If the code is "attachment-request-questionnaire", as it is in this scenario, the provider system uses Documentation Templates and Rules (DTR) to complete the Questionnaire referenced in the "questionnaire" input parameter. The provider system uses the $submit-attachment operation to return the information to the endpoint provided in the `Task.input` "payer-url" parameter.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=67 count=7 linenumber=true rel=true %}
~~~

##### Identifying the Payer, Provider, and Patient

The attachment request will be directed to the same Provider who submitted the claim or prior authorization. Business identifiers are used to identify the Patient, the Payer, and the Provider who submitted the claim, and these identifiers are echoed back to the Payer when submitting the attachments.

As discussed above, the patient ID is in the contained Patient resource, referenced by the `Task.for` element, and the provider ID is in the contained PractitionerRole resource, referenced by the `Task.owner` element. The provider ID can be a Practitioner identifier (i.e., a Type1 NPI), the Practitioner's Organization identifier (i.e., a Type2 NPI), or both.

(note the various Task dates in the request fragment below)

|Actor|CDex Request Attachment Task Profile Element|
|---|---|
|payer ID|`Task.requester.identifier`|
|provider ID|(contained)PractitionerRole.practitioner. identifier or PractitionerRole.Organization.identifier|
|patient member ID or Patient Account No|(contained)Patient.identifier|
{: .grid}

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=74 count=14 linenumber=true rel=true %}
~~~

##### Claim Information

The Task communicates whether the attachments are for a claim or prior authorization, and the Payer identifies the claim or prior authorization with its business identifier.

|Data|CDex Request Attachment Task Profile Element|
|---|---|
|Claim or Prior Authorization|`Task.reasonCode`|
|Claim or Prior Authorization ID|`Task.reasonReference.identifier`|
{: .grid}

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=88 count=16 linenumber=true rel=true %}
~~~

##### Attachment Due Date

The Payer communicates the due date for submitting the attachment in the `Task.restriction.period` element. Note that `Task.restriction.period.end` represents the time when the Provider should have submitted the attachments.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=102 count=5 linenumber=true rel=true %}
~~~

##### Using Questionnaire to Communicate What Attachments Data is Needed

In this scenario, the Payer supplies the URL of a questionnaire (FHIR Questionnaire) to communicate what attachments-related data is needed. They may also provide the *line item numbers* to match the attachment to a line item in the claim or prior authorization.  This information is represented in the "questionnaire" `Task.input` element. The Provider launches the Documentation Templates and Rules (DTR) application to complete the Questionnaire. The code snippet below contains a URL to a Home Oxygen Therapy Questionnaire.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=107 count=13 linenumber=true rel=true %}
~~~

<!-- {% raw %} ##### Communicating the Signature Requirements

This `Task.input` "signature-flag" may indicate that the Provider must sign the attachments. For more information about using signatures in CDex, see the [Signatures] and [Sending Attachments] pages.

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=154 count=11 linenumber=true rel=true %}
~~~ {% endraw %} -->

##### Supplying the $submit-attachment Operation Endpoint

The Payer supplies the URL endpoint in the `Task.input` "payer-url" parameter. The Provider System uses this endpoint for the [`$submit-attachment`] operation to send the completed QuestionnaireResponse. Note that it is not necessarily a FHIR RESTful server endpoint.

<!-- If no URL endpoint is supplied, the attachments are provided either as references or contained Task resources, and the requester needs to poll/subscribe to the Task to retrieve when done. -->

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=120 count=11 linenumber=true rel=true %}
~~~

<!-- {% raw %} ##### Date of Service for the Claim

This `Task.input` element represents the service date or the service's starting date for the claim or prior authorization.  It is optional if the attachment is for a prior authorization.  If the attachment is for a claim, it **SHALL** be present and precise to the day. 

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=174 count=13 linenumber=true rel=true %}
~~~ {% endraw %} -->

##### Purpose of Use for the Request

This optional `Task.input` element represents the request's purpose of use (POU).  This example supports a request for prior authorization, "COVAUTH".  When requesting attachments for a claim, it would be "CLMATTCH".

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start=129 count=21 linenumber=true rel=true %}
~~~

#### Provider Launches DTR

The Payer used a Questionnaire to ask for specific attachments-related data. They indicated it with a `Task.code` "attachment-request-questionnaire" and supplied the URL of the questionnaire (FHIR Questionnaire) as an input parameter. Becasue these conditions are met, the Payer launches [Da Vinci DTR], a SMART on FHIR App or native EHR application. If the Provider launches a DTR within an EHR native application, skip to the step [DTR App Updates Task](#dtr-app-updates-task) below. If the Provider Launches DTR as a SMART on FHIR Application, it follows the [DTR SMART App Launch] with the Task as the launch content. The next several steps describe the DTR SMART App functionality.

##### DTR SMART App Fetches Task

A reference to the Task is passed to the DTR App as part of the DTR launch. The DTR App fetches the Task and inspects it for the Questionnaire URL.

**Request**

~~~
GET [base]/Task/cdex-task-example22
~~~

**Response Body**

~~~
{% include_relative includelines filename='Task-cdex-task-inline-example22.json' start="0,112" count="2,8" linenumber=true rel=true %}....
~~~

##### DTR SMART App Fetches Questionnaire

Upon discovery of the Questionnaire URL, the DTR App fetches the Questionnaire.

**Request**

~~~
GET http://example.org/FHIR/Questionnare/cdex-questionnaire-example1
~~~

**Response Body**

~~~
{% include_relative includelines filename='Questionnaire-cdex-questionnaire-example1.json' linenumber=true rel=true %}
~~~

##### DTR App Fills QuestionnaireResponse

To complete the Questionnaire, the DTR App retrieves FHIR resources from EHRs, runs rules (such as [CQL]) for form population, and completes a QuestionnaireResponse.  See the [Da Vinci DTR] Implementation Guide for more information.

{% include img-small.html img="fill-form-icon.svg" %}

##### DTR App POSTs QuestionnaireResponse to Provider FHIR Server

The completed QuestionnaireResponse is saved in the Provider's FHIR Server.

**Request**

~~~
POST [base]/$QuestionnaireResponse
~~~

**Request Body**

~~~
{% include_relative includelines filename='QuestionnaireResponse-cdex-questionnaireresponse-inline-example1.json' linenumber=true rel=true %}
~~~

##### DTR App Updates Task

The DTR SMART App or EHR native application Updates `Task.output` to Reference the completed QuestionnaireResponse.


~~~
PUT [base]/Task/cdex-task-example-22
~~~

**Request Body**

~~~
{% include_relative includelines filename='cdex-task-inline-example22-updated.json' start="0,202" count="3,15" linenumber=true %}
~~~


#### Provider Submits Solicited Attachments

When the Task is completed, the Provider POSTs the [`$submit-attachment`] operation and its payload to the Payer's endpoint communicated in the `Task.input` "payer-url" parameter. The operation payload contains the completed QuestionnaireResponse(s) and echoes many data elements sent in the request. The table in the introduction to this section summarizes the mapping between the CDex Request Attachment Profile elements and the [`$submit-attachment`] parameters. The documentation below describes and demonstrates the [`$submit-attachment`] parameters.

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
{% include_relative includelines filename='Parameters-cdex-parameters-example5.json' start=0 count=3 linenumber=true rel=true %}
~~~

##### Tracking ID and Indicating a Claim or Prior Authorization
The TrackingId parameter represents the identifier that ties the attachments to the claim or prior authorization. It is often referred to as the "re-association tracking control number". The operation must indicate whether the attachments are for claim or prior authorization. These data elements are taken from the CDex request as follows:

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|TrackingID|Task.identifier|TrackingId|
|Use|Task.reasonCode|AttachTo|
{:.grid}

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example5.json' start=3 count=11 linenumber=true rel=true %}
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
{% include_relative includelines filename='Parameters-cdex-parameters-example5.json' start=14 count=28 linenumber=true rel=true %}
~~~ 


<!-- {% raw %} ##### The Service Date

The service date parameter is taken from the "service-date" `Task.input` element in the CDex Attachment request.


|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|Date of Service|“service-date” Task.input|ServiceDate|
{:.grid}

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example5.json' start=42 count=4 linenumber=true rel=true %}
~~~  {% endraw %} -->


##### Supply the QuestionnaireResponse

The completed QuestionnaireResponse and line item numbers are communicated as "Attachment" parameter parts. The QuestionnaireResponse is in the `Attachment.Content` parameter part as an inline FHIR resource, and the line item numbers associated with it are sent in the `Attachment.LineItem` parameter part.

|Data Element|CDex Request Attachment Task Profile Element|CDex #submit-attachment Parameter|
|---|---|---|
|line item(s)|“code”Task.input.extension|Attachment.LineItem|
|QuestionnaireResponse|-|Attachment.content
{:.grid}

~~~
{% include_relative includelines filename='Parameters-cdex-parameters-example5.json' start=42 count=69 linenumber=true rel=true %}
~~~



### Complete *Solicited* Attachment Transaction

The example below shows the complete *solicited* attachment transaction. A Payer uses the CDex Task Attachment Request Profile to request the attachment using an attachment code, and the Provider uses the [`$submit-attachment`] operation to submit the attachments to the Payer:

{% include examplebutton_default.html example="solicited-attachment-scenario-2.md" b_title = "Click Here To See FHIR Based Solicited Attachment Example" %}

### Signatures

Refer to the [Signatures section](sending-attachments.html#signatures) on the Sending Attachments page.

<br/><br/>

{% include link-list.md %}