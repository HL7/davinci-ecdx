
This guide uses a Task Based Approach to satisfy the Payer's need to request the information it needs when it can not perform a direct query. The decision to use this approach is based on the following factors:

- <span class="bg-success" markdown="1">The Access to the data is restricted and a specific authorization is needed (for example due to patient privacy concerns the data needs to be reviewed and/or filtered )</span><!-- new-content -->
- The appropriateness of the request needs to be determined
- The data needed is described in an unstructured or non-computable form. For example:
  - the payor may not have knowledge of specific codes or identifiers to make a direct query
  - there is no way to describe the data in a structure format it is described in free text.
- A Direct Query is otherwise not feasible

In most of these situations, there is human intervention (e.g., a provider or designated staff) needed to find the data, aggregate the data, filter the data and/or approve its release.  In other use cases, mutually agreed upon data sets for specific purposes can already be requested and automatically fulfilled without human intervention.

### Benefits

- Easy ability for Task recipient to say 'yes' or 'no', including providing a reason for refusal.
- Allows linking the request to its associated outputs without creating a new resource
- Can use polling or subscriptions to retrieve the results
- As trust and infrastructure enabling direct queries evolve, enables a transition strategy towards direct queries to gather data of interest
- Allows conveying the 'status' of a request in progress
   - Monitoring for status does not require a change in workflow from monitoring for final results - i.e. there is no increase in complexity for the receiver whether status updates occur or not
   - Note that fully automated processes typically will not have status updates.
- Provides the ability to represent the Purpose of Use in the Task
- Provides the ability to supply work queue hints to the Task recipient
- Enables referencing the object that directly lead to the task - a particular claim for example

### The Task Resource

**For CDex Task based transactions the [CDex Task Data Request Profile] SHALL be used by the Payer to solicit information from a system.** It represents *both* the data request and the returned data as follows:

1. `Task.input` represents the data request. The data request may be:
  - [FHIR RESTful Search syntax]
  - coded
  - free text
1. `Task.output` represents the requested data. This output is a FHIR reference to:
      - Individual FHIR resources (e.g., Condition)
      - FHIR Search Bundle (e.g., a query response)
      - FHIR Documents (e.g., CCDA on FHIR)
      - Other data formats attached to or referenced by a FHIR [DocumentReference] resource (e.g., a CCDA document)
1. `Task.status` is updated as the task is fulfilled

The details for these Task based transaction are described in detail in the [Requesting Exchange using Task] section of the Da Vinci HRex Implementation Guide.

#### Purpose of Use

{% include section_for_ballot.md %}

The current state of healthcare data exchange is typically limited to a single, well-known and pre-established purpose-of-use (POU). The CDex Task Data Request Profile defines an optional element that represents the purpose of use( POU) for the requested data with a [CDex Purpose of Use Value Set] containing a small number of codes. The intent of this element is to define a potentially new way to exchange data with a dynamically defined POU.

If this element is supported by the Data Source, it permits POU codes to be communicated dynamically in the individual Task based queries which may even differ from the ‘default’ purpose of use for that data consuming system. It allows the The Data Source to make necessary decisions about whether to provide the information at all or whether/how to filter the information. The examples illustrate how this input element is used.

#### Work Queues

For asynchronous requests using Task, it may be beneficial for Payers and EHRs to pre-coordinate and agree upon a set of  "request-tags" to communicate the general type of request being made.  The EHR can use these Payer supplied tags to aid in filtering and sorting Tasks.  For example, assuming the EHR has work queues based on request criteria, tags could be used by the EHR to place a Task in the appropriate work queue.

The [CDex Work Queue Value Set] is a set work queue tags that the provider may use in their workflow to process request.  The `Task.meta.tag` is used to tag the Task with the work queue hint.  Examples using these tags are provided below.

#### Task Reason

When it is known,`Task.reasonCode/reasonReference` **SHOULD** reference the object that directly lead to the task - a particular claim for example.

### Sequence Diagram

