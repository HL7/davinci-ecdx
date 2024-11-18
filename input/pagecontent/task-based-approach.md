
### Introduction

This guide uses a Task Based Approach to satisfy the Data Consumer's need to request the information it needs when it can not perform a direct query. The following factors determine whether to use this approach:

- Access to the data is restricted, and specific authorization is needed (for example, due to patient privacy concerns, the data needs to be reviewed or filtered)
- The appropriateness of the request needs to be determined
- The data needed is described in an unstructured or non-computable form. For example:
  - The Data Consumer may not know specific codes or identifiers to make a direct query
  - The Data Consumer can only request the data using free text - there is no way to describe the data in a structured format.
- The Data Consumer requests the data using FHIR [Questionnaire].  
- A Direct Query is otherwise not feasible

In most situations, a provider or designated staff must find, aggregate, filter, or approve the release of the data. However, in other use cases, mutually agreed upon data sets for specific purposes can be automatically fulfilled without human intervention.

### Benefits

- Easy ability for Task recipient to say "yes" or "no", including providing a reason for refusal.
- Allows linking the request to its associated outputs without creating a new resource
- Can use polling or subscriptions to retrieve the results
- As trust and infrastructure enable direct queries to evolve, it enables a transition strategy toward direct queries to gather data of interest
- Allows conveying the 'status' of a request in progress
   - Monitoring for status does not require a change in workflow from monitoring for final results - i.e., there is no increase in complexity for the receiver whether status updates occur or not
   - Note that fully automated processes typically will not have status updates.
- Provides the ability to represent the needed data using a FHIR [Questionnaire] 
- Provides the ability to represent the Purpose of Use in the Task
- Provides the ability to supply work queue hints to the Task recipient
- Enables referencing the object that directly leads to the task - a particular claim, for example

### The Task Resource


**For CDex Task-based transactions, the [CDex Task Data Request Profile] SHALL be used by the Data Consumer to solicit information from a system.** It represents *both* the data request and the returned data and provides information such as why it needs to be completed, who is to complete it, who is asking for it, when it is due, etc. The Task's status is updated as the task is fulfilled. For a detailed description of all the mandatory, [*must support*], and optional elements, as well as formal definitions and profile views, see the [CDex Task Data Request Profile] page.

#### Task Inputs and Outputs

`Task.input` represents the necessary information from Data Consumer to complete the task, including the specific data they request. The CDex Task Data Request Profile supports four ways to define the requested data.
  1. leveraging the [FHIR RESTful search syntax]
  2. using a code
  3. using free text
  4. referencing a FHIR [Questionnaire]

Implementers of this guide [*must support*] search syntax and coded inputs. However, free text and Questionnaire input are optional capabilities. See the [Conforming to CDex Task Based Approach] page for how systems declare what they support for the various actors and roles.
   
`Task.output` represents the requested data that is returned. This output is a FHIR reference to:
   - FHIR Search Bundle (e.g., a query response)
   - FHIR Documents (e.g., C-CDA on FHIR)
   - Other data formats attached to or referenced by a FHIR [DocumentReference] resource (e.g., a C-CDA document)
   - a FHIR [QuestionnaireResponse] 
   - Other Individual FHIR resources (e.g., Condition)


#### Purpose of Use

The current state of healthcare data exchange is typically limited to a single, well-known, and pre-established purpose-of-use (POU). The CDex Task Data Request Profile defines an optional element representing a new way to dynamically provide additional granularity for the POU using codes defined in the [CDex Purpose of Use Value Set]. The value set page documents and illustrates the hierarchy where the child concepts have an IS-A relationship with the parents that rolls up to the [45 CFR 164.506 Treatment, Payment, and Health Care Operations (TPO)] concepts.  

If the Data Source supports this element, a transaction-level POU permits more discrimination than "Treatment, Payment, or Health Care Operations (TPO)" which systems use today. It also enables a POU that differs from the default purpose of use for that data-consuming system. It allows the Data Source to make necessary decisions about whether to provide the information or whether/how to filter the information. The example transactions below illustrate the usage of the POU element.

#### Work Queues

For asynchronous requests using Task, it may be beneficial for Data Consumers and Data Sources to pre-coordinate and agree upon a set of "request tags" to communicate the general type of request being made. Then, the Data Source can use these Data Consumer supplied tags to aid in filtering and sorting Tasks. For example, assuming the Data Source has work queues based on request criteria, the Data Source could use tags to place a Task in the appropriate work queue.

