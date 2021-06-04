This sections provides specific guidance on exchanging clinical data between Payers and Providers.  For general [Background on FHIR], [Conformance Expectations], refer to the corresponding sections in the [Da Vinci Health Record Exchange (HRex)] Implementation Guide.  For Security and Privacy considerations refer to the [Security and Privacy] page.

<div markdown="1" class="new-content">

When we say “Payer” on this page, we don’t mean to limit ourselves to only Payers. The same technology can be used for other data consumers like Providers.  Consider “Payer” here as a short-hand notation for "data consumer”
{:.bg-info}

</div>

### Exchanging Clinical Data

FHIR offers numerous architectural approaches for sharing data between systems. Each approach has pros and cons. The most appropriate approach depends on the circumstances under which data is exchanged.  (Review the [Approaches to Exchanging FHIR Data] in the Da Vinci HRex Implementation Guide for more guidance and background.)  The guide focuses on **two** FHIR transaction approaches for requesting information:

1. **Direct Query (preferred):** Payer directly queries EHR for specific data using the standard FHIR RESTful search.
1. **Task Based Approach:** Payer identifies the 'type' of information desired and the EHR supplies the data possibly with human involvement to find/aggregate/filter/approve it.

Depending on the reason for the request, Payers may require signatures from EHRs *attesting* to the fulfillment of the data request.  However, there has not been enough implementation experience with this to provide specific guidance on how this is done.  We are seeking implementer feedback and comments on this issue.
{:.stu-note}

### Direct Query

For Direct Query, the Payer directly queries the EHR for specific data using the standard FHIR RESTful search. *This is the preferred option*. Guidance for exchanging data with FHIR search is fully described in the base FHIR specification and the Da Vinci HRex Implementation Guide.  Refer to the [US Core] Implementation guide for accessing the set of health data classes and data elements defined by the [ONC United States Core Data for Interoperability (USCDI)].

#### Benefits

- "Out of the Box" FHIR transaction
- Widely implemented
- Simplest workflow
- Authorization/Authentication protocols established
- No human intervention needed

#### Sequence Diagram

The sequence diagram in Figure 2 below outlines a successful interaction between the Payer and EHR to query and retrieve the requested data using a direct query:

{% include img.html img="search-sequencediagram.svg" caption="Figure 3" %}

#### Example Transactions:

The following example transactions show scenarios of using direct query to get clinical data from an EHR.

##### Scenario 1

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C <span class="bg-success"> to support a claim submission.</span>

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the *logical id* of the resource for Patient B
- Payer A knows the appropriate codes for searching for active conditions

Following guidance in US Core searches for all active conditions using the combination of the patient and clinical-status search parameters:

`GET [base]/Condition?patient=[reference]&clinical-status=active,recurrance,remission`

{% include examplebutton_default.html example="direct-query1-scenario" b_title = "Click Here To See Example Direct Query for Patient's Active Conditions" %}

---

##### Scenario 2

Payer A Seeks Insured Person/Patient B's glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the *logical id* of the resource for Patient B
- Payer A knows the appropriate LOINC codes for searching for HbA1c test results (e.g.: 4548-5 *Hemoglobin A1c/Hemoglobin.total in Blood*)

Following guidance in US Core searches for all HbA1c test results by a date range using using the combination of the patient and code and date search parameters:

`GET [base]/Observation?patient=[reference]&code=[code]&date=gt[date]`

{% include examplebutton_default.html example="direct-query2-scenario" b_title = "Click Here To See Example Direct Query for Patient's HbA1c Results after 2020-01-01" %}

---

##### Scenario 3

Payer A Seeks Insured Person/Patient B's latest history and physical exam notes from Provider C <span class="bg-success>to support a claim submission</span>.

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the *logical id* of the resource for Patient B
- Payer A knows the appropriate LOINC codes for searching for History and Physical CCDA document (34117-2 *History & Physical Note*)
- Provider C supports the standard FHIR search parameters, `_search` and `_count` (if this is not the case then the Payer can search using the date parameter and select the most recent history and physical exam notes for the query results.)

Getting the latest History and Physical is typically a two step process:

1. Query DocumentReference which references the actual notes file
2. Fetch the notes file

