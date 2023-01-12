
### Introduction

This guide uses a Task Based Approach to satisfy the Data Consumer's need to request the information it needs when it can not perform a direct query. The decision to use this approach is based on the following factors:

- The Access to the data is restricted and a specific authorization is needed (for example due to patient privacy concerns the data needs to be reviewed and/or filtered )
- The appropriateness of the request needs to be determined
- The data needed is described in an unstructured or non-computable form. For example:
  - the payor may not know specific codes or identifiers to make a direct query
  - there is no way to describe the data in a structured format it is described in free text.
- A Direct Query is otherwise not feasible

In most of these situations, there is human intervention (e.g., a provider or designated staff) needed to find the data, aggregate the data, filter the data, and/or approve its release.  In other use cases, mutually agreed upon data sets for specific purposes can already be requested and automatically fulfilled without human intervention.

### Benefits

- Easy ability for Task recipient to say 'yes' or 'no', including providing a reason for refusal.
- Allows linking the request to its associated outputs without creating a new resource
- Can use polling or subscriptions to retrieve the results
- As trust and infrastructure enable direct queries to evolve, enables a transition strategy toward direct queries to gather data of interest
- Allows conveying the 'status' of a request in progress
   - Monitoring for status does not require a change in workflow from monitoring for final results - i.e. there is no increase in complexity for the receiver whether status updates occur or not
   - Note that fully automated processes typically will not have status updates.
- Provides the ability to represent the Purpose of Use in the Task
- Provides the ability to supply work queue hints to the Task recipient
- Enables referencing the object that directly leads to the task - a particular claim for example

### The Task Resource

<div class="bg-success" markdown="1">
**For CDex Task-based transactions, the [CDex Task Data Request Profile] SHALL be used by the Data Consumer to solicit information from a system.** It represents *both* the data request and the returned data and provides information such as why it needs to be completed, who is to complete it, who is asking for it, when it is due, etc. The Task's status is updated as the task is fulfilled.

#### Task Inputs and Outputs

`Task.input` represents the necessary information from Data Consumer to complete the task, including the specific data they request. The CDex Task Data Request Profile supports four ways to define the requested data.
  1. leveraging the [FHIR RESTful search syntax]
  2. using a code
  3. using free text
  4. referencing a FHIR Questionnaire

Implementers of this guide [*must support*] search syntax and coded inputs. However, free text and Questionnaire input are optional capabilities.
   
`Task.output` represents the requested data that is returned. This output is a FHIR reference to:
   - FHIR Search Bundle (e.g., a query response)
   - FHIR Documents (e.g., CCDA on FHIR)
   - Other data formats attached to or referenced by a FHIR [DocumentReference] resource (e.g., a CCDA document)
   - <span class="bg-success" markdown="1">a FHIR QuestionnaireResponse</span><!-- new-content -->
   - Other Individual FHIR resources (e.g., Condition)
</div><!-- new-content -->

#### Purpose of Use

The current state of healthcare data exchange is typically limited to a single, well-known and pre-established purpose-of-use (POU). <span class="bg-success" markdown="1">The CDex Task Data Request Profile defines an optional element representing a new way to dynamically provide additional granularity for the POU using codes defined in the [CDex Purpose of Use Value Set]. The value set page documents and illustrate the hierarchy where the child concepts have an IS-A relationship with the parents that rolls up to the [45 CFR 164.506 Treatment, Payment, and Health Care Operations (TPO)] concepts. </span><!-- new-content -->

If the Data Source supports this element, <span class= "bg-success" markdown= "1"> a transaction level POU permits greater discrimination than "Treatment, Payment, or Health Care Operations (TPO)" which is typically used today. It may even differ from the default purpose of use for that data-consuming system. </span><!-- new-content --> It allows the Data Source to make necessary decisions about whether to provide the information or whether/how to filter the information. The example transactions below illustrate the POU element usage.

#### Work Queues

For asynchronous requests using Task, it may be beneficial for Data Consumers and Data Sources to pre-coordinate and agree upon a set of  "request-tags" to communicate the general type of request being made.  The Data Source can use these Data Consumer's supplied tags to aid in filtering and sorting Tasks.  For example, assuming the Data Source has work queues based on request criteria, tags could be used by the Data Source to place a Task in the appropriate work queue.

The [CDex Work Queue Value Set] is a set of work queue tags that the provider may use in their workflow to process requests.  The `Task.meta.tag` is used to tag the Task with the work queue hint.  Examples using these tags are provided below.

#### Task Reason