The [CDex Work Queue Value Set] is a set of work queue tags that the provider may use in their workflow to process requests. The examples below illustrate how these values are communicated in `Task.meta.tag` to tag the Task with the work queue hint.

#### Task Reason

When known, `Task.reasonCode` or `Task.reasonReference` **SHALL** reference the object that directly leads to the task - a particular claim, for example.

### Sequence Diagram

The sequence diagram in Figure 7 below summarizes the fundamental interaction between the Data Consumer and Data Source when querying and retrieving data using the Task-based transaction. The following sections discuss the options and variations associated with the Task-based Exchange API.

{% include img.html img="task-sequencediagram.svg" caption="Figure 7" %}


### Discovery of Identifiers

Task-based queries require communicating a business identifier (such as a provider NPI or member ID) or a [FHIR id] to uniquely identify providers, payers, and patients. Business identifiers are used in many payer-to-provider-based transactions today, and the CDex Task Data Request Profile requires them. However, there is currently no standard way to obtain these identifiers, and implementers must get them "out of band".

The patient's [FHIR id] is a prerequisite to performing FHIR RESTful Direct Queries. See [this section](direct-query.html#discovery-of-patient-fhir-ids) for how to discover the patient's FHIR id.



### Task State Machine

Figure 8 below illustrates a "typical" state machine for CDex Task. The Data Consumer creates the Task with a status of "requested". The Data Source updates the status of the Task as appropriate. The Data Source **SHALL** support *all* the statuses in the [HRex Task Status ValueSet]. The Data Source **MAY** support additional transitions, including transitions from terminal states (e.g., back to "in-progress" from "failed" or "completed"). The Data Source **MAY** use [`Task.businessStatus`] to track intermediate business statuses for their specific implementation.

{% include img.html img="task-state-machine.svg" caption="Figure 8" %} 

### Fetching the Data



When the task is complete, its outputs are referenced by the `Task.output` element, and the `Task.status` is updated to "completed". The Task can refer to external resources, or it can refer to a search set Bundle [contained] within the Task resource itself, either of which the Data Consumer can subsequently fetch. As documented [here](direct-query.html#read-warning), when signatures are required, the Data Consumer must use a [FHIR RESTful search] instead of [FHIR RESTful read]. Note that a contained Bundle does not have an independent existence. However, by using a contained Bundle, the Data Source can provide information to Data Consumers who can not query the Data source directly via FHIR RESTful reads or searches. For example, only authorized Data Consumers can access patient data directly. Since the Data Source controls the release of information contained in the Bundle, patient privacy and security are maintained.

#### How Long is the Data Available

The Data Source determines how long the Data Consumer can access the completed Task and the referenced data. The business rules between them and other constraints, such as those based on privacy law, will limit the time the requested data is accessible.

### Example Transactions Based on Query Code and Free Text Inputs

Following the guidance in this guide and HRex, getting clinical data from the Data Source is typically a two-to-five-step process for the Data Consumer. The following example transactions show two scenarios using task-based exchanges to request and retrieve clinical data from a Data Source(HIT). The Task examples in scenario 1 use a FHIR RESTful query syntax and a free text input. The scenario 2 example uses a coded input in the Task. The following section documents an example transaction in which the Task input is a FHIR Questionnaire. 

#### Scenario 1

This scenario demonstrates these Task-based Query options:

1. FHIR RESTful query syntax vs. free text inputs
1. Polling
1. Fetching contained vs. external data

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C to support a claims audit.

##### FHIR RESTful Query Syntax

Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[2] }}
1. {{ site.data.base-example-list[3] }}
1. {{ site.data.base-example-list[4] }}
1. {{ site.data.base-example-list[5] }} the FHIR RESTful query syntax is used for the actual request.
1. {{ site.data.base-example-list[6] }}
1. {{ site.data.base-example-list[7] }}

{% include examplebutton_default.html example="task-scenario-1a" b_title = 'Click Here To See Example Task Based Transaction (RESTful search syntax)' %}

##### Free Text

This example is the same as above, except 'Task.input' uses free text to specify the data requested.

{% include examplebutton_default.html example="task-scenario-1b" b_title = 'Click Here To See Example Task Based Transaction (free text)' %}

##### Contained Task Outputs

Preconditions and Assumptions:

This example repeats the first, except Patient B's active conditions referenced in `Task.output` are *contained* resources within the Task resource. Therefore, the Payer must only perform a single RESTful GET operation to fetch the completed Task and the requested data.

