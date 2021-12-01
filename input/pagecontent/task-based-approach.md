
This guide uses a Task Based Approach to satisfy the Payer's need to request the information it needs when it can not perform a direct query. The decision to use this approach is based on the following factors:

- Whether a specific Authorization is needed
- The Access to the data is limited (for example due to patient privacy concerns the data needs to be reviewed and/or filtered )
- The Appropriateness of the request needs to be determined
- The data needed is described in an unstructured or non-computable form. For example:
  - the payor may not have knowledge of specific codes or identifiers to make a direct query
  - there is no way to describe the data in a structure format it is described in free text.
- A Direct Query is otherwise not feasible

In most of these situations, there is still human intervention (e.g., a provider or designated staff) needed to find the data, aggregate the data, filter the data and/or approve its release.  In other use cases, mutually agreed upon data sets for specific purposes can already be requested and automatically fulfilled without human intervention.  The details for these Task based transaction are described in detail the [Requesting Exchange using Task] section of the Da Vinci HRex Implementation Guide.
{:.new-content}

To the extent that the Provider keeps a record of the provenance for the source of the data, the FHIR Provenance Resource can be requested using Task.  To request the Provenance using Task either a FHIR RESTful query syntax or free text (i.e., "give me this data and its provenance") is used. Examples for requesting and receiving provenance using either method are provided below. Note that for Documents the provenance is typically implicitly or explicitly defined within and so there is no need for an external structure.  

**For CDex Task based transactions the [CDex Task Data Request Profile] SHALL be used by the Payer**

<div markdown="1" class="new-content">

Task based queries require sending a [FHIR id] or a business identifier for providers and payers. Currently there is no standard way to obtain these identifiers and implementers will need to obtain them "out of band".

It is anticipated other efforts such as [FHIR at Scale Taskforce (FAST)] will provide a long term solution to the issue of FHIR id discovery.
{:.stu-note}

</div>

### Benefits

All of the following except the last of these benefits are relevant whether human intervention is needed or not.

- Easy ability to say 'yes' or 'no', including providing a reason for refusal
- Provides the ability to represent the reason (*Purpose of Use*) in the `Task.reasonCode` element using either codes or free text.
- Allows linking the request to its associated outputs without creating a new resource
- Can use polling or subscriptions to retrieve the results
- {:.new-content}As trust and infrastructure enabling direct queries evolve, enables a transition strategy towards direct queries to gather data of interest
- Allows conveying the 'status' of a request in progress
   - Monitoring for status does not require a change in workflow from monitoring for final results - i.e. there is no increase in complexity for the receiver whether status updates occur or not
   - Note that fully automated processes typically will not have status updates.

### Sequence Diagram

The sequence diagram in Figure 3 below summarizes the basic interaction between the Payer and EHR to query and retrieve the requested data using the Task based transaction.   However, there are three implementation variations with Task Based Exchange discussed below:


{% include img.html img="task-sequencediagram.svg" caption="Figure 4" %}

### Formal Authorization

In provider to provider transactions, there are situations where one must provide formal authorization for each individual data request. In payer to provider and some provider to provider transactions, an overall data sharing agreement make the need for such individual authorizations unnecessary.  Where such individual authorizations are not required, Task can be used alone.  When a formal request for the information to be shared is needed it is represented by either a [CommunicationRequest] or [ServiceRequest] and referenced by Task using the the `Task.basedOn` element.  Use cases with and without authorization are illustrated in the examples below.
{:.new-content}

The [HL7 FHIR-I Workflow project] is working on a set of rules for in which circumstances it's sufficient to use Task alone to ask for an action to be performed and when the Task needs to be accompanied by a Request resource. <span class="bg-success"> This guidance is intended to be used in addition to the business practices to assist in the decision making of the information providers.</span>  That work is not complete, but so far the conclusion is that there will be some situations where Task can (and even should) exist without a Request resource and other situations where a Request will be required.
{:.stu-note}

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

### Fetching the Data

