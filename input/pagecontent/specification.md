This sections provides specific guidance on exchanging clinical data between Payers and Providers.  For general *Background on FHIR*, *Conformance Expectations*, and *Security and Privacy* considerations, refer to the corresponding sections in the [Da Vinci Health Record Exchange (HRex)] Implementation Guide.

### Exchanging Clinical Data

FHIR offers numerous architectural approaches for sharing data between systems. Each approach has pros and cons. The most appropriate approach depends on the circumstances under which data is exchanged.  (Review the *Approaches to Exchanging FHIR Data* in the Da Vinci HRex Implementation Guide for more guidance and background.)  The guide focuses on **two** FHIR transaction approaches for requesting information:

1. **Direct Query (preferred):** Payer directly queries EHR for specific data using the standard FHIR RESTful search.
1. **Task Based Approach:** Payer identifies the 'type' of information desired and the EHR supplies the data possibly with human involvement to find/aggregate/filter/approve it.

### Direct Query

For Direct Query, the Payer directly queries the EHR for specific data using the standard FHIR RESTful search. *This is the preferred option*. Guidance for exchanging data with FHIR search is fully described in the base FHIR specification and the Da Vinci HRex Implementation Guide.  Refer to the [US Core] Implementation guide for accessing the set of health data classes and data elements defined by the [ONC United States Core Data for Interoperability (USCDI)].

#### Benefits this Approach

 - "Out of the Box" FHIR Transaction
 - Widely implemented
 - Simplest Workflow
 - Authorization/Authentication protocols established
 - No Human intervention needed

#### Purpose of Use

In some cases it may be important to transmit the *Purpose of Use* in the Authorization Framework (OAuth) when querying for data.  The details of incorporating the reason for a query into OAuth is an area of active discussion. Once a suitable approach has been agreed upon and published, it will be referenced in a future version of this guide.
{:.note-to-balloters}

#### Sequence Diagram

The sequence diagram in Figure 2 below outlines a successful interaction between the Payer and EHR to query and retrieve the requested data using a direct query:

{% include img.html img="search-sequencediagram.svg" caption="Figure 2" %}

#### Example Transactions:

The following example transactions show scenarios of using direct query to get clinical data from an EHR.

{% include examplebutton_default.html example="direct-query1-scenario" b_title = "Click Here To See Example Direct Query for Patient's Active Conditions" %}

{% include examplebutton_default.html example="direct-query2-scenario" b_title = "Click Here To See Example Direct Query for Patient's HbA1c Results after 2020-01-01" %}

{% include examplebutton_default.html example="direct-query3-scenario" b_title = "Click Here To See Example Direct Query for Patient's Latest History and Physical" %}

### Task Based Approach

This guide uses a Task Based Approach to satisfy the Payer's need to request the information it needs when it can not perform a direct query. The decision to use this approach is based on the following factors:

- Whether a specific Authorization is needed
- The Access to the data is limited (for example due to patient privacy concerns the data needs to be reviewed and/or filtered )
- The Appropriateness of the request needs to be determined
- The data needed is described in an unstructured or noncomputable form.
  - Because the payor does not have knowledge of specific codes or identifiers to make a direct query
  - Because there is no way to describe the data in a structure format it is described in free text.
- A Direct Query is otherwise not feasible

In most of these situation, there is human involvement needed to find the data, aggregate the data, filter the data and/or approve its release.  The details for these transaction are described in the *CommunicationRequest plus Task* section and the *Requesting Exchange using Task* sections of the Da Vinci HRex Implementation Guide.

**For CDex Task based transactions the [CDex Task Data Request Profile] **SHALL** be used by the Payer

#### Benefits this Approach

All of the following except the last of these benefits are relevant whether human intervention is needed or not.

- Easy ability to say 'yes' or 'no', including providing a reason for refusal.
- Provides the ability to represent the reason (*Purpose of Use*) in the `Task.reasonCode` element using either codes or free text.
- Allows linking the request to its associated outputs without creating a new resource
- Can be polled or subscribed to to retrieve the results
- Allows conveying the 'status' of a request in progress
   - Monitoring for status doesn't require a change in workflow from monitoring for final results - i.e. there's no increase in complexity for the receiver whether status updates occur or not
   - Note automated processes typically won't have status updates.

#### Sequence Diagram

The sequence diagram in Figure 3 below summarizes the basic interaction between the Payer and EHR to query and retrieve the requested data using the Task based transaction.   However, there are three implementation variations with Task Based Exchange discussed below:


{% include img.html img="task-sequencediagram.svg" caption="Figure 3" %}

#### Authorization

The most common scenario is where Task can (and even should) exist without an authorization. Task is used alone when there is no need for a formal authorization (order). In other situations when an authorization is needed, the `Task.basedOn` element references either a [CommunicationRequest] or [ServiceRequest] to represent the authorization for data to flow. Both of these use cases ( with and without authorization) are illustrated in the examples below.