{% include examplebutton_default.html example="task-scenario-1c" b_title ='Click Here To See Example Task Based Transaction (contained output)' %}

---

#### Scenario 2

This scenario demonstrates requesting a non-FHIR document (PDF, C-CDA) using a coded input :

Payer A Seeks the insured Person/Patient B's latest progress notes from Provider C to improve care coordination.

##### Progress note Exam Notes as PDF

Payer A Seeks the Insured Person/Patient B's latest progress notes from Provider C to improve care coordination.

Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[8] }}
1. {{ site.data.base-example-list[9] }}
1. {{ site.data.base-example-list[4] }}
2. {{ site.data.base-example-list[5] }} the LOINC attachment code 11506-3, History & Physical Note, is used for the actual request.
3. Patient B's documents referenced by Task.output are "contained resources", and the actual documents are base64 pdf files in the `DocumentReference.content.attachment.data` elements. By polling the Task, the Payer already has the data when the completed Task is fetched, and there is no need to perform an additional RESTful GET.


{% include examplebutton_default.html example="task-scenario-2a" b_title = "Click Here To See Example Task Based Transaction for Patient's Latest Progress note" %}


##### Surgical Notes as CCDA Documents

Payer A Seeks an insured Person/Patient B's operative notes from Provider C to improve care coordination.

Preconditions and Assumptions are the same as in the previous example, except the Payer POSTS a Task to the Provider endpoint requesting Patient B's operative notes using the LOINC attachment code 11504-8, Surgical operation note.

{% include examplebutton_default.html example="task-scenario-2b" b_title = "Click Here To See Example Task Based Transaction for Patient's Operative Note" %}

---

### Using Questionnaire as Task Input

The [CDex Task Data Request Profile] supports requests for more detailed data using Questionnaire. When a Data Consumer references a FHIR Questionnaire as an input parameter, the Task represents a request for the Data Source to complete the questionnaire (form). CDex defines a specific `Task.code` that directs the Data Source to launch a [Da Vinci - Documentation Templates and Rules (DTR)] application to use the Data Consumer provided Questionnaire and results from any CQL execution to generate a QuestionnaireResponse resource containing the necessary information. Figure 8 summarizes the steps for requesting and completing a questionnaire using a CDex Task-Based request and DTR. The sequence diagram in the next section illustrates these transactions in more detail:

{% include img.html img="taskbased-task-Q-summary.svg" caption="Figure 8" %} 

**Step 1:** The Data Consumer POSTs a Task directly to the Data Source. The Task is a request to complete a questionnaire.

**Step 2:** If the Task.code is "data-request-questionnaire", the Data Source launches DTR and shares the Task as a launch parameter (i.e., DTR has access to read and update the Task and access to other resources to complete the QuestionnaireResponse in Step 3)

**Step 3:** DTR fetches the Task, which contains the link to the Questionnaire. Then, it fetches the Questionnaire (and any CQL rules defined within it) and completes the QuestionnaireResponse. Refer to the [Da Vinci DTR] Implementation Guide for more information on how it generates a QuestionnaireResponse.

**Step 4:** DTR creates and updates the QuestionnaireResponse directly to the Data Source's FHIR Server and updates `Task.output` to reference the QuestionnaireResponse it created.

**Step 5:** The Data Source updates the Task to "completed" when the QuestionnaireResponse is completed. The Data Consumer retrieves the completed Task from the Data Source using polling or a previously created Subscription.

**Step 6:** The Data Consumer retrieves the QuestionnaireResponse referenced by `Task.output`.

#### Using [Da Vinci DTR] to Complete the Questionnaire

The sequence diagram in Figure 9 below depicts the FHIR RESTful transactions and processes involved between the Data Consumer, Data Source, and DTR application needed to request, fill, and return a questionnaire using the CDex Task-based approach. It references a "DTR Launch". If DTR is a native EHR application, the launch is implementation specific. If it is a SMART on FHIR Application, the [DTR SMART App Launch] section documents the launch sequence and parameters.

{% include img.html img="taskbased-task-Q-sequencediagram.svg" caption="Figure 9" %}

#### Example of Requesting Data Using A FHIR Questionnaire