The sequence diagram in Figure 6 below summarizes the basic interaction between the Payer and EHR to query and retrieve the requested data using the Task based transaction.   Options and variations associated with Task Based Exchange API are discussed in the sections below.

{% include img.html img="task-sequencediagram.svg" caption="Figure 6" %}

### Discovery of FHIR IDs

#### Providers and Payer FHIR IDs

Task based queries require sending a [FHIR id] or a business identifier for providers and payers. Currently there is no standard way to obtain these identifiers and implementers will need to obtain them "out of band".

It is anticipated other efforts such as [FHIR at Scale Taskforce (FAST)] will provide a long term solution to the issue of FHIR id discovery.
{:.stu-note}

#### Patient FHIR IDs

The patient's [FHIR id] is a prerequisite to performing both a FHIR RESTful Direct Query and Task-based query. Note that using a patient business identifier such as a MRN or member id not widely supported as FHIR references in EHRs today.  Therefore, a patient lookup to determine the patient's FHIR id on the server is typically required. One option is to use the [Patient Match] operation where it has been implemented. Another options is find the FHIR id using the FHIR RESTful API. These are the most direct approaches to obtaining the FHIR id:

1. FHIR RESTful search on the Patient resource using a combination of an identifier known by the Payer such as a member_id and patient demographics.

   `Get /Patient?identifier=[member_id]&birthdate=[date]&name=[name]&gender=[gender]`

1. FHIR RESTful search on [Coverage] resource using a combination the payor's FHIR id and identifier known by the Payer such as a member id or subscriber id. The patient's FHIR id is found in the `beneficiary` element (which references the patient).

   `GET /Coverage?payor=[FHIR id]&identifier=[member_id]`
   or
   `GET /Coverage?payor=[FHIR id]&subscriber-id=[subscriber_id]`

However, servers may or may not support identifier based searches or searches based on member_id identifiers by EHR servers. In addition, the search semantics become more complex if effective dates of coverage are included in the search.

### Fetching the Data

It is up to the EHR (Data Source) to set the status of each Task as appropriate. (see the [Task state machine] diagram in the FHIR specification for more background on Task transitions). When the task is completed, the Payer fetches the data of interest which is referenced by `Task.output`.  The Task can refer to external resources which can be subsequently fetched by the Payer, or it can refer to a searchset Bundle [contained] within the Task resource itself. In the circumstances of a contained Bundle, the bundle does not have an independent existence.

#### How Long is the Data Available

Ultimately, the Data Source determines how long the Data Consumer has access to the completed Task and the data referenced by it. The business rules between them and other constraints such as those based on privacy law will limit the time the requested data is accessible.

### Task Based Transaction Scenarios

Following the guidance in this guide and HRex, getting clinical data from the Provider is typically a two to five step process for the Payer. The following example transactions show 2 scenarios using task based exchanges to get clinical data from an EHR.

#### Scenario 1

This scenario demonstrates these Task Based Query options:

1. FHIR RESTful query syntax vs free text request
1. Polling
1. Fetching contained vs external data

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C to support a claims <span class="bg-success" markdown="1">audit</span><!-- new-content -->.

##### FHIR RESTful Query Syntax Request

Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[2] }}
1. {{ site.data.base-example-list[3] }}
1. {{ site.data.base-example-list[4] }}
1. {{ site.data.base-example-list[5] }}  For the actual request, the FHIR RESTful query syntax is used.
1. {{ site.data.base-example-list[6] }}
1. {{ site.data.base-example-list[7] }}

{% include examplebutton_default.html example="task-scenario1-basic" b_title = 'Click Here To See Example Task Based Transaction (RESTful search syntax)' %}

##### Free Text Request

This example is the same as above, except *natural language free text* is used the actual request in Task.

{% include examplebutton_default.html example="task-scenario1-free" b_title = 'Click Here To See Example Task Based Transaction (free text)' %}

##### Contained Task Outputs

Preconditions and Assumptions:

