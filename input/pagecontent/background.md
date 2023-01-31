### About the Da Vinci Project

Da Vinci is a private sector initiative that addresses the needs of the Value-Based Care Community by leveraging the HL7 FHIR platform.  For more information about the Da Vinci Project, its use cases, members, and updates see the [Da Vinci Overview]

### What Do Payers Do with Clinical Information

Payers require clinical data from providers who order or provide services. They use this data to document prior authorization, process and audit claims, and confirm medical necessity and appropriateness. In addition, payers use clinical data to create risk profiles for members for value-based care contracts and population health adjustments. Quality reporting requirements and quality care scoring all require clinical data for evaluating clinical performance and outcomes. Payers may also collect this clinical information to assist providers with care planning options .

#### Example Scenarios

- Payer requests *attachments* for a claim submission or prior authorization.
  -  For example, additional documentation to support medical necessity or a coverage rule.
- Payer requests additional documentation to support a claims audit.
- Payer requests patient health record information to support their Risk Adjustment submissions to the Centers for Medicare and Medicaid Services (CMS).
- Payer requests patient health record information to support a [HEDIS] or CMS Five-Star Quality Measure Rating quality program.
- Payer requests patient health record information to support their member records.
- Payers request patient health record information to meet new regulatory requirements (for example, promoting patient access).

### Provider to Provider Data Exchange

 Providers commonly need and request information from other providers about their patients.  Although this guide focuses on Payer to Provider interactions, the technical exchange is no different than a Provider to Provider interaction.

#### Example Scenarios

 - Referred-to-provider solicits additional clinical information from the referring provider to support performing the requested service.
 - Referring provider needs the results from the referred-to provider.

### What Information is Needed

A sampling of the type of information needed by Payers includes:

- Medical records - for example, a progress note or visit summary
- C-CDA documents of various types
- Medications
- Laboratory results
- Clinical Assessments for Diagnoses
- Vital Signs - for example, Blood Pressure measurements
- Narrative - such as written or transcribed clinical notes

For Security and Privacy considerations refer to the [Security and Privacy] page.

### Where Does CDEX Fit in the Da Vinci Project

The Da Vinci Project developed over a dozen use cases and implementation guides. Figure 2 illustrates how the Clinical Data Exchange (CDex) use case fits in the family of Da Vinci Use Cases/Implementation Guides. This guide provides a general solution to requesting specific information from a provider. This [table](https://confluence.hl7.org/display/DVP/CDEX+Overlap+with+Other+DaVinci+IGs) summarizes the many areas of functional overlap between this guide and other Da Vinci guides. CDex is not intended to supersede these guides, which focus on a particular use case and define how to share clinical information. However, CDex may be used to request clinical data from a provider when:

- An alternative is needed to cover some aspects of an exchange. For example, suppose the provider's data release process does not allow the automatic request for information specified in a use case specific IG. In that case, CDex provides an asynchronous process that allows manual review before releasing the information. However, implementers should not use this transaction when there is a requirement for real-time response to facilitate patient care. 
- There is a specific exchange that is not already addressed by one of the other IGs  For example, in [Da Vinci Prior Authorization Support (PAS)], the Payer could request additional information for prior authorization using CDex.
- The other IG has yet to be or can not be implemented for the use case. For example, the [Data Exchange For Quality Measures (DEQM) Implementation Guide] provides a standard method for automating the reporting of quality measures. Implementers can use CDex when:
  1. A Provider has not yet implemented DEQM
  2. An audit of a quality measure requires additional information.

 The use of CDex **SHALL NOT** be considered compliant with any use case specific IG where CDex is not explicitly required as part of the supported exchanges. 

{% include img.html img="davinci-use-cases.svg" caption="Figure 2" %}
### Workflow Overview

FHIR offers numerous architectural approaches for sharing data between systems. Each has pros and cons, and the most appropriate one depends on the circumstances under which systems exchange data. (Review the [Approaches to Exchanging FHIR Data] in the Da Vinci HRex Implementation Guide for more guidance and background.)  This guide focuses on **three** FHIR transaction approaches for requesting information:

1. **[Direct Query]:** A Payer or external Provider system directly queries the Provider system for specific data using the standard FHIR RESTful search.
2. **[Task Based Approach]:** A Payer or external Provider system requests the information desired using the FHIR *Task* resource. The Provider system supplies the data. Human involvement may be needed to find/aggregate/filter/approve it.
3. **[Solicited and Unsolicited Attachments]** A Payer system requests attachments (additional documentation) for claims or prior authorization using the FHIR *Task* resource. The Provider system uses a "push" based FHIR operation to submit attachments to the Payer.

<div markdown="1" class="stu-note">

Payers may request data for many patients/members or anticipate large payloads from the Provider. For example, they ask for detailed clinical information about their members. Implementers may consider using the [Bulk Data Access IG] and the [FHIR Asynchronous Request Patterns]  for these requests. However, there needs to be more implementation experience with this use case to provide specific guidance in this guide.
</div><!-- stu-note -->

#### Direct Query and Task-Based Workflows

Figure 3 below illustrates the exchange of clinical data between a Payer (or Provider) system and a Provider system using the *Direct Query* and *Task-Based* workflows.  

{% include img.html img="workflow-overview.svg" caption="Figure 3" %}

##### Actors and Roles

- The Payer or External Provider System acts as a *data consumer*.
- The Provider system acts as a *data source*.\*
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

1. The data source submits the attachments and metadata for the association to the claim or prior authorization (for example, member id and claim id).
   - attachments are submitted **without an explicit request** as *unsolicited* attachments. 
2. Payer system accepts attachments.[^1]

##### Solicited Attachments Workflow

Figure 5 below illustrates the exchange of clinical data between a Payer system and a Provider system using the *Solicited Attachments* workflow.

{% include img.html img="workflow-solicited-attachments.svg" caption="Figure 5" %}

###### Steps

1. For *solicited* attachments, the data consumer initiates a request for attachments for a claim or prior authorization.
    - This can be a FHIR or non-FHIR-based transaction
2. The data source submits the attachments and metadata (for example, member id and claim id) for the association to the claim or prior authorization.
3. Payer system accepts attachments.[^1]

---

[^1]: The Payer's method for associating attachments to claims or prior authorizations and processing them is out of scope for this guide. 

{% include link-list.md %}