Payer A Seeks documentation from Provider P for Insured Person/Patient B's Home Oxygen Therapy order as part of a claims audit.

Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
2. {{ site.data.base-example-list[2] }}
3. {{ site.data.base-example-list[3] }}
4. {{ site.data.base-example-list[4] }}
5. The Payer POSTS a Task to the Provider endpoint requesting the Provider to complete the referenced Questionnaire.
6. The Provider uses a  DTR SMART App or EHR native application to complete the Questionnaire.
7. {{ site.data.base-example-list[6] }}
8. The Payer fetches the QuestionnaireResponse referenced by `Task.output`.

{% include examplebutton_default.html example="task-scenario-10" b_title = 'Click Here To See Example Task Based Transaction Using Questionnaire' %}



### When The Task Cannot Be Completed

If the Data Source was unsuccessful in completing the request for data, the Task's state transitions to "failed". It is a terminal state, and no further activity for the task will occur. For example, when the requested data is unavailable, the Data Source cannot complete the task. They update the `Task.status` to "failed" and state the reason in `Task.statusReason` (for example, "no matching results"). The `Task.output` is absent since the requesting data is unavailable. The Data Consumer's business rules will determine their response to a failed request.

#### Example Unsuccessful Task Based Transaction

In this scenario, Payer A Seeks Insured Person/Patient B's glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C.
##### Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[10] }}
1. {{ site.data.base-example-list[11] }}
2. {{ site.data.base-example-list[15] }}
3. Payer A knows the appropriate LOINC codes (4548-4 Hemoglobin A1c/Hemoglobin.total in Blood)
4. {{ site.data.base-example-list[16] }} 


{% include examplebutton_default.html example="task-scenario-3" b_title = 'Click Here To See Example Unsuccessful Task Based Transaction' %}

---

### Polling vs Subscriptions

Task-based exchanges can take one of two forms - subscription or polling, as described in the [Exchanging with polling] and [Exchanging with FHIR Subscription] sections of the FHIR R5 core specification. The [Subscription Capabilities] section provides general guidance on polling vs. subscription.

#### Polling

Polling is a mechanism for conveying new data to a Data Consumer as (or shortly after) the data is created or updated without requiring the Data Source to be aware of the specific needs of the Data Consumer. The Data Consumer repeatedly queries the Data Source to see if there is new data. For example, in the Da Vinci CDex use case, the Data Consumer would poll the Data Source by fetching the Task resource to see if it has been updated. Polling is the *default option* if the Data Source does not support subscribing to the Task as described below.

Data consumers can poll for a single Task or across several Tasks. The frequency must be often enough that the time between when the relevant data is created and when the Data Consumer receives it is sufficiently short for the Data Consumer's needs. However, it must be infrequent enough that the   Data Source's resources are not over-taxed by the repeated query. Data Consumers **SHOULD** perform this operation in an automated/background manner after 1 minute to return automated responses and no more than every 5 minutes for the first 30 minutes and no more frequently than once every hour after that. 



#### Subscription

<!-- Subscription is a mechanism designed to allow clients to request notifications when an event occurs or data changes. It is an active notification system; a FHIR server actively sends notifications as changes occur. In the Da Vinci CDex use case, the Data Consumer subscribes to the Data Source's Server [base]/Subscription endpoint for notifications when any Task that they created is updated.

When using subscriptions in CDex, implementers **SHALL** use topic-based subscriptions as defined in the [Subscription R5 Backport Implementation Guide]. This topic-based subscription model supersedes the query-defined subscription model defined in FHIR R4 and supported in earlier versions of CDex. Systems must follow the Conformance in FHIR R4 requirements specified in the [R5 Backport Implementation Guide] and the CDex-specific conformance requirements listed below. -->