<span markdown="1" class="bg-success">It is up to the EHR (Data Source) to set the status of each Task as appropriate. (see the [Task state machine] diagram in the FHIR specification for more background on Task transitions).</span> When the task is completed, the Payer fetches the data of interest which is referenced by `Task.output`.  It can either refer to a 'contained' search set Bundle - because the Bundle is not something that would have any independent existence - or to external resources which are subsequently fetched by the Payer use a RESTful GET.

<div markdown="1" class="new-content">

#### When the Task cannot be completed

If the EHR was not successful in completing the request for data, the Task's state transitions to "failed". It is a terminal state and no further activity on the request will occur. This can happen when the requested data is not available, because the EHR cannot complete the task.  The `Task.status` is updated to 'failed', and the reason  stated in `Task.statusReason` (for example, "no matching results"). The `Task.output` is absent since the requesting data is not available. The Payer's business rules will determine their response to a failed request.  An example transaction where there is no matching data is given in [scenario 3](#scenario-3) below.
</div>

<div markdown="1" class="new-content">

#### How Long is the Data Available

Ultimately, the Data Source determines how long the Data Consumer has access to the completed Task and the data referenced by it. The business rules between them and other constraints such as those based on privacy law will limit the time the requested data is accessible.
</div>

<div markdown="1" class="new-content">

### Example Transactions:

As discussed above, there are 4 basic implementation variations in any combination with task based exchanges:

1. Structured vs Free Text Request
1. Subscription vs Polling
1. Fetching Contained vs External Data
1. Whether Formal Authorization is Needed (typically in provider-provider scenarios)

The following example transactions show scenarios using task based exchanges to get clinical data from an EHR.  Each of the above variations will be demonstrated. Following the guidance in this guide and HRex, Getting Active Conditions from Provider is typically a two to five step process for the Payer.

#### Scenario 1

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C <span class="bg-success"> to support a claim submission.</span>

Preconditions and Assumptions:
- The Appropriateness of the request needs to be determined or access to the data is limited and there is human involvement needed to approve the release of the data:

Click on the buttons below to see example Task Requests for a Patient's Active Conditions:

{% include examplebutton_default.html example="task-scenario1-basic" b_title = 'Base interaction: Structured data (codes) for request, Polling, Output references to external resources, No formal authorization' %}

{% include examplebutton_default.html example="task-scenario1-free" b_title = 'Interaction using free text for the request instead of codes.' %}

{% include examplebutton_default.html example="task-scenario1-subscription" b_title = 'Interaction using subscriptions instead of polling.' %}

{% include examplebutton_default.html example="task-scenario1-contained" b_title ='Interaction with contained output instead references to external resources' %}
---

<div markdown="1" class="bg-success">

#### Scenario 2

Referred-to Provider Seeks Patient B's Active Conditions from referring Provider to support performing the requested service.

Preconditions and Assumptions:
- There is human involvement needed to complete the request
- Referred-to Provider needs formal authorization to request data

Click on the buttons below to see example Task Requests for a Patient's Active Conditions:

{% include examplebutton_default.html example="task-scenario2-authorization" b_title = 'Click Here To See Example Task Request with a formal authorization' %}
</div>

---

#### Scenario 3

Payer A Seeks Insured Person/Patient B’s glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.

Preconditions and Assumptions:

- The Appropriateness of the request needs to be determined or access to the data is limited and there is human involvement needed to approve the release of the data:
- Payer A knows the appropriate LOINC codes for searching for HbA1c test results (e.g.: 4548-5 Hemoglobin A1c/Hemoglobin.total in Blood)

{% include examplebutton_default.html example="task-scenario3-basic" b_title = "Click Here To See Example Task Request for Patient's HBA1C Results after 2020-01-01" %}

---

#### Scenario 4

Payer A Seeks Insured Person/Patient B’s latest history and physical exam notes from Provider C to improve care coordination.

Preconditions and Assumptions:

- The Appropriateness of the request needs to be determined or access to the data is limited and there is human involvement needed to approve the release of the data:
- Payer A knows the appropriate LOINC codes for searching for History and Physical CCDA document (34117-2 History & Physical Note)

{% include examplebutton_default.html example="task-scenario4-basic" b_title = "Click Here To See Example Task Request for Patient's Latest History and Physical" %}

{% include link-list.md %}