When it is known,`Task.reasonCode/reasonReference` **SHALL** reference the object that directly leads to the task - a particular claim for example.

### Sequence Diagram

The sequence diagram in Figure 6 below summarizes the basic interaction between the Data Consumer and Data Source(HIT) to query and retrieve the requested data using the Task-based transaction.   Options and variations associated with Task-based Exchange API are discussed in the sections below.

{% include img.html img="task-sequencediagram.svg" caption="Figure 6" %}


### Discovery of Identifiers

Task-based queries require communicating either a business identifier (such as a provider NPI, or Member ID) or a [FHIR id] to uniquely identify providers, payers, and patients.  Business identifiers are used in many of the Payer to Provider based transactions today and the CDex Task Data Request Profile provides an explicit requirement to support them.  Currently, there is no standard way to obtain these identifiers and implementers will need to obtain them "out of band".

The patient's [FHIR id] is a prerequisite to performing  FHIR RESTful Direct Queries. See [this section](direct-query.html#discovery-of-patient-fhir-ids) for how to discover the patient's FHIR id.

It is anticipated other efforts such as [FHIR at Scale Taskforce (FAST)] will provide a long-term solution to the issue of FHIR id discovery.
{:.stu-note}


### Fetching the Data

It is up to the Data Source to set the status of each Task as appropriate. (see the [Task state machine] diagram in the FHIR specification for more background on Task transitions). When the task is completed, the Data Consumer fetches the data of interest which is referenced by `Task.output`.  The Task can refer to external resources which can be subsequently fetched by the Data Consumer, or it can refer to a search set Bundle [contained] within the Task resource itself.   As documented [here](direct-query.html#read-warning), when signatures are required, the Data Consumer must use a [FHIR RESTful search] instead of [FHIR RESTful read].  In the circumstances of a contained Bundle, the bundle does not have an independent existence. By using a contained Bundle, the Data Source can provide information to Data Consumers who can not perform a direct query.  For example, the Data Consumer can only access the patient's data via FHIR RESTful reads or searches if they are authorized to access it.  Since the Data Source controls the release of information contained in the Bundle, patient privacy and security is maintained.



#### How Long is the Data Available

Ultimately, the Data Source determines how long the Data Consumer has access to the completed Task and the data referenced by it. The business rules between them and other constraints such as those based on privacy law will limit the time the requested data is accessible.

### Example Transactions Based on Query, Code and Free Text Inputs

Following the guidance in this guide and HRex, getting clinical data from the Data Source is typically a two-to-five step process for the Data Consumer. The following example transactions show 2 scenarios using task-based exchanges to get clinical data from a Data Source(HIT). <span class="bg-success" markdown="1">The Task examples in scenario 1 use a FHIR RESTful query syntax and a free text input. The scenario 2 example uses a coded input in the Task. The next section documents and provides an example transaction in which the Task input is a Questionnaire.</span><!-- new-content -->

#### Scenario 1

This scenario demonstrates these Task-based Query options:

1. FHIR RESTful query syntax vs free text inputs
1. Polling
1. Fetching contained vs external data

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C to support a claims audit.

##### FHIR RESTful Query Syntax

Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[2] }}
1. {{ site.data.base-example-list[3] }}
1. {{ site.data.base-example-list[4] }}
1. {{ site.data.base-example-list[5] }}  For the actual request, the FHIR RESTful query syntax is used.
1. {{ site.data.base-example-list[6] }}
1. {{ site.data.base-example-list[7] }}

{% include examplebutton_default.html example="task-scenario-1a" b_title = 'Click Here To See Example Task Based Transaction (RESTful search syntax)' %}

##### Free Text

This example is the same as above, except *natural language free text* is used as the actual request in Task.

{% include examplebutton_default.html example="task-scenario-1b" b_title = 'Click Here To See Example Task Based Transaction (free text)' %}

##### Contained Task Outputs

Preconditions and Assumptions:

This example repeats the first, except Patient B’s active conditions referenced by `Task.output` are *contained* resources, the Payer has the data when the Task is completed and there is no need to perform an additional RESTful GET to fetch them.

{% include examplebutton_default.html example="task-scenario-1c" b_title ='Click Here To See Example Task Based Transaction (contained output)' %}

---

#### Scenario 2

This scenario demonstrates requesting a non-FHIR document (PDF,CCDA) <span class="bg-success" markdown="1">using a coded input</span><!-- new-content -->:

Payer A Seeks Insured Person/Patient B’s latest Progress notes from Provider C to improve care coordination.

##### Progress note Exam Notes as PDF

