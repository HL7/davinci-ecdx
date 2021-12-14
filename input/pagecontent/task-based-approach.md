
This guide uses a Task Based Approach to satisfy the Payer's need to request the information it needs when it can not perform a direct query. The decision to use this approach is based on the following factors:

- Whether a specific Authorization is needed
- The Access to the data is limited (for example due to patient privacy concerns the data needs to be reviewed and/or filtered )
- The Appropriateness of the request needs to be determined
- The data needed is described in an unstructured or non-computable form. For example:
  - the payor may not have knowledge of specific codes or identifiers to make a direct query
  - there is no way to describe the data in a structure format it is described in free text.
- A Direct Query is otherwise not feasible

### Benefits

All of the following except the last of these benefits are relevant whether human intervention is needed or not.

- Easy ability to say 'yes' or 'no', including providing a reason for refusal.
- Allows linking the request to its associated outputs without creating a new resource
- Can use polling or subscriptions to retrieve the results
- {:.new-content}As trust and infrastructure enabling direct queries evolve, enables a transition strategy towards direct queries to gather data of interest
- Allows conveying the 'status' of a request in progress
   - Monitoring for status does not require a change in workflow from monitoring for final results - i.e. there is no increase in complexity for the receiver whether status updates occur or not
   - Note that fully automated processes typically will not have status updates.
- {:.new-content}Provides the ability to represent the Purpose of Use in the Task
- {:.new-content}Provides the ability to supply work queue hints to the Task recipient
- {:.new-content}Enables referencing the object that directly lead to the task - a particular claim for example

In most of these situations, there is still human intervention (e.g., a provider or designated staff) needed to find the data, aggregate the data, filter the data and/or approve its release.  In other use cases, mutually agreed upon data sets for specific purposes can already be requested and automatically fulfilled without human intervention.

<div markdown="1" class="new-content">

### The Task Resource

**For CDex Task based transactions the [CDex Task Data Request Profile] SHALL be used by the Payer to solicit information from a system.** It represents *both* the data request and the returned data as follows:

1. `Task.input` represents the data request. The data request may be:
  - FHIR RESTful Search syntax
  - coded
  - free text
1. `Task.output` represents the requested data. This output is a FHIR reference to:
      - Individual FHIR resources (e.g., Condition)
      - FHIR Search Bundle (e.g., a query response)
      - FHIR Documents (e.g., CCDA on FHIR)
      - Other data formats attached to or referenced by DocumentReference (e.g., CCDA)
1. `Task.status` is updated as the task is fulfilled

The details for these Task based transaction are described in detail the [Requesting Exchange using Task] section of the Da Vinci HRex Implementation Guide.

#### Purpose of Use

What is going to be done with the requested information is known as the  *Purpose of Use* for the requested data.  It may be of interest to the source system, because privacy policies and consent directives may dictate the response to data requests. Purpose of Use for the requested data is communicated between the Payer and Provider using codes from the [CDex Purpose of Use Value Set] in `Task.input`.  Examples using these codes are provided below.

#### Work Queues

For asynchronous requests using Task, it may be beneficial for Payers and EHRs to pre-coordinate and agree upon a set of  "request-tags" to communicate the general type of request being made.  The EHR can use these Payer supplied tags to aid in filtering and sorting Tasks.  For example, assuming the EHR has work queues based on request criteria, tags could be used by the EHR to place a Task in the appropriate work queue.

The [CDex Work Queue Value Set] is a set work queue tags that the provider may use in their workflow to process request.  The `Task.meta.tag` is used to tag the Task with the work queue hint.  Examples using these tags are provided below.

#### Task Reason

When it is known,`Task.reasonCode/reasonReference` **SHOULD** reference the object that directly lead to the task - a particular claim for example.

</div>

### Sequence Diagram

The sequence diagram in Figure 6 below summarizes the basic interaction between the Payer and EHR to query and retrieve the requested data using the Task based transaction.   However, there are three implementation variations with Task Based Exchange discussed below:

{% include img.html img="task-sequencediagram.svg" caption="Figure 6" %}

### Discovery of FHIR IDs

<div markdown="1" class="new-content">

#### Providers and Payer FHIR IDs

