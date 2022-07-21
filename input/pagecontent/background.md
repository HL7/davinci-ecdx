### About the Da Vinci Project

Da Vinci is a private sector initiative that addresses the needs of the Value-Based Care Community by leveraging the HL7 FHIR platform.  For more information about the Da Vinci Project, its use cases, members, and updates see the [Da Vinci Overview]

### What Do Payers Do with Clinical Information?

Payers require clinical data from providers who order or provide services. They use this data to document prior authorization, process and audit claims, and confirm medical necessity and appropriateness.  Clinical data is used by Payers to create risk profiles for members for value-based care contracts and population health adjustments. Quality reporting requirements and quality care scoring all require clinical data for evaluating clinical performance and outcomes. <span class="bg-success" markdown="1">Payers also want to create a clinical record of their members to be able to reduce redundant care and make better medical treatment and care planning recommendations to providers.</span><!-- new-content -->

#### Example Scenarios

- <span class="bg-success" markdown="1">Payer requests *attachments* for a claim submission or prior authorization.</span><!-- new-content -->
  -  <span class="bg-success" markdown="1">For example, additional documentation to support medical necessity or a coverage rule.</span><!-- new-content -->
- Payer requests <span class="bg-success" markdown="1">additional documentation</span><!-- new-content --> to support a claims audit.
- Payer requests patient health record information to support their Risk Adjustment submissions to the Centers for Medicare and Medicaid Services (CMS).
- Payer requests patient health record information to support a [HEDIS] or CMS Five-Star Quality Measure Rating quality program.
- Payer requests patient health record information to support their member records.
- Payers request patient health record information to meet new regulatory requirements (for example, promoting patient access).

### Provider to Provider Data Exchange

 Providers commonly need and request information from other providers about their patients.  Although this guide focuses on Payer to Provider interactions, the technical exchange is no different than a Provider to Provider interaction.

#### Example Scenarios

 - Referred-to-provider solicits additional clinical information from referring provider to support performing the requested service.
 - Referring provider needs the results from the referred-to provider.

### What Information is Needed?

A sampling of the type of information needed by Payers includes:

- Medical records - for example, a progress note or visit summary
- C-CDA’s of various types
- Medications
- Laboratory results
- Clinical Assessments for Diagnoses
- Vital Signs - for example, Blood Pressure measurements
- Narrative - such as written or transcribed clinical notes


For Security and Privacy considerations refer to the [Security and Privacy] page.

### Where Does CDEX Fit in the Da Vinci Project?