Following the US Core Clinical Notes Guidance section, Payer searches for History and Physical CCDA document using the combination of the patient and type search parameters.  In addition, the combination of `_sort` and `_count` is used to return only the latest resource that meets a particular criteria. With `_sort=-period` (sort by the `date` parameter in descending order) and `_count=1` the last matching resource will be returned.

`GET [base]/DocumentReference?patient=[id]&type=[type-code]&_sort=-period&_count=1`

The actual CCDA document is referenced in `DocumentReference.content.attachment.url` and can be fetched using a RESTful GET.

`GET [DocumentReference.content.attachment.url]`

{% include examplebutton_default.html example="direct-query3-scenario" b_title = "Click Here To See Example Direct Query for Patient's Latest History and Physical" %}

### Task Based Approach

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

**For CDex Task based transactions the [CDex Task Data Request Profile] SHALL be used by the Payer**

#### Benefits

All of the following except the last of these benefits are relevant whether human intervention is needed or not.

- Easy ability to say 'yes' or 'no', including providing a reason for refusal
- Provides the ability to represent the reason (*Purpose of Use*) in the `Task.reasonCode` element using either codes or free text.
- Allows linking the request to its associated outputs without creating a new resource
- Can use polling or subscriptions to retrieve the results
- {:.new-content}As trust and infrastructure enabling direct queries evolve, enables a transition strategy towards direct queries to gather data of interest
- Allows conveying the 'status' of a request in progress
   - Monitoring for status does not require a change in workflow from monitoring for final results - i.e. there is no increase in complexity for the receiver whether status updates occur or not
   - Note that fully automated processes typically will not have status updates.

#### Sequence Diagram

The sequence diagram in Figure 3 below summarizes the basic interaction between the Payer and EHR to query and retrieve the requested data using the Task based transaction.   However, there are three implementation variations with Task Based Exchange discussed below:


{% include img.html img="task-sequencediagram.svg" caption="Figure 4" %}

#### Formal Authorization

In provider to provider transactions, there are situations where one must provide formal authorization for each individual data request. In payer to provider and some provider to provider transactions, an overall data sharing agreement make the need for such individual authorizations unnecessary.  Where such individual authorizations are not required, Task can be used alone.  When a formal request for the information to be shared is needed it is represented by either a [CommunicationRequest] or [ServiceRequest] and referenced by Task using the the `Task.basedOn` element.  Use cases with and without authorization are illustrated in the examples below.
{:.new-content}

The [HL7 FHIR-I Workflow project] is working on a set of rules for in which circumstances it's sufficient to use Task alone to ask for an action to be performed and when the Task needs to be accompanied by a Request resource. <span class="bg-success"> This guidance is intended to be used in addition to the business practices to assist in the decision making of the information providers.</span>  That work is not complete, but so far the conclusion is that there will be some situations where Task can (and even should) exist without a Request resource and other situations where a Request will be required.
{:.stu-note}

#### Polling vs Subscriptions

Task Based exchanges can take one of two forms - *subscription* or *polling* as described in the [Exchanging with polling] and [Exchanging with FHIR Subscription] sections of the Da Vinci HRex Implementation Guide.  General guidance on whether to use polling or subscription can be found in the [Subscription Capabilities] section.

##### Polling

Polling is a mechanism for conveying new data to a Payer as (or shortly after) the data is created or updated without requiring the Provider to be aware of the specific needs of the Payer.  The Payer repeatedly queries the Provider to see if there is new data. In the Da Vinci CDex use case, the Payer would poll the Provider by fetching the Task resource to see if has been updated.  Polling is the *default option* if the Provider does not support subscribing to the Task as described below.

##### Subscription

Subscriptions allow a data source to notify interested data consumers when a specific event occurs.  In the Da Vinci CDex use case, the Payer is the subscriber and the Provider the publisher.  The Payer subscribes to a Task queue and filters on the Task resource id.  The Provider publishes notifications when there are changes to the Task instance.  <span class="bg-success">Typically,</span> the notification *does not* expose the data itself.  The subscriber would then fetch the data using a FHIR RESTful query.

<div markdown="1" class="bg-info">

- {:.bg-success}The publisher can not guarantee who has access to the nominated subscription endpoint.  By omitting the payload, the client is forced to authenticate before accessing the data which mitigates privacy and security risks on the publisher.