In the subscription mechanism, instead of the Data Consumer regularly querying the Data Source to see if there are changes to existing Tasks, the Data Consumer creates a Subscription instance on the Data Source server. (It's also possible for the data source to configure subscriptions for clients; in other words, it can create subscriptions administratively. However, these implementation details are out of scope for this guide.) The Subscription indicates that the Data Consumer wants to be notified about changes to Tasks and provides filters describing what subset of Tasks the Data Consumer is interested in. The Data Source will then push notifications when there are new or updated Tasks and the Data Consumer can then query for the specific Tasks that have changed.

Da Vinci CDex Data Sources who choose to support Subscription **SHALL** comply with the [Subscription R5 Backport Implementation Guide] and the Da Vinci Health Record Exchange (HRex) [Subscription requirements](https://build.fhir.org/ig/HL7/davinci-ehrx/task.html#subscription) for subscribing to Task updates. These implementation guides "pre-adopt" the FHIR R5 topic-based subscription approach in R4 implementations since most U.S. EHR vendors have agreed to support it.

##### HRex Task Subscription Topic 

The Da Vinci Health Record Exchange (HRex) guide formally defines the [HRex Task Subscription Topic](https://build.fhir.org/ig/HL7/davinci-ehrx/SubscriptionTopic-Task.html) Subscription Topic as a [SubscriptionTopic], a resource defined in FHIR 4B and later versions.

- The Data Source **SHALL** support the HRex Task Subscription Topic and **MAY** support other subscription topics.

Note that supporting the FHIR SubscriptionTopic resource nor the equivalent Basic resource versions described in the R5 Backport Implementation Guides is NOT required by this guide to support subscriptions.
{:.bg-warning}

##### Discovery

The R5 Backport Implementation Guide defines the [CapabilityStatement SubscriptionTopic Canonical] extension to allow CDex Data Consumers to discover CDex Data Sources' supported subscription topics. This extension enables servers to advertise the canonical URLs of subscription topics available to clients and allows clients to see the list of supported topics on a server. If a Data Source supports subscriptions:

- The Data Source **SHALL** support discovery of the CDex Task Update Subscription Topic canonical URL
- The Data Source **SHOULD** support discovery using the CapabilityStatement SubscriptionTopic Canonical extension and **MAY** support discovery by some other method.

The example CapabilityStatement snippet shows a Data Source advertising the CDex Task Update Subscription Topic canonical URL with the CapabilityStatement SubscriptionTopic Canonical extension:

{% include examplebutton_default.html example="advertise-topic.md" b_title = 'Click Here To See CapabilityStatement Advertising the CDex Task Update Subscription Topic' %}

<!-- 
##### Subscription Resource

To dynamically request notifications for CDex Task updates (and other topics the Data Source supports), Data Consumers RESTfully POST a Subscription resource with the Data Source. The Subscription resource **SHALL** conform to the [R4/B Topic-Based Subscription Profile].

<div class="bg-info" markdown="1">
Subscriptions need not be created dynamically by the Data Consumer. It's also possible for the Data Source to configure subscriptions for clients, in other words, create subscriptions administratively. However, these implementation details are out of scope for this guide.
</div> 

###### Channel Types

The subscription requires information about where to send notifications, such as the type of channel and the URL that describes the endpoint.

###### Payload Types

When specifying the contents of a notification, there are three options available: "empty," "id-only," and "full-resource." Because the Data Source can not guarantee who has access to the nominated subscription endpoint, the notification typically uses "id-only" to return the Task resource ID. By omitting the payload, the Data Consumer is forced to authenticate before accessing the data using a FHIR RESTful read or search, which mitigates privacy and security risks for the Data Source.

- The Data Consumer **SHALL** use the canonical URL in the `Subscription.criteria` element to subscribe to the Data Source's Server [base]/Subscription endpoint'
- The Data Source **SHOULD** support the "rest-hook" channel and **MAY** support other channel types.
- The Data Source **SHALL** support ""id-only" payload type and **MAY** support other payload types.

###### Subscription Notifications

For active CDex Task Update subscriptions, when a CDex Task Data Request Profile is updated, the Data Source **SHALL** trigger a Subscription Notification to the endpoint supplied by the Data Consumer. This notification is a Bundle resource and **SHALL** conform to the [R4 Topic-Based Subscription Notification Bundle]. The first entry contains the subscription's status information, represented by a Parameters resource. For the "id-only" payload type, Task IDs are listed in the "focus" part parameter.

-->

#### Example Task Based Transaction using Subscription

The following example repeats Scenario 1 above using Subscription instead of Polling. However, instead of the Payer polling the Task resource until the `Task.status` indicates it is completed, rejected, or failed:

1. The Payer *subscribes* to the HRex Task Subscription Topic to get notifications when the Task is updated.
2. The Payer fetches the Task resource when notified of an update.
3. When the `Task.status` is "completed", the Payer fetches Patient B's active Conditions referenced by `Task.output` as *external* resources. (This step is skipped if the status is "rejected".)

{% include examplebutton_default.html example="task-scenario-4" b_title = 'Click Here To See Example Task Based Transaction using Subscription' %}



---

### Formal Authorization

In Provider to Provider transactions, there are situations where one must supply a formal authorization for each data request. In Payer to Provider and some Provider to Provider transactions, a general data-sharing agreement makes such individual authorizations unnecessary, and the Data Consumer can use the Task alone. When a formal request for the information to be shared is needed, it is represented by either a [CommunicationRequest] or [ServiceRequest] and referenced by Task using the `Task.basedOn` element. The example below illustrates a use case with a formal authorization.

The [HL7 FHIR-I Workflow project] is working on a set of rules for when it is sufficient to use Task alone to ask for an action to be performed and when the Task needs to be accompanied by a separate formal authorization using a request resource. Their preliminary conclusion is that Task can (and even should) exist without a request resource for some situations. The FHIR-I Workflow project intends for these rules to be used in addition to the organization's business practices to assist in the decision-making of the information providers.
{:.stu-note}

#### Example Task Based Transaction with a Formal Authorization

In this scenario, a referred-to Provider Seeks Patient B's Active Conditions from referring the Provider to support performing the requested service.

##### Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[17] }}
1. {{ site.data.base-example-list[18] }}
1. {{ site.data.base-example-list[12] }}
2. The Referred-To Provider creates a CommunicationRequest formally authorizing information to be gathered on Patient B.
   - Note that in this example, the Referred-To-Provider (Data Consumer) is both the requester and the data recipient. The requester could also be a third party.
1. The  Referred-To-Provider POSTS a Task to the Referring Provider endpoint requesting Patient B's Active Conditions. The CommunicationRequest is referenced in `Task.basedOn`. For the actual request, the FHIR RESTful query syntax is used.
3. The Referring Provider fetches and inspects the CommunicationRequest to review the authorization.
4. The Referred-To-Provider polls the Task resource until the `Task.status` indicates it is completed, rejected, or failed.
5. The Referred-To-Provider fetches Patient B's Active Conditions referenced by `Task.output` as *external* resources.

{% include examplebutton_default.html example="task-scenario-5" b_title = "Click Here To See Example Task Based Transaction with a Formal Authorization" %}

---

### Provenance

To the extent that the Data Source keeps a record of the data's provenance, the FHIR Provenance Resource can be requested using Task. The input parameter is a FHIR RESTful query syntax or free text (i.e., "give me this data and its provenance"). The examples below show how to request and receive provenance using either method. Alternatively, When `Task.output` represents individual FHIR resources, the Data Receiver could query for its associated Provenance resources when fetching the resource referenced in `Task.output` (see the Direct Query for [examples](direct-query.html#provenance)). Typically, requesting external Provenance for FHIR Documents and other formats, such as C-CDA, is unnecessary because their contents implicitly or explicitly supply their provenance.

#### Example Requests for Provenance using Task Based Transaction

The following examples repeat the first two examples in Scenario 1 above but request Patient B's active Conditions *and associated Provenance*.

{% include examplebutton_default.html example="task-scenario-6b" b_title = 'Click Here To See Example Requests for Provenance using Task (search based syntax)' %}

{% include examplebutton_default.html example="task-scenario-6a" b_title = 'Example Requests for Provenance using Task (free text)' %}

---

### Signatures

{% include signature-support.md %}

Some Data Consumers may require that the data they receive be signed. When signatures are required on the returned results, the following general rules apply:

{% include human-signature.md %}
{% include system-signature.md %}
{% include inherently-signed.md %}

{% include signature-disclaimer.md %}

#### The Data Consumer Requirements

- The Data Consumer *pre-negotiates* with the organization representing the Data Source/Responder if:
  1. electronic or digital *provider* signatures are required for *all* Task-based query response data
  2. or electronic or digital *system-level* signatures are required for *all* or *some* Task-based query response data instead of or in addition to provider signatures (for example, for automated workflows)
  3. or electronic or digital *provider* signatures are required *only* for requests that communicate the signature requirement using the `Task.input` [signature flag](StructureDefinition-cdex-task-data-request-definitions.html#Task.input:signature).
- The Data Consumer follows the documentation on the [Signatures] page for validating signatures.
   - If the signatures fail verification, the Data Consumer notifies the Data Source that the signature is invalid or absent. Currently, there is no standard way to communicate this, and it needs to be done "out of band".

#### Data Source Requirements
{% include data-source-sig-rules.md %}

#### Example of a *Signed* Task Based Transaction

The following example repeats Scenario 1 above; however, the Payer requires a signature.
  - The Provider creates a FHIR Document bundle that includes the FHIR resources representing the clinical data and signs the Bundle.
- See the [Signatures] page for a detailed explanation of how the signature was created and verified.

{% include examplebutton_default.html example="task-scenario-7" b_title = 'Click Here To See Example Signed Task Based Transaction' %}

{% include link-list.md %}