Task based queries require sending a [FHIR id] or a business identifier for providers and payers. Currently there is no standard way to obtain these identifiers and implementers will need to obtain them "out of band".

It is anticipated other efforts such as [FHIR at Scale Taskforce (FAST)] will provide a long term solution to the issue of FHIR id discovery.
{:.stu-note}

#### Patient FHIR IDs

The patient's [FHIR id] is a prerequisite to performing both a FHIR RESTful Direct Query and Task-based query. Note that using a patient business identifier such as a MRN or member id not widely supported as FHIR references in EHRs today.  Therefore, a patient lookup to determine the patient's FHIR id on the server is typically required. One option is to use the [Patient Match operation](http://build.fhir.org/patient-operation-match.html) where it has been implemented. Another options is find the FHIR_id using the FHIR RESTful API:

1. FHIR RESTful search on Patient using a combination of an identifier known by the Payer such as a member_id and patient demographics.

   `Get /Patient?identifier=[member_id]&birthdate=[date]&name=[name]&gender=[gender]`

1. FHIR RESTful search on [Coverage]. The patient's FHIR_id is found in  Coverage.beneficiary` which references the patient.

   `GET /Coverage?payor & member_id and/or subscriber_id`  TODO

These are the most direct approaches to obtaining the FHIR_id. However, servers may or may not support identifier based searches or searches based on member_id identifiers by EHR servers. Additionally, if the effective dates of the coverage needs to be reflected in the this lookup then search semantics become more complex.
</div>

### Fetching the Data

<span markdown="1" class="bg-success">It is up to the EHR (Data Source) to set the status of each Task as appropriate. (see the [Task state machine] diagram in the FHIR specification for more background on Task transitions).</span> When the task is completed, the Payer fetches the data of interest which is referenced by `Task.output`.  It can either refer to a 'contained' search set Bundle - because the Bundle is not something that would have any independent existence - or to external resources which are subsequently fetched by the Payer use a RESTful GET.

<div markdown="1" class="new-content">

#### How Long is the Data Available

Ultimately, the Data Source determines how long the Data Consumer has access to the completed Task and the data referenced by it. The business rules between them and other constraints such as those based on privacy law will limit the time the requested data is accessible.
</div>

<div markdown="1" class="new-content">

### Task Based Transaction Scenarios:

Following the guidance in this guide and HRex, Getting clinical data from the Provider is typically a two to five step process for the Payer. The following example transactions show 2 scenarios using task based exchanges to get clinical data from an EHR.  Additional examples are provided in the following sections which document other implementation considerations

#### Scenario 1

This scenario demonstrates these Task Based Query options:

1. Structured vs Free Text Request
1. Polling
1. Fetching Contained vs External Data

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C <span class="bg-success"> to support a claim submission.</span>

Preconditions and Assumptions:
- The Appropriateness of the request needs to be determined or access to the data is limited and there is human involvement needed to approve the release of the data:

Click on the buttons below to see example Task Requests for a Patient's Active Conditions:

{% include examplebutton_default.html example="task-scenario1-basic" b_title = 'Base interaction: FHIR RESTful query syntax for data request, Polling, Output references to external resources, No formal authorization' %}

{% include examplebutton_default.html example="task-scenario1-free" b_title = 'Interaction using free text request for data' %}

{% include examplebutton_default.html example="task-scenario1-subscription" b_title = 'Interaction using subscriptions instead of polling' %}

{% include examplebutton_default.html example="task-scenario1-contained" b_title ='Interaction with contained output instead references to external resources' %}
---

<div markdown="1" class="bg-success">

#### Scenario 2

Payer A Seeks Insured Person/Patient B’s latest history and physical exam notes from Provider C to improve care coordination.

Preconditions and Assumptions:

- The Appropriateness of the request needs to be determined or access to the data is limited and there is human involvement needed to approve the release of the data:
- Payer A knows the appropriate LOINC codes for searching for History and Physical CCDA document (34117-2 History & Physical Note)

{% include examplebutton_default.html example="task-scenario4-basic" b_title = "Click Here To See Example Task Request for Patient's Latest History and Physical" %}

<div markdown="1" class="new-content">

### When The Task Cannot Be Completed

If the EHR was not successful in completing the request for data, the Task's state transitions to "failed". It is a terminal state and no further activity on the request will occur. This can happen when the requested data is not available, because the EHR cannot complete the task.  The `Task.status` is updated to 'failed', and the reason  stated in `Task.statusReason` (for example, "no matching results"). The `Task.output` is absent since the requesting data is not available. The Payer's business rules will determine their response to a failed request.  An example transaction where there is no matching data is given in [scenario 3](#scenario-3) below.

#### Example Task Based Transaction When It Cannot Be Completed

Referred-to Provider Seeks Patient B's Active Conditions from referring Provider to support performing the requested service.

Preconditions and Assumptions:
- There is human involvement needed to complete the request
- Referred-to Provider needs formal authorization to request data

Click on the buttons below to see example Task Requests for a Patient's Active Conditions:

{% include examplebutton_default.html example="task-scenario2-authorization" b_title = 'Click Here To See Example Task Request with a formal authorization' %}
</div>

### Polling vs Subscriptions

Task Based exchanges can take one of two forms - *subscription* or *polling* as described in the [Exchanging with polling] and [Exchanging with FHIR Subscription] sections of the Da Vinci HRex Implementation Guide.  General guidance on whether to use polling or subscription can be found in the [Subscription Capabilities] section.

#### Polling

Polling is a mechanism for conveying new data to a Payer as (or shortly after) the data is created or updated without requiring the Provider to be aware of the specific needs of the Payer.  The Payer repeatedly queries the Provider to see if there is new data. In the Da Vinci CDex use case, the Payer would poll the Provider by fetching the Task resource to see if has been updated.  Polling is the *default option* if the Provider does not support subscribing to the Task as described below.

#### Subscription

Subscriptions allow a data source to notify interested data consumers when a specific event occurs.  In the Da Vinci CDex use case, the Payer is the subscriber and the Provider the publisher.  The Payer subscribes to a Task queue and filters on the Task resource id.  The Provider publishes notifications when there are changes to the Task instance.  <span class="bg-success">Typically,</span> the notification *does not* expose the data itself.  The subscriber would then fetch the data using a FHIR RESTful query.

<div markdown="1" class="bg-info">

- {:.bg-success}The publisher can not guarantee who has access to the nominated subscription endpoint.  By omitting the payload, the client is forced to authenticate before accessing the data which mitigates privacy and security risks on the publisher.

- Subscriptions need not be created independently for each Task - a payer could subscribe to all Tasks where they are the requester.  It's also possible that subscriptions could be established automatically or out-of-band.  However, these are implementation details that are out of scope for this guide.
</div>

This project recognizes the major revisions to the reworked R5 subscription "topic-based" pub/sub pattern and the future publication of a Subscription R5 Backport Implementation Guide for FHIR 4 to address the many shortcomings in the current (R4) approach to subscriptions. Due to these imminent changes in the FHIR pub/sub pattern, the discovery process for subscription support is *out of scope* for this version of the guide.  The Payer may discover it out-of-band or simply through trial-and-error.
{:.stu-note}

#### Example Task Based Transaction using Subscription

The following examples repeats Scenario 1 above using Subscription instead of Polling

{% include examplebutton_default.html example="task-scenario1-subscription" b_title = 'Interaction using subscriptions instead of polling' %}

### Formal Authorization

In provider to provider transactions, there are situations where one must provide formal authorization for each individual data request. In payer to provider and some provider to provider transactions, an overall data sharing agreement make the need for such individual authorizations unnecessary.  Where such individual authorizations are not required, Task can be used alone.  When a formal request for the information to be shared is needed it is represented by either a [CommunicationRequest] or [ServiceRequest] and referenced by Task using the the `Task.basedOn` element.  Use cases with and without authorization are illustrated in the examples below.
{:.new-content}

The [HL7 FHIR-I Workflow project] is working on a set of rules for in which circumstances it's sufficient to use Task alone to ask for an action to be performed and when the Task needs to be accompanied by a Request resource. <span class="bg-success"> This guidance is intended to be used in addition to the business practices to assist in the decision making of the information providers.</span>  That work is not complete, but so far the conclusion is that there will be some situations where Task can (and even should) exist without a Request resource and other situations where a Request will be required.
{:.stu-note}

#### Example Task Based Transaction with a Formal Authorization

Payer A Seeks Insured Person/Patient B’s glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.

Preconditions and Assumptions:

- The Appropriateness of the request needs to be determined or access to the data is limited and there is human involvement needed to approve the release of the data:
- Payer A knows the appropriate LOINC codes for searching for HbA1c test results (e.g.: 4548-5 Hemoglobin A1c/Hemoglobin.total in Blood)

{% include examplebutton_default.html example="task-scenario3-basic" b_title = "Click Here To See Example Task Request for Patient's HBA1C Results after 2020-01-01" %}

### Provenance

To the extent that the Provider keeps a record of the provenance for the source of the data, the FHIR Provenance Resource can be requested using Task.  To request the Provenance using Task either a FHIR RESTful query syntax or free text (i.e., "give me this data and its provenance") is used. Examples for requesting and receiving provenance using either method are provided below.  Alternatively, When `Task.output` represents individual FHIR resource, the Data Receiver could query for Provenance when fetching the resource referenced in `Task.output` (see the Direct Query for [examples](http://build.fhir.org/ig/HL7/davinci-ecdx/branches/master/direct-query.html#example-transactions)). Typically, it is unnecessary to request external Provenance for FHIR Documents and other formats such as CCDA, because their contents implicitly or explicitly supply their provenance.

#### Example Requests for Provenance using Task Based Transaction

The following examples repeats Scenario 1 above and also request the associated Provenance.

{% include examplebutton_default.html example="task-scenario1p-basic" b_title = 'Base interaction with provenance' %}

{% include examplebutton_default.html example="task-scenario1p-free" b_title = 'Interaction using free text request for data and provenance' %}

### Signatures

Some data consumers may require that the data they receive are signed. When performing Task based request when signatures are required on the returned results, the following general rules apply:

- The signature **SHALL** represent a *human provider* signature on resources attesting that the information is true and accurate.
- The returned object is either already inherently signed (for example, a wet signature on a PDF or a digitally signed CCDA) or it **SHALL** transformed into a signed [FHIR Document](http://hl7.org/fhir/documents.html) and `Bundle.signature`  **SHALL** be used to exchange the signature.

#### The Data Consumer/Requester Requirements

When a electronic or digital signature is required for a Task based request, the Data Consumer/Requester **SHALL**:

- Indicate in Task that a signature is required using `Task.input` signature flag parameter as defined in [CDex Task Data Request Profile](StructureDefinition-cdex-task-data-request.html)
    - It **SHOULD NOT** be assumed that a Task based requests will be signed if the flag is omitted.
-  Pre-negotiate whether *electronic* or *digital* signatures are used
- Follow the documentation in the [Signatures] page for validating signatures.


#### Data Source/Responder Requirements

When a electronic or digital signature is required for Task based request, the Data Source/Responder **SHALL**:
- Return an object is either already inherently signed or transform it into a *signed* FHIR Document.
- Be signed by the provider that is responding the the query.
- Follow the documentation in the [Signatures] page for producing signatures.
- {:.bg-info}As discussed in the [What is Signed] section, a signed FHIR document could have a within it objects that are individually signed as well. If the Consumer/Requester assumed there would be a signature (wet,electronic, or digital) on an individual returned object (e.g CCDA, PDF, Image, CDA on FHIR ) and it is not present.  They **MAY** *re-request* the data using Task based request and indicate it needs to signed using the `Task.input` signature flag.  The  Data Source/Responder **MAY** return the signed object or a signed FHIR Document.


#### Example of a *Signed* Task Based Transaction

The following example repeats [Scenario 1](#scenario-1), only this time a signature is required.
  - FHIR resources representing the clinical data are transformed into a FHIR Document bundle and the bundle is signed.
- See [Signatures] page for complete worked example on how the signature was created.

{% include examplebutton_default.html example="task-scenario1s-basic" b_title = 'Click Here To See Example: *Signed* Task Based Transaction' %}

</div>

{% include link-list.md %}
