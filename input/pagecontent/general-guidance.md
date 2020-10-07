This sections provides specific guidance on exchanging clinical data between Payers and Providers.  For general Background on FHIR, Conformance Expectations, and Security and Privacy considerations, refers to the corresponding sections in the [Da Vinci Health Record Exchange (HRex)] Implementation Guide.

### Exchanging Clinical Data

FHIR offers numerous architectural approaches for sharing data between systems. Each approach has pros and cons. The most appropriate approach depends on the circumstances under which data is exchanged. This page provides an overview of each approach, with pros, cons and a decision tree to help guide choices about which approach best suits a specific set of circumstances.  Review the *Approaches to Exchanging FHIR Data* in the Da Vinci HRex Implementation Guide for more guidance and background.

Da Vinci Clinical Data Exchange (CDex) focuses on three FHIR transaction scenarios for requesting information:

1. Payer directly queries EHR for specific data using the standard FHIR RESTful search.
1. Payer identifies the 'type' of information desired in such a way that an EHR automated process (possibly payer-specific) can automatically return the data.
1. Payer identifies the 'type' of information desired or a specific RESTful query to be executed, but there is human involvement needed to find the data, aggregate the data, filter the data and/or approve its release.

### Direct Query

For the first scenario, guidance for exchanging data with FHIR search is fully described in the base FHIR specification and the Da Vinci HRex Implementation Guide.  Refer to the [US Core] Implementation guide for accessing the set of health data classes and data elements defined by the [ONC United States Core Data for Interoperability (USCDI)].

#### Example Interactions:

{% include examplebutton_default.html example="todo" b_title = "Click Here To See Example Direct Query for Patient's Active Conditions" %}

{% include examplebutton_default.html example="todo" b_title = "Click Here To See Example Direct Query for Patient's HBA1C Results after 2020-01-01" %}

{% include examplebutton_default.html example="todo" b_title = "Click Here To See Example Direct Query for Patient's Latest History and Physical" %}

### Task Based Approach

This guide defines a single approach using [Task] to satisfy the last two transaction scenarios.  One interface means greater interoperability and less development costs and it makes it easier for an EHR to transition from human-mediated to non-human-mediated interactions over time.  The details for these transaction are described in the *CommunicationRequest plus Task* section and the *Requesting Exchange using Task* sections of the Da Vinci HRex Implementation Guide.

Note that Task is used alone when there is no need for a formal authorization. When an authorization is needed, the `Task.focus` element reference a [contained] CommunicationRequest within the Task.  [CommunicationRequest] is used to represent the  authorizations (orders) for data to flow.  The use of a contained CommunicationRequest simplifies the workflow.  There will be some situations where Task can (and even should) exist without a Request resource and other situations where a Request will be required.

For CDex Task based transaction the [CDex Task Data Request Profile] **SHALL** be used.

The [HL7 FHIR-I Workflow project] is working on a set of rules for in which circumstances it's sufficient to use Task alone to ask for an action to be performed and when the Task needs to be accompanied by a Request resource.  That work is not complete, but so far the conclusion is that there will be some situations where Task can (and even should) exist without a Request resource and other situations where a Request will be required.
{:.bg-info}

#### Polling vs Subscriptions

Task Based exchanges can take one of two forms - subscription or polling as described in the *Exchanging with polling* and *Exchanging with FHIR Subscription* sections of the Da Vinci HRex Implementation Guide.  General guidance on whether to use polling or subscription can be found in the *Subscription capability?* section.

Polling is a mechanism for conveying new data to a Payer as (or shortly after) the data is created or updated without requiring the Provider to be aware of the specific needs of the Payer.  The Payer repeatedly queries the Provider to see if there is new data. In the Da Vinci CDex use case, the Payer would poll the Provider by fetching the Task resource to see if has been updated.

Subscriptions allow a data source to notify interested data consumers when a specific event occurs.  In the Da Vinci CDex use case, the Payer is the subscriber and the Provider the publisher.  The Payer subscribes to a Task queue and filters on the Task resource id.  The Provider publishes notifications when there are changes to the the Task instance.  The notification does not expose the data itself.  The subscriber would then fetch the data using a FHIR RESTful query.

Subscriptions need not be created independently for each Task - a payer could subscribe to all Tasks where they are the requester.  It's also possible that subscriptions could be established automatically or out-of-band
{:.bg-info}

The subscription notification could contain the Task and associated data in the response but this approach imposes serious privacy and security risks on the sender.
{:.bg-danger}

This project recognizes the major revisions to the reworked R5 subscription"topic-based" pub/sub pattern and the future publication of a Subscription R5 Backport Implementation Guide for FHIR 4 to address the many shortcomings in the current (R4) approach to subscriptions.
{:.note-to-balloters}

#### Benefits

All except the last are relevant whether human intervention is needed or not.

- Easy ability to say 'yes' or 'no', including providing a reason for refusal.
- Allows linking the request to its associated outputs without creating a new resource
- Can be polled or subscribed to to retrieve the results
- Allows conveying the 'status' of a request in progress
   - Monitoring for status doesn't require a change in workflow from monitoring for final results - i.e. there's no increase in complexity for the receiver whether status updates occur or not
   - Note automated processes typically won't have status updates.

#### Example Interactions:

{% include examplebutton_default.html example="todo2" b_title = "Click Here To See Example Task Request for Patient's Active Conditions" %}

{% include examplebutton_default.html example="todo2" b_title = "Click Here To See Example Task Request for Patient's HBA1C Results after 2020-01-01" %}

{% include examplebutton_default.html example="todo2" b_title = "Click Here To See Example Task Request for Patient's Latest History and Physical" %}

### Bulk Data

If Payers are requesting data for many patients/members or anticipate large payloads from the Provider, [FHIR Bulk Data Access] and the [FHIR Asynchronous Request Patterns] may be considered. However there has not been enough implementation experience with this use case to provide specific guidance in this guide.
{:.bg-info}

{% include link-list.md %}
