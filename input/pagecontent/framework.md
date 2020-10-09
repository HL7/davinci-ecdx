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

#### Sequence Diagram

The sequence diagram in Figure 2 below outlines a successful interaction between the Payer and EHR to query and retrieve the requested data using a direct query:

{% include img.html img="search-sequencediagram.svg" caption="Figure 2" %}

#### Example Transactions:

The following example transactions show scenarios of using direct query to get clinical data from an EHR.

{% include examplebutton_default.html example="todo" b_title = "Click Here To See Example Direct Query for Patient's Active Conditions" %}

{% include examplebutton_default.html example="todo" b_title = "Click Here To See Example Direct Query for Patient's HBA1C Results after 2020-01-01" %}

{% include examplebutton_default.html example="todo" b_title = "Click Here To See Example Direct Query for Patient's Latest History and Physical" %}

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

For CDex Task based transactions the [Hrex Task Data Request Profile] **SHALL** be used by the Payer
{:.bg-warning}

#### Benefits this Approach

All of the following except the last of these benefits are relevant whether human intervention is needed or not.

- Easy ability to say 'yes' or 'no', including providing a reason for refusal.
- Allows linking the request to its associated outputs without creating a new resource
- Can be polled or subscribed to to retrieve the results
- Allows conveying the 'status' of a request in progress
   - Monitoring for status doesn't require a change in workflow from monitoring for final results - i.e. there's no increase in complexity for the receiver whether status updates occur or not
   - Note automated processes typically won't have status updates.

#### Sequence Diagram

The sequence diagram in Figure 3 below outlines the interaction between the Payer and EHR to query and retrieve the requested data using the Task based transaction:

{% include img.html img="task-sequencediagram.svg" caption="Figure 3" %}

#### Authorization

The most common scenario is where Task can (and even should) exist without an authorization. Task is used alone when there is no need for a formal authorization (order). In other situations when an authorization is needed, the `Task.basedOn` element references either a [CommunicationRequest] or [ServiceRequest] to represent the authorization for data to flow. Both of these use cases ( with and without authorization) are illustrated in the examples below.

The [HL7 FHIR-I Workflow project] is working on a set of rules for in which circumstances it's sufficient to use Task alone to ask for an action to be performed and when the Task needs to be accompanied by a Request resource.  That work is not complete, but so far the conclusion is that there will be some situations where Task can (and even should) exist without a Request resource and other situations where a Request will be required.
{:.note-to-balloters}

#### Polling vs Subscriptions

Task Based exchanges can take one of two forms - *subscription* or *polling* as described in the *Exchanging with polling* and *Exchanging with FHIR Subscription* sections of the Da Vinci HRex Implementation Guide.  General guidance on whether to use polling or subscription can be found in the *Subscription capability?* section.

##### Polling

Polling is a mechanism for conveying new data to a Payer as (or shortly after) the data is created or updated without requiring the Provider to be aware of the specific needs of the Payer.  The Payer repeatedly queries the Provider to see if there is new data. In the Da Vinci CDex use case, the Payer would poll the Provider by fetching the Task resource to see if has been updated.

##### Subscription

Subscriptions allow a data source to notify interested data consumers when a specific event occurs.  In the Da Vinci CDex use case, the Payer is the subscriber and the Provider the publisher.  The Payer subscribes to a Task queue and filters on the Task resource id.  The Provider publishes notifications when there are changes to the the Task instance.  The notification does not expose the data itself.  The subscriber would then fetch the data using a FHIR RESTful query.

<div markdown="1" class="bg-info">
Note

- The subscription notification could contain the Task and associated data in the response but this approach imposes excessive privacy and security risks on the sender.

- Subscriptions need not be created independently for each Task -- a payer could subscribe to all Tasks where they are the requester.  It's also possible that subscriptions could be established automatically or out-of-band.  However, these are implementation details that are out of scope for this guide.
</div>


This project recognizes the major revisions to the reworked R5 subscription "topic-based" pub/sub pattern and the future publication of a Subscription R5 Backport Implementation Guide for FHIR 4 to address the many shortcomings in the current (R4) approach to subscriptions.
{:.note-to-balloters}

#### Example Transactions:

The following example transactions show scenarios of using direct query to get clinical data from an EHR.

#### No Authorization Needed

{% include examplebutton_default.html example="todo2" b_title = "Click Here To See Example Task Request for Patient's Active Conditions" %}

{% include examplebutton_default.html example="todo2" b_title = "Click Here To See Example Task Request for Patient's HBA1C Results after 2020-01-01" %}

{% include examplebutton_default.html example="todo2" b_title = "Click Here To See Example Task Request for Patient's Latest History and Physical" %}

#### With Authorization

{% include examplebutton_default.html example="todo2" b_title = "Click Here To See Example Task Request for Patient's Active Conditions" %}

{% include examplebutton_default.html example="todo2" b_title = "Click Here To See Example Task Request for Patient's HBA1C Results after 2020-01-01" %}

{% include examplebutton_default.html example="todo2" b_title = "Click Here To See Example Task Request for Patient's Latest History and Physical" %}

### Bulk Data

Payers may request data for many patients/members or anticipate large payloads from the Provider. For example, requesting all the information related to  their members using `POST [base]/Patient/$everything`.  For these requests, the [FHIR Bulk Data Access] and the [FHIR Asynchronous Request Patterns] specifications may be considered.  However, there has not been enough implementation experience with this use case to provide specific guidance in this guide.
{:.note-to-balloters}

{% include link-list.md %}
