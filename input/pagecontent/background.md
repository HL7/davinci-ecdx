### About the Da Vinci Project

Da Vinci is a private sector initiative that addresses the needs of the Value-Based Care Community by leveraging the HL7 FHIR platform. For more information about the Da Vinci Project, its use cases, members, and updates, see the [Da Vinci Overview]

### What Do Payers Do with Clinical Information

Payers require clinical data from providers who order or provide services. They use this data to document prior authorization, process and audit claims, and confirm medical necessity and appropriateness. In addition, payers use clinical data to create risk profiles for members for value-based care contracts and population health adjustments. Quality reporting requirements and quality care scoring require clinical data for evaluating clinical performance and outcomes. Payers may also collect this clinical information to assist providers with care planning options.

#### Example Scenarios

- Payer requests *attachments* for a claim submission or prior authorization.
  - For example, additional documentation to support medical necessity or a coverage rule.
- Payer requests additional documentation to support a claims audit.
- Payer requests patient health record information to support their Risk Adjustment submissions to the Centers for Medicare and Medicaid Services (CMS).
- Payer requests patient health record information to support their member records.
- Payer requests additional information related to quality reporting.
- Payers request patient health record information to meet new regulatory requirements (for example, promoting patient access).

### Provider to Provider Data Exchange

 Providers commonly need and request information about their patients from other providers. Although this guide focuses on payer-to-provider interactions, the technical exchange is no different from a provider-to-provider interaction.

#### Example Scenarios

 - The referred-to provider solicits additional clinical information from the referring provider to support the performance of the requested service.
 - The referring provider needs the results from the referred-to provider.

### What Information is Needed

A sampling of the type of information needed by Payers includes:

- Medical records - for example, a progress note or visit summary
- C-CDA documents of various types
- Medications
- Laboratory results
- Clinical Assessments for Diagnoses
- Vital Signs - for example, Blood Pressure measurements
- Narrative - such as written or transcribed clinical notes

For Security and Privacy considerations, refer to the [Security and Privacy] page.

### Where Does CDEX Fit in the Da Vinci Project