The [HL7 FHIR-I Workflow project] is working on a set of rules for in which circumstances it's sufficient to use Task alone to ask for an action to be performed and when the Task needs to be accompanied by a Request resource.  That work is not complete, but so far the conclusion is that there will be some situations where Task can (and even should) exist without a Request resource and other situations where a Request will be required.
{:.note-to-balloters}

#### Polling vs Subscriptions

Task Based exchanges can take one of two forms - *subscription* or *polling* as described in the *Exchanging with polling* and *Exchanging with FHIR Subscription* sections of the Da Vinci HRex Implementation Guide.  General guidance on whether to use polling or subscription can be found in the *Subscription capability?* section.

##### Polling

Polling is a mechanism for conveying new data to a Payer as (or shortly after) the data is created or updated without requiring the Provider to be aware of the specific needs of the Payer.  The Payer repeatedly queries the Provider to see if there is new data. In the Da Vinci CDex use case, the Payer would poll the Provider by fetching the Task resource to see if has been updated.  Polling is the *default option* if the Provider does not support subscribing to the Task as described below.

##### Subscription

Subscriptions allow a data source to notify interested data consumers when a specific event occurs.  In the Da Vinci CDex use case, the Payer is the subscriber and the Provider the publisher.  The Payer subscribes to a Task queue and filters on the Task resource id.  The Provider publishes notifications when there are changes to the the Task instance.  The notification does not expose the data itself.  The subscriber would then fetch the data using a FHIR RESTful query.

<div markdown="1" class="bg-info">
Note
- The subscription notification could contain the Task and associated data in the response but this approach imposes excessive privacy and security risks on the sender.

- Subscriptions need not be created independently for each Task - a payer could subscribe to all Tasks where they are the requester.  It's also possible that subscriptions could be established automatically or out-of-band.  However, these are implementation details that are out of scope for this guide.
</div>

This project recognizes the major revisions to the reworked R5 subscription "topic-based" pub/sub pattern and the future publication of a Subscription R5 Backport Implementation Guide for FHIR 4 to address the many shortcomings in the current (R4) approach to subscriptions. Due to these imminent changes in the FHIR pub/sub pattern, the discovery process for subscription support is *out of scope* for this version of the guide.  The Payer may discover it out-of-band or simply through trial-and-error.
{:.note-to-balloters}

#### Fetching the Data

When the task is complete, the Payer fetches the data of interest which is referenced by `Task.output`.  It can either refer to a 'contained' search set Bundle - because the Bundle isn't something that would have any independent existence - or to external resources which are subsequently fetched by the Payer use a RESTful GET.

#### Example Transactions:

As discussed above, there are 4 basic implementation variations in any combination with task based exchanges:

1. structured vs free text request
1. Whether a formal authorization is needed
1. Subscription vs polling
1. Fetching contained vs external data

The following example transactions show scenarios using task based exchanges to get clinical data from an EHR.  Each of the above variations will be demonstrated. Following the guidance in this guide and HRex, Getting Active Conditions from Provider is typically a two to five step process for the Payer.

##### Scenario 1

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C to confirm medical necessity.

Preconditions and Assumptions:
- The Appropriateness of the request needs to be determined or access to the data is limited and there is human involvement needed to approve the release of the data:

Click on the buttons below to see example Task Requests for a Patient's Active Conditions:

{% include examplebutton_default.html example="task-scenario1-basic" b_title = 'Basic interaction using no formal authorization, Structured data for request, Polling, External resource references for output' %}

{% include examplebutton_default.html example="todo2" b_title = 'Interaction with a formal authorization' %}

{% include examplebutton_default.html example="task-scenario1-free" b_title = 'Interaction using free text for the request instead of structured data.' %}

{% include examplebutton_default.html example="task-scenario1-subscription" b_title = 'Interaction using subscriptions instead of polling.' %}

{% include examplebutton_default.html example="task-scenario1-contained" b_title ='Interaction using contained resource references for output instead of external references.' %}

---

##### Scenario 2

{% include examplebutton_default.html example="todo2" b_title = "Click Here To See Example Task Request for Patient's HBA1C Results after 2020-01-01" %}

---

##### Scenario 3

{% include examplebutton_default.html example="todo2" b_title = "Click Here To See Example Task Request for Patient's Latest History and Physical" %}

### Bulk Data

Payers may request data for many patients/members or anticipate large payloads from the Provider. For example, requesting all the information related to  their members using `POST [base]/Patient/$everything`.  For these requests, the [FHIR Bulk Data Access] and the [FHIR Asynchronous Request Patterns] specifications may be considered.  However, there has not been enough implementation experience with this use case to provide specific guidance in this guide.
{:.note-to-balloters}

<br />

{% include link-list.md %}