This example repeats the first, except Patient B’s active conditions referenced by `Task.output` are *contained* resources, the Payer has the data when the Task is completed and there is no need to perform an additional RESTful GET to fetch them.

{% include examplebutton_default.html example="task-scenario1-contained" b_title ='Click Here To See Example Task Based Transaction (contained output)' %}

---

#### Scenario 2

This scenario demonstrates requesting a non-FHIR document (CCDA) using a code:

Payer A Seeks Insured Person/Patient B’s latest history and physical exam notes from Provider C to improve care coordination.

---

Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[8] }}
1. {{ site.data.base-example-list[9] }}
1. {{ site.data.base-example-list[4] }}
1. {{ site.data.base-example-list[5] }} For the actual request, the FHIR RESTful query syntax is used.
1. The Patient B’s Documents referenced by Task.output are contained resources and the actual documents are base64 pdf files in the DocumentReference.content.attachment.data elements. By polling the Task, the Payer already has the data when the Task is completed and there is no need to perform an additional RESTful GET to fetch them (documents from the resource are rendered in this example).
1. Payer A knows the appropriate LOINC codes for searching for History and Physical CCDA document (34117-2 History & Physical Note)

{% include examplebutton_default.html example="task-scenario4-basic" b_title = "Click Here To See Example Task Based Transaction for Patient's Latest History and Physical" %}

### When The Task Cannot Be Completed

If the EHR was not successful in completing the request for data, the Task's state transitions to "failed". It is a terminal state and no further activity on the request will occur. This can happen when the requested data is not available, because the EHR cannot complete the task.  The `Task.status` is updated to 'failed', and the reason  stated in `Task.statusReason` (for example, "no matching results"). The `Task.output` is absent since the requesting data is not available. The Payer's business rules will determine their response to a failed request.

#### Example Unsuccessful Task Based Transaction

In this scenario, Payer A Seeks Insured Person/Patient B’s glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.

##### Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[10] }}
1. {{ site.data.base-example-list[11] }}
1. {{ site.data.base-example-list[4] }}
1. {{ site.data.base-example-list[15] }}
1. The Patient B’s Documents referenced by Task.output are contained resources and the actual documents are base64 pdf files in the DocumentReference.content.attachment.data elements. By polling the Task, the Payer already has the data when the Task is completed and there is no need to perform an additional RESTful GET to fetch them (documents from the resource are rendered in this example).
1. Payer A knows the appropriate LOINC codes for searching for History and Physical CCDA document (34117-2 History & Physical Note)
1. {{ site.data.base-example-list[16] }} 

{% include examplebutton_default.html example="task-scenario3-basic" b_title = 'Click Here To See Example Unsuccessful Task Based Transaction' %}

---

### Polling vs Subscriptions

Task Based exchanges can take one of two forms - *subscription* or *polling* as described in the [Exchanging with polling] and [Exchanging with FHIR Subscription] sections of the Da Vinci HRex Implementation Guide.  General guidance on whether to use polling or subscription can be found in the [Subscription Capabilities] section.

#### Polling

Polling is a mechanism for conveying new data to a Data Consumer as (or shortly after) the data is created or updated without requiring the Data Source to be aware of the specific needs of the Data Consumer.  The Data Consumer repeatedly queries the Data Source to see if there is new data. In the Da Vinci CDex use case, the Data Consumer would poll the Data Source by fetching the Task resource to see if has been updated.  Polling is the *default option* if the Provider does not support subscribing to the Task as described below.

<span class="bg-success" markdown="1">Data consumers can poll for a single Task or across several Tasks.  The frequency needs to be often enough that the time between when the relevant data is created and when the Data Consumer receives it is sufficiently short for the Data Consumer's needs. However, it needs to be infrequent enough that the data source's resources are not over-taxed by the repeated query.  Data Consumers **SHOULD** perform this operation in an automated/background manner no more than every 5 minutes for the first 30 minutes and no more frequently than once every hour after that.</span><!-- new-content -->

#### Subscription