There are over a dozen use cases and corresponding Implementation guides being developed by the Da Vinci Project.  Figure 2 illustrates how the Clinical Data Exchange (CDex) use case fits in the family of Da Vinci Use Cases/Implementation Guides.  There are many areas of functional overlap between this guide and other Da Vinci guides which are summarized in this [table](https://confluence.hl7.org/display/DVP/CDEX+Overlap+with+Other+DaVinci+IGs).  CDex is not intended to supersede these guides which focus on a particular use case and define how to share clinical information.  However, CDex may be used to request clinical data from a provider when:

- An alternative is needed to cover some aspects of an exchange. For example, in [Da Vinci - Coverage Requirements Discovery], if a CDS hook client refuses pre-fetch requests, the CDS service could use CDex to request the data instead.
- There is a specific exchange that is not already addressed by one of the other IGs  For example, in [Da Vinci Prior Authorization Support (PAS) FHIR IG], the Payer could request additional information for prior authorization using CDex.
- The other IG has not been or can not be implemented for the use case.  For example, the [Data Exchange For Quality Measures (DEQM) Implementation Guide] provides a standard method for automating the reporting of Quality Measures. CDex can be used when:
  1. The measure is not yet implementable using DEQM
  1. A Provider has not implemented DEQM
  1. Additional information is required for an audit of the Quality Measure.

{% include img.html img="davinci-use-cases.svg" caption="Figure 2" %}

### Workflow Overview

{% include draft_content_note.md  content="section" %}

<span class="bg-success" markdown="1">FHIR offers numerous architectural approaches for sharing data between systems. Each approach has pros and cons. The most appropriate approach depends on the circumstances under which data is exchanged.  (Review the [Approaches to Exchanging FHIR Data] in the Da Vinci HRex Implementation Guide for more guidance and background.)  This guide focuses on **three** FHIR transaction approaches for requesting information:</span><!-- new-content -->

1. **[Direct Query]:** <span class="bg-success" markdown="1">Payer or External Provider System</span><!-- new-content --> directly queries <span class="bg-success" markdown="1">Provider system</span><!-- new-content --> for specific data using the standard FHIR RESTful search.
2. **[Task Based Approach]:** <span class="bg-success" markdown="1">Payer or External Provider System</span><!-- new-content --> requests the information desired using the FHIR *Task* resource and the <span class="bg-success" markdown="1">Provider system</span><!-- new-content --> supplies the data possibly with human involvement to find/aggregate/filter/approve it.
3. **[Solicited and Unsolicited Attachments]** <span class="bg-success" markdown="1">Payer system requests attachments (additional documentation) for claims or prior authorization using the FHIR *Task* resource. Provider system uses a "push" based FHIR operation to submit attachments to Payer.</span><!-- new-content -->

<div markdown="1" class="stu-note">

<span class="bg-success" markdown="1">Payers may request data for many patients/members or anticipate large payloads from the Provider. For example, requesting a detailed set of clinical information related to their members.  For these requests, the [Bulk Data Access IG] and the [FHIR Asynchronous Request Patterns] specifications may be considered.  However, there has not been enough implementation experience with this use case to provide specific guidance in this guide.</span><!-- new-content -->
</div>


#### Direct Query and Task-Based Workflows

Figure 3 below illustrates the exchange of clinical data between a Payer (or Provider) system and a Provider system using the *Direct Query* and *Task-Based* workflows.  

{% include img.html img="workflow-overview.svg" caption="Figure 3" %}

##### Actors and Roles

- The Payer or External Provider System acts in the role of a *data consumer*.
- The Provider system acts in the role of a *data source*.\*
- A human practitioner is involved in approving/filtering the information provided.
  - A pre-existing agreement could be in place that allows data to be shared *without* human intervention.

\* For most payer use-cases, payers can not use the data if they cannot identify who is responsible for the clinical event (for example observation, diagnosis, order, etc).  Therefore, the payer's health records need to identify the provider who is making the assertion. This information is typically supplied by provider systems.  An *Electronic Health Information Exchange* (HIE) that can validate the authorship of the information would also be an acceptable data source.  However, not all HIEs do this (and not for all records) and they would *not* be acceptable data sources.
{:.bg-warning}

##### Steps
1. The data consumer initiates a request for information.
1. The data source retrieves the requested data.
1. The data may be reviewed by a human practitioner before sending it back to the data consumer.
1. The data is sent back to the data consumer.

<div class="bg-success" markdown="1">


#### Attachments Workflow

{% include draft_content_note.md  content="section" %}

Figure 4 below illustrates the exchange of clinical data between a Payer system and a Provider system using the *Solicited and Unsolicited Attachments* workflow.

{% include img.html img="workflow-attachments.svg" caption="Figure 4" %}

#### Actors and Roles

- The Payer system acts in the role of a *data consumer*.
- The Provider system acts in the role of a *data source*.
  
</div><!-- new-content -->

#### Steps

1. For *solicited* attachments, the data consumer initiates a request for attachments for a claim or prior authorization.
    - This can be a FHIR or non-FHIR-based transaction
2. The data source submits the attachments and metadata for the association to the claim or prior authorization (for example, member id and claim id).
   - In some cases, attachments are submitted **without an explicit request** as *unsolicited* attachments. 
3. Payer system accepts attachments.
 
*Out of Scope*: <span class="bg-success" markdown="1">How Payer systems associates attachments to and processes the claim or prior authorization.</span><!-- new-content -->

{% include link-list.md %}