- Subscriptions need not be created independently for each Task - a payer could subscribe to all Tasks where they are the requester.  It's also possible that subscriptions could be established automatically or out-of-band.  However, these are implementation details that are out of scope for this guide.
</div>

This project recognizes the major revisions to the reworked R5 subscription "topic-based" pub/sub pattern and the future publication of a Subscription R5 Backport Implementation Guide for FHIR 4 to address the many shortcomings in the current (R4) approach to subscriptions. Due to these imminent changes in the FHIR pub/sub pattern, the discovery process for subscription support is *out of scope* for this version of the guide.  The Payer may discover it out-of-band or simply through trial-and-error.
{:.stu-note}

#### Fetching the Data

<span markdown="1" class="bg-success">It is up to the EHR (Data Source) to set the status of each Task as appropriate. (see the [Task state machine diagram] in the FHIR specification for more background on Task transitions).</span> When the task is completed, the Payer fetches the data of interest which is referenced by `Task.output`.  It can either refer to a 'contained' search set Bundle - because the Bundle is not something that would have any independent existence - or to external resources which are subsequently fetched by the Payer use a RESTful GET.  If there is no data found by the Provider the  `Task.status` is "failed" with a reason in `Task.statusReason` (e.g.,"no matching results") and the `Task.output` is absent.

<div markdown="1" class="new-content">

##### How Long is the Data Available

Ultimately, the Data Source determines how long the Data Consumer has access to the completed Task and the data referenced by it. The business rules between them and other constraints such as those based on privacy law will limit the time the requested data is accessible.
</div>

#### Example Transactions:

As discussed above, there are 4 basic implementation variations in any combination with task based exchanges:

1. Structured vs Free Text Request
1. Subscription vs Polling
1. Fetching Contained vs External Data
1. Whether Formal Authorization is Needed (typically in provider-provider scenarios)

The following example transactions show scenarios using task based exchanges to get clinical data from an EHR.  Each of the above variations will be demonstrated. Following the guidance in this guide and HRex, Getting Active Conditions from Provider is typically a two to five step process for the Payer.

##### Scenario 1

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

""##### Scenario 2

Referred-to Provider Seeks Patient B's Active Conditions from referring Provider to support performing the requested service.

Preconditions and Assumptions:
- There is human involvement needed to complete the request
- Referred-to Provider needs formal authorization to request data

Click on the buttons below to see example Task Requests for a Patient's Active Conditions:

{% include examplebutton_default.html example="task-scenario1-authorization" b_title = 'Click Here To See Example Task Request with a formal authorization' %}

---

</div>

##### Scenario 3

Payer A Seeks Insured Person/Patient B’s glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.

Preconditions and Assumptions:

- The Appropriateness of the request needs to be determined or access to the data is limited and there is human involvement needed to approve the release of the data:
- Payer A knows the appropriate LOINC codes for searching for HbA1c test results (e.g.: 4548-5 Hemoglobin A1c/Hemoglobin.total in Blood)

{% include examplebutton_default.html example="task-scenario2-basic" b_title = "Click Here To See Example Task Request for Patient's HBA1C Results after 2020-01-01" %}

---

##### Scenario 4

Payer A Seeks Insured Person/Patient B’s latest history and physical exam notes from Provider C to improve care coordination.

Preconditions and Assumptions:

- The Appropriateness of the request needs to be determined or access to the data is limited and there is human involvement needed to approve the release of the data:
- Payer A knows the appropriate LOINC codes for searching for History and Physical CCDA document (34117-2 History & Physical Note)

{% include examplebutton_default.html example="task-scenario3-basic" b_title = "Click Here To See Example Task Request for Patient's Latest History and Physical" %}

### Bulk Data

Payers may request data for many patients/members or anticipate large payloads from the Provider. For example, requesting all the information related to  their members using <span markdown='1' class="bg-success">`POST [base]/Group/$export`</span>.  For these requests, the [FHIR Bulk Data Access] and the [FHIR Asynchronous Request Patterns] specifications may be considered.  However, there has not been enough implementation experience with this use case to provide specific guidance in this guide.
{:.stu-note}

<br />

{% include link-list.md %}