Subscriptions allow a data source to notify interested data consumers when a specific event occurs.  In the Da Vinci CDex use case, the Payer is the subscriber and the Provider the publisher.  The Payer subscribes to a Task queue and filters on the Task resource id.  The Provider publishes notifications when there are changes to the Task instance.  Typically, the notification *does not* expose the data itself.  The subscriber would then fetch the data using a FHIR RESTful query.

<div markdown="1" class="bg-info">

- The publisher can not guarantee who has access to the nominated subscription endpoint.  By omitting the payload, the client is forced to authenticate before accessing the data which mitigates privacy and security risks on the publisher.

- Subscriptions need not be created independently for each Task - a payer could subscribe to all Tasks where they are the requester.  It's also possible that subscriptions could be established automatically or out-of-band.  However, these are implementation details that are out of scope for this guide.
</div>

This project recognizes the major revisions to the reworked R5 subscription "topic-based" pub/sub pattern and the future publication of a Subscription R5 Backport Implementation Guide for FHIR 4 and <span class="bg-success" markdown="1">recent publication of [FHIR4B](http://hl7.org/fhir/r4b-explanation.html)</span><!-- new-content --> to address the many shortcomings in the current (R4) approach to subscriptions. Due to these imminent changes in the FHIR pub/sub pattern, the discovery process for subscription support is *out of scope* for this version of the guide.  The Payer may discover it out-of-band or simply through trial-and-error. <span class="bg-success" markdown="1">As soon as the Subscription Backport Guide is published and R4B named by regulations, the intent to update this guide to support the task based subscriptions framework.</span><!-- new-content -->
{:.stu-note}



#### Example Task Based Transaction using Subscription

The following examples repeats Scenario 1 above using Subscription instead of Polling. Instead of the payer polling the Task resource until the `Task.status` indicates it is completed, rejected, or failed:

1. The Payer *subscribes* the Task resource to get notifications when it is updated.  `Task.status` indicates it is completed or rejected.
1. The Payer fetches the Task resource when notified of an update.
1. When the `Task.status` indicates it is completed, the Payer fetches Patient B's active Conditions referenced by `Task.output` as *external* resources.  (This step is skipped if the status is "rejected".)
1. Subscription is cancelled.

{% include examplebutton_default.html example="task-scenario1-subscription" b_title = 'Click Here To See Example Task Based Transaction using Subscription' %}

---

### Formal Authorization

In provider to provider transactions, there are situations where one must provide formal authorization for each individual data request. In payer to provider and some provider to provider transactions, an overall data sharing agreement make the need for such individual authorizations unnecessary.  Where such individual authorizations are not required, Task can be used alone.  When a formal request for the information to be shared is needed it is represented by either a [CommunicationRequest] or [ServiceRequest] and referenced by Task using the `Task.basedOn` element.  A use case with an authorization is illustrated in the example below.

The [HL7 FHIR-I Workflow project] is working on a set of rules for in which circumstances it's sufficient to use Task alone to ask for an action to be performed and when the Task needs to be accompanied by a Request resource. The project's work is  incomplete, but the preliminary conclusion is that Task can (and even should) exist without a Request resource for some situations. Note that these rules are intended to be used in addition to the organization's own business practices to assist in the decision making of the information providers.
{:.stu-note}

#### Example Task Based Transaction with a Formal Authorization

In this scenario, a referred-to Provider Seeks Patient B's Active Conditions from referring Provider to support performing the requested service.

##### Preconditions and Assumptions:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[17] }}
1. {{ site.data.base-example-list[18] }}
1. {{ site.data.base-example-list[12] }}
2. The Referred-To Provider creates a CommunicationRequest formally authorizing information to be gathered on Patient B.
   - Note that in this example, the Referred-To Provider (data consumer) is both the requester and the recipient of the data.  The requester could also be a 'third party'.
3. 1. The  Referred-To Provider POSTS a Task to the Referring Provider endpoint requesting Patient B's Active Conditions,, the CommunicationRequest is referenced in `Task.basedOn`.  For the actual request, the FHIR RESTful query syntax is used.
4. The Referring Provider fetches and inspects the CommunicationRequest to review the authorization.
5. The Referred-To Provider polls the Task resource until the `Task.status` indicates it is completed, rejected, or failed.
6. The Referred-To Provider fetches Patient B's Active Conditions referenced by `Task.output` as *external* resources.

{% include examplebutton_default.html example="task-scenario2-authorization" b_title = "Click Here To See Example Task Based Transaction with a Formal Authorization" %}

---

### Provenance

To the extent that the Provider keeps a record of the provenance for the source of the data, the FHIR Provenance Resource can be requested using Task.  To request the Provenance using Task either a FHIR RESTful query syntax or free text (i.e., "give me this data and its provenance") is used. Examples for requesting and receiving provenance using either method are provided below.  Alternatively, When `Task.output` represents individual FHIR resource, the Data Receiver could query for Provenance when fetching the resource referenced in `Task.output` (see the Direct Query for [examples](http://build.fhir.org/ig/HL7/davinci-ecdx/branches/master/direct-query.html#example-transactions)). Typically, it is unnecessary to request external Provenance for FHIR Documents and other formats such as CCDA, because their contents implicitly or explicitly supply their provenance.

#### Example Requests for Provenance using Task Based Transaction

The following examples repeat the first two examples in Scenario 1 above but request Patient B’s active Conditions *and associated Provenance*.

{% include examplebutton_default.html example="task-scenario1p-basic" b_title = 'Click Here To See Example Requests for Provenance using Task (search based syntax)' %}

{% include examplebutton_default.html example="task-scenario1p-free" b_title = 'Example Requests for Provenance using Task (free text)' %}

---

### Signatures

Some data consumers may require that the data they receive are signed. When performing Task based request when signatures are required on the returned results, the following general rules apply:

- The signature **SHALL** represent a *human provider* signature on resources attesting that the information is true and accurate.
- The returned object is either already inherently signed (for example, a wet signature on a PDF or a digitally signed CCDA) or it **SHALL** transformed into a signed [FHIR Document](http://hl7.org/fhir/documents.html) and `Bundle.signature`  **SHALL** be used to exchange the signature.

#### The Data Consumer/Requester Requirements

When an electronic or digital signature is required for a Task based request, the Data Consumer/Requester **SHALL**:

- Indicate that a signature is required using the `Task.input` signature flag parameter as defined in [CDex Task Data Request Profile](StructureDefinition-cdex-task-data-request.html)
    - It **SHOULD NOT** be assumed that a Task based requests will be signed if the flag is omitted.
-  Pre-negotiate whether *electronic* or *digital* signatures are used
- Follow the documentation in the [Signatures] page for validating signatures.

#### Data Source/Responder Requirements

When an electronic or digital signature is required for Task based request, the Data Source/Responder **SHALL**:
- Return an object is either already inherently signed or transform it into a *signed* FHIR Document.
- Be signed by the provider that is responding the query.
- Follow the documentation in the [Signatures] page for producing signatures.
- {:.bg-info}As discussed in the [What is Signed] section, a signed FHIR document could have objects that are individually signed within it as well. If the Consumer/Requester assumed there would be a signature (wet,electronic, or digital) on an individual returned object (e.g CCDA, PDF, Image, CDA on FHIR ) and it is not present.  They **MAY** *re-request* the data using Task based request and indicate it needs to signed using the `Task.input` signature flag.  The  Data Source/Responder **MAY** return the signed object or a signed FHIR Document.


#### Example of a *Signed* Task Based Transaction

The following example repeats Scenario 1 above, however a signature is required.
  - FHIR resources representing the clinical data are transformed into a FHIR Document bundle and the bundle is signed.
- See [Signatures] page for complete worked example on how the signature was created and verified.

{% include examplebutton_default.html example="task-scenario1s-basic" b_title = 'Click Here To See Example Signed Task Based Transaction' %}

{% include link-list.md %}