Payer A Seeks Insured Person/Patient B’s latest Progress notes from Provider C to improve care coordination.

Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[8] }}
1. {{ site.data.base-example-list[9] }}
1. {{ site.data.base-example-list[4] }}
2. {{ site.data.base-example-list[5] }} For the actual request, the LOINC attachment code 11506-3, History & Physical Note, is used.
3. The Patient B’s Documents referenced by Task.output are contained resources and the actual documents are base64 pdf files in the DocumentReference.content.attachment.data elements. By polling the Task, the Payer already has the data when the Task is completed and there is no need to perform an additional RESTful GET to fetch them (documents from the resource are rendered in this example).


{% include examplebutton_default.html example="task-scenario-2a" b_title = "Click Here To See Example Task Based Transaction for Patient's Latest Progress note" %}


##### Surgical Notes as CCDA

Payer A Seeks an insured Person/Patient B’s operative notes from Provider C to improve care coordination.

Preconditions and Assumptions are the same as above except the Payer POSTS a Task to the Provider endpoint requesting Patient B's operative notes using the LOINC attachment code 11504-8, Surgical operation note.

{% include examplebutton_default.html example="task-scenario-2b" b_title = "Click Here To See Example Task Based Transaction for Patient's Operative Note" %}

---

**The following section is DRAFT. It requires further community review and testing.**
{:.stu-note}

<div class="bg-success" markdown="1">

### Using Questionnaire as Task Input

The [CDex Task Data Request Profile] supports requests for more detailed data using Questionnaire. When a Data Consumer references a FHIR Questionnaire as an input parameter, the Task represents a request for the Data Source to complete the questionnaire (form). CDex defines a specific `Task.code` that directs the Data Source to launch a [Da Vinci - Coverage Requirements Discovery (DTR)] application to use the Data Consumer provided Questionnaire and results from any CQL execution to generate a QuestionnaireResponse resource containing the necessary information. Figure 7 summarizes the steps for requesting and completing a questionnaire using a CDex Task-Based request and DTR and the sequence diagram in the next section illustrates these transactions in more detail:

{% include img.html img="taskbased-task-Q-summary.svg" caption="Figure 7" %} 

**Step 1:** The Data Consumer POSTs a Task directly to the Data Source. The Task is a request to complete a questionnaire.

**Step 2:** if the Task.code is "data-request-questionnaire", the Data Source launches DTR and shares the Task as a launch parameter (i.e., DTR has access to read and update the Task, and access to other resources to complete the QuestionnaireResponse in Step 3)

**Step 3:** DTR fetches the Task, which contains the link to the Questionnaire. Then fetches the Questionnaire (and any CQL rules defined within it) and proceeds to complete the QuestionnaireResponse. Refer to the [Da Vinci DTR] Implementation Guide for more information on how it generates a QuestionnaireResponse.

**Step 4:** After completing the QuestionnaireResponse, DTR POSTs it directly to the Data Source's FHIR Server, updates Task.output to reference the QuestionnaireResponse it created, and updates Task.status to "completed".

**Step 5:** The Data Consumer retrieves the completed Task from the Data Source using either polling or a previously created Subscription.

**Step 6:** The Data Consumer retrieves the QuestionnaireResponse referenced by Task.output.

#### Using [Da Vinci DTR] to Complete the Questionnaire

The sequence diagram in Figure 8 below depicts the FHIR RESTful transactions and processes involved between the Data Consumer, Data Source, and DTR application needed to request, fill, and return a questionnaire using CDex Task-based approach. It references a "DTR Launch". If the DTR is a native EHR application, the launch is implementation specific. If DTR is a SMART on FHIR Application, the [DTR SMART App Launch] section documents the launch sequence and parameters.

{% include img.html img="taskbased-task-Q-sequencediagram.svg" caption="Figure 8" %}

#### Example of Requesting Data Using A FHIR Questionnaire

This scenario demonstrates requesting data using a FHIR Questionnaire:

Payer A Seeks documentation from Provider P for Insured Person/Patient B’s Home Oxygen Therapy order as part of a claims audit.

Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
2. {{ site.data.base-example-list[2] }}
3. {{ site.data.base-example-list[3] }}
4. {{ site.data.base-example-list[4] }}
5. The Payer POSTS a Task to the Provider endpoint requesting the referenced Questionnaire be completed.
6. The Provider uses a  DTR SMART App or EHR native application to complete the Questionnaire.
7. {{ site.data.base-example-list[6] }}
8. The Payer fetches the QuestionnaireResponse referenced by Task.output.

{% include examplebutton_default.html example="task-scenario-10" b_title = 'Click Here To See Example Task Based Transaction Using Questionnaire' %}