[Da Vinci Use Cases] are interrelated, currently with five categories that have emerged: Quality Improvement, Coverage/Burden Reduction, Member Access, Process Improvement, and Clinical Data Exchange.  A table that summarizes the many areas of functional overlap between this guide and other Da Vinci guides is available [here](https://confluence.hl7.org/display/DVP/CDEX+Overlap+with+Other+DaVinci+IGs). CDex is not intended to supersede other Da Vinci guides, which focus on a particular use case and define how to share clinical information. However, CDex may be used to request clinical data from a provider when:

- An alternative is needed to cover some aspects of an exchange. For example, suppose the provider's data release process does not allow the automatic request for information specified in a use case specific IG. In that case, CDex provides an asynchronous process that allows manual review before releasing the information. However, implementers should not use this transaction when there is a requirement for real-time response to facilitate patient care. 
- There is a specific exchange that is not already addressed by one of the other IGs 

 The use of CDex **SHALL NOT** be considered compliant with any use case specific IG where CDex is not explicitly required as part of the supported exchanges. 

### Workflow Overview

FHIR offers numerous architectural approaches for sharing data between systems. Each has pros and cons; the most appropriate one depends on the circumstances under which systems exchange data. (Review the [Architectural Approach](#architectural-approach) section below for more detail.)  This guide focuses on **three** FHIR transaction approaches for requesting information:

1. **[Direct Query]:** A Payer or external Provider system directly queries the Provider system for specific data using the standard FHIR RESTful search.
2. **[Task Based Approach]:** A Payer or external Provider system requests data using the FHIR *Task* resource. The Provider system supplies the data. Human involvement may be needed to find/aggregate/filter/approve it.
3. **[Solicited and Unsolicited Attachments]** The payer system requests attachments (additional documentation) for claims or prior authorization using the FHIR *Task* resource. The Provider system uses a “push” based FHIR operation to submit attachments to the Payer.

<div markdown="1" class="stu-note">

Payers may request data for many patients/members or anticipate large payloads from the Provider. For example, they ask for detailed clinical information about their members. Implementers may consider using the [Bulk Data Access IG] and the [FHIR Asynchronous Request Patterns] for these requests. However, more implementation experience with this use case is needed to provide specific guidance in this guide.
</div><!-- stu-note -->

#### Direct Query and Task-Based Workflows

Figure 3 below illustrates the exchange of clinical data between a Payer (or Provider) system and a Provider system using the *Direct Query* and *Task-Based* workflows.  

{% include img.html img="workflow-overview.svg" caption="Figure 3" %}

##### Actors and Roles

- The Payer or External Provider System acts as a *data consumer*.
- The Provider system acts as a *data source*.
- A human practitioner is involved in approving/filtering the information provided.
  - A pre-existing agreement could be in place that allows data to be shared *without* human intervention.

##### Steps

1. The data consumer initiates a request for information.
1. The data source retrieves the requested data.
1. A human practitioner may review the data before sending it back to the data consumer.
1. The data is sent back to the data consumer.

#### Solicited and Unsolicited Attachments Workflows

This specification divides attachments for claims or prior authorization into solicited and unsolicited workflows. Both are illustrated below.

##### Actors and Roles

- The Payer system acts as a *data consumer*.
- The Provider system acts as a *data source*.

##### Unsolicited Attachments Workflow

Figure 4 below illustrates the exchange of clinical data between a Provider system and a Payer system using the *Unsolicited Attachments* workflow.

{% include img.html img="workflow-unsolicited-attachments.svg" caption="Figure 4" %}

###### Steps

1. The Provider submits the attachments and metadata for the association to the claim or prior authorization (for example, member id and claim id).
   - attachments are submitted **without an explicit request** as *unsolicited* attachments. 
2. The Payer system accepts attachments. (This guide does not cover the payer's method for associating attachments to claims or prior authorizations and processing them.)
##### Solicited Attachments Workflow

Figure 5 below illustrates the exchange of clinical data between a Payer system and a Provider system using the *Solicited Attachments* workflow.

{% include img.html img="workflow-solicited-attachments.svg" caption="Figure 5" %}

###### Steps

1. For *solicited* attachments, the Payer initiates a request for attachments for a claim or prior authorization.
    - This can be a FHIR or non-FHIR-based transaction
2. The Provider submits the attachments and metadata (for example, member id and claim id) for the association to the claim or prior authorization.
3. The Payer system accepts attachments. (This guide does not cover the payer's method for associating attachments to claims or prior authorizations and processing them.)



### Architectural Approach

All Da Vinci IGs that define [CapababilityStatements]({{site.data.fhir.path}}capabilitystatement.html) setting expectations for support for specific FHIR interactions, operations, or other exchange mechanisms include this section explaining the IG's choice of exchange architecture in terms of the [Approaches to Exchanging FHIR Data](https://hl7.org/fhir/exchanging.html) page documented in the FHIR version R5 specification.

#### Direct Query

Direct Query is the standard FHIR RESTful search and is the simplest, most adopted, and reusable approach for clinical data exchange between a Data Consumer and a Data Source.

##### Decision Tree

- Consumer initiates? - **Yes** - The CDex Data Consumer systems initiate the transaction when it needs clinical information from the CDex Data Source.
- Direct Connection? - **Yes** - It was presumed that CDex Data Consumer systems could connect directly with the CDex Data Source system.
- Human intervention? - **No** - There was no expectation the CDex Data Source would need human intervention to return the information. 
- Is data pre-existing? - **Yes** - Generally, it was presumed the CDex Data Source has data about a patient/member.
- Return FHIR resources? - **Yes** - The CDex Data Source could return FHIR resources.
- Ad-hoc query? - **Yes** - It was presumed that CDex Data Consumer would create Ad-hoc RESTful queries to get the data from the CDex Data Source.
- Synchronous? - **Yes** - It was presumed that the RESTful queries are *synchronous*.

#### Task-Based Workflow

Although not as widely adopted as the FHIR RESTful approach, the Task-Based approach is a highly reusable clinical data exchange between a Data Consumer and a Data Source. See the [Task Based Approach] page for its benefits over Direct Query and when to use it.

##### Decision Tree

- Consumer initiates? - **Yes** - The CDex Data Consumer systems initiate the transaction when clinical information from the CDex Data Source is needed.
- Direct Connection? - **Yes** - It was presumed that CDex Data Consumer systems could connect directly with the CDex Data Source system to create Tasks and fetch resources.
- Human intervention? - **Yes** - There was an expectation the CDex Data Source may need human intervention to return the information. 
- Is data pre-existing? - **Yes** - Generally, it was presumed the CDex Data Source has data about a patient/member.
- Return FHIR resources? - **Yes** - The CDex Data Source could return FHIR resources.
- Ad-hoc query? - **Yes** - It was presumed that CDex Data Consumer would create an Ad-hoc data request using `Task.input` to get the data from the CDex Data Source.
- Synchronous? - **No** - It was presumed that the Task-based queries are *asynchronous*.
- Subscription capability? - **Maybe** - It was presumed that the CDex Data Consumer would use *polling* or *subscriptions*  to determine when the Task is completed.

#### Solicited and Unsolicited Attachments Workflow

##### Sending Attachments Using a FHIR Process Operation

The CDex Data Source  (i.e., the Provider) uses the [`$submit-attachment`] operation to *push* clinical data to the CDex Data Consumer (i.e., the Payer) in both solicited and solicited attachment transactions. This transaction is specialized to the CDex Attachments use case and is not reusable for other clinical data exchanges.

###### Decision Tree

- Push? - **Yes** - It was presumed that the CDex Data Source would *push* the clinical data to the CDex Data Consumer.
- Configured by consumer? - **No** - It was presumed that the CDex Data Consumer would share all the clinical data for all transactions.
- Direct Connection? - **Yes** - It was presumed that CDex Data Source systems could connect directly with the CDex Data Consumer system.
- Data source directs consumer persistence? - **No** - It was presumed that the CDex Data Consumer is unaware of the existing data and would share all the clinical data for all transactions.
- Is message-like? - **No** - It was presumed that there is no need for explicit support for routing and that Operations are a lighter-weight solution.

##### Requesting Attachment using Task

Requesting Attachment using Task is a specialization of the [Task-Based Workflow](#task-based-workflow) transaction. In contrast to the Task Based Workflow, it is not reusable for other clinical data exchanges. Additionally, the CDex Data Source (i.e., the Provider) *pushes* the data to the Payer-supplied endpoint using the [`$submit-attachment`] operation documented in the [Sending Attachments Using a FHIR Process Operation](#sending-attachments-using-a-fhir-process-operation) section above.

###### Decision Tree

- Consumer initiates? - **Yes** -  The CDex Data Consumer systems initiate the transaction when clinical information from the CDex Data Source is needed.
- Direct Connection? - **Yes** - It was presumed that CDex Data Consumer systems could connect directly with the CDex Data Source system to create Tasks and fetch resources.
Human intervention? **Yes** - There was an expectation the CDex Data Source may need human intervention to return the information. 
- Is data pre-existing? - **Yes** - Generally, it was presumed the CDex Data Source has data about a patient/member.
- Return FHIR resources? - **Yes** - The CDex Data Source could return FHIR resources.
- Ad-hoc query? - **Yes** - It was presumed that CDex Data Consumer would create Ad-hoc data requests using `Task.input` to get the data from the CDex Data Source.
- Synchronous? - **No** - It was presumed that the Task-based queries are *asynchronous*.
- Push? - **Yes** - It was presumed that the CDex Data Source would *push* the clinical data to the CDex Data Consumer when the Task is complete. See the decision tree in the [Sending Attachments Using a FHIR Process Operation](#sending-attachments-using-a-fhir-process-operation) section above.

<!-- ### Implementer Support

The [CDex Implementer Support page] provides further context on the detailed representation of the clinical data and data payload in a provider-to-payer exchange. FHIR examples demonstrating representation of this guidance are provided to illustrate the points made in the guide. It is possible that some of this content will be merged into the CRD FHIR Implementation Guides (IG) in a future release. -->

{% include link-list.md %}