</div><!-- new-content -->

### When The Task Cannot Be Completed

If the Data Source was not successful in completing the request for data, the Task's state transitions to "failed". It is a terminal state and no further activity on the request will occur. This can happen when the requested data is not available because the Data Source cannot complete the task.  The `Task.status` is updated to 'failed', and the reason  stated in `Task.statusReason` (for example, "no matching results"). The `Task.output` is absent since the requesting data is not available. The Data Consumer's business rules will determine their response to a failed request.

#### Example Unsuccessful Task Based Transaction

In this scenario, Payer A Seeks Insured Person/Patient B’s glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.

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

Task-based exchanges can take one of two forms - *subscription* or *polling* as described in the [Exchanging with polling] and [Exchanging with FHIR Subscription] sections of the Da Vinci HRex Implementation Guide.  General guidance on whether to use polling or subscription can be found in the [Subscription Capabilities] section.

#### Polling

Polling is a mechanism for conveying new data to a Data Consumer as (or shortly after) the data is created or updated without requiring the Data Source to be aware of the specific needs of the Data Consumer.  The Data Consumer repeatedly queries the Data Source to see if there is new data. In the Da Vinci CDex use case, the Data Consumer would poll the Data Source by fetching the Task resource to see if has been updated.  Polling is the *default option* if the Data Source does not support subscribing to the Task as described below.

Data consumers can poll for a single Task or across several Tasks.  The frequency needs to be often enough that the time between when the relevant data is created and when the Data Consumer receives it is sufficiently short for the Data Consumer's needs. However, it needs to be infrequent enough that the data source's resources are not over-taxed by the repeated query.  Data Consumers **SHOULD** perform this operation in an automated/background manner <span class="bg-success" markdown="1">after 1 minute to return automated responses and after that no more than every 5 minutes for the first 30 minutes and no more frequently than once every hour after that.</span><!-- new-content -->

#### Subscription

Subscriptions allow a data source to notify interested data consumers when a specific event occurs.  In the Da Vinci CDex use case, the Data Consumer is the subscriber, and the Data Source is the publisher.  The Data Consumer subscribes to a Task queue and filters on the Task resource id.  The Data Source publishes notifications when there are changes to the Task instance.  Typically, the notification *does not* expose the data itself.  The subscriber would then fetch the data using a FHIR RESTful query.

<div markdown="1" class="bg-info">

- The publisher can not guarantee who has access to the nominated subscription endpoint.  By omitting the payload, the client is forced to authenticate before accessing the data which mitigates privacy and security risks for the publisher.

- Subscriptions need not be created independently for each Task - a Data Consumer could subscribe to all Tasks where they are the requester.  It's also possible that subscriptions could be established automatically or out-of-band.  However, these are implementation details that are out of scope for this guide.
</div>

This project recognizes the major revisions to the reworked R5 subscription "topic-based" pub/sub pattern and the publication of the [Subscription R5 Backport Implementation Guide] for FHIR 4 and recent publication of [FHIR4B](http://hl7.org/fhir/r4b-explanation.html) to address the many shortcomings in the current (R4) approach to subscriptions. Due to these imminent changes in the FHIR pub/sub pattern, the discovery process for subscription support is *out of scope* for this version of the guide.  The Data Consumer may discover it out-of-band or simply through trial and error. As soon as the Subscription Backport Guide is published and R4B named by regulations, the intent to update this guide to support the task-based subscriptions framework.
{:.stu-note}



#### Example Task Based Transaction using Subscription

The following example repeats Scenario 1 above using Subscription instead of Polling. Instead of the Payer polling the Task resource until the `Task.status` indicates it is completed, rejected, or failed:

1. The Payer *subscribes* to the Task resource to get notifications when it is updated.  `Task.status` indicates it is completed or rejected.
1. The Payer fetches the Task resource when notified of an update.
1. When the `Task.status` indicates it is completed, the Payer fetches Patient B's active Conditions referenced by `Task.output` as *external* resources.  (This step is skipped if the status is "rejected".)
1. Subscription is canceled.

{% include examplebutton_default.html example="task-scenario-4" b_title = 'Click Here To See Example Task Based Transaction using Subscription' %}

---

### Formal Authorization

In Provider to Provider transactions, there are situations where one must supply a formal authorization for each data request. In Payer to Provider and some Provider to Provider transactions, an overall data sharing agreement makes the need for such individual authorizations unnecessary.  Where such individual authorizations are not required, Task can be used alone.  When a formal request for the information to be shared is needed it is represented by either a [CommunicationRequest] or [ServiceRequest] and referenced by Task using the `Task.basedOn` element.  A use case with authorization is illustrated in the example below.

The [HL7 FHIR-I Workflow project] is working on a set of rules for in which circumstances it's sufficient to use Task alone to ask for an action to be performed and when the Task needs to be accompanied by a Request resource. The project's work is incomplete, but the preliminary conclusion is that Task can (and even should) exist without a Request resource for some situations. Note that these rules are intended to be used in addition to the organization's business practices to assist in the decision-making of the information providers.
{:.stu-note}

#### Example Task Based Transaction with a Formal Authorization

In this scenario, a referred-to Provider Seeks Patient B's Active Conditions from referring the Provider to support performing the requested service.

##### Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[17] }}
1. {{ site.data.base-example-list[18] }}
1. {{ site.data.base-example-list[12] }}
2. The Referred-To Provider creates a CommunicationRequest formally authorizing information to be gathered on Patient B.
   - Note that in this example, the Referred-To-Provider (data consumer) is both the requester and the recipient of the data.  The requester could also be a third party.
3. 1. The  Referred-To-Provider POSTS a Task to the Referring Provider endpoint requesting Patient B's Active Conditions,, the CommunicationRequest is referenced in `Task.basedOn`.  For the actual request, the FHIR RESTful query syntax is used.
4. The Referring Provider fetches and inspects the CommunicationRequest to review the authorization.
5. The Referred-To-Provider polls the Task resource until the `Task.status` indicates it is completed, rejected, or failed.
6. The Referred-To-Provider fetches Patient B's Active Conditions referenced by `Task.output` as *external* resources.

{% include examplebutton_default.html example="task-scenario-5" b_title = "Click Here To See Example Task Based Transaction with a Formal Authorization" %}

---

### Provenance

To the extent that the Data Source keeps a record of the provenance of the source of the data, the FHIR Provenance Resource can be requested using Task.  To request the Provenance using Task either a FHIR RESTful query syntax or free text (i.e., "give me this data and its provenance") is used. Examples for requesting and receiving provenance using either method are provided below.  Alternatively, When `Task.output` represents an individual FHIR resource, the Data Receiver could query for Provenance when fetching the resource referenced in `Task.output` (see the Direct Query for [examples](direct-query.html#provenance)). Typically, it is unnecessary to request external Provenance for FHIR Documents and other formats such as CCDA, because their contents implicitly or explicitly supply their provenance.

#### Example Requests for Provenance using Task Based Transaction

The following examples repeat the first two examples in Scenario 1 above but request Patient B’s active Conditions *and associated Provenance*.

{% include examplebutton_default.html example="task-scenario-6b" b_title = 'Click Here To See Example Requests for Provenance using Task (search based syntax)' %}

{% include examplebutton_default.html example="task-scenario-6a" b_title = 'Example Requests for Provenance using Task (free text)' %}

---

### Signatures

{% include signature-support.md %}

Some data consumers may require that the data they receive are signed. When signatures are required on the returned results, the following general rules apply:

{% include human-signature.md %}
{% include system-signature.md %}
{% include inherently-signed.md %}

{% include signature-disclaimer.md %}

#### The Data Consumer/Requester Requirements

- The Data Consumer/Requester *pre-negotiates* with the organization representing the Data Source/Responder whether:
  1. electronic or digital *provider* signatures are required for *all* Task-based query response data and/or
  2. electronic or digital *system-level* signatures are required for *all* or *some* Task-based query response data instead of or in addition to provider signatures (for example, for automated workflows) and/or
  3. electronic or digital *provider* signatures are required *only* for requests that communicate the signature requirement using the `Task.input` [signature flag](StructureDefinition-cdex-task-data-request-definitions.html#Task.input:signature).
- The Data Consumer/Requester follows the documentation on the [Signatures] page for validating signatures.
   - If the signatures fail verification, the Data Consumer/Requester notifies the Data Source that the signature is bad or absent. Currently, there is no standard way to communicate this, and it needs to be done “out of band”.

#### Data Source/Responder Requirements
{% include data-source-sig-rules.md %}

#### Example of a *Signed* Task Based Transaction

The following example repeats Scenario 1 above, however, a signature is required.
  - FHIR resources representing the clinical data are transformed into a FHIR Document bundle and the bundle is signed.
- See the [Signatures] page for a complete worked example of how the signature was created and verified.

{% include examplebutton_default.html example="task-scenario-7" b_title = 'Click Here To See Example Signed Task Based Transaction' %}

{% include link-list.md %}
