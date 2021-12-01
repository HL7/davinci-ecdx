### About the Da Vinci Project

Da Vinci is a private sector initiative that addresses the needs of the Value Based Care Community by leveraging the HL7 FHIR platform.  For more information about the Da Vinci Project, its use cases, members and updates, see the [Da Vinci Overview]

### What Do Payers Do with Clinical Information?

Payers want to create a clinical record of their members to improve care coordination and provide optimum medical care. For example with this information they can reduce redundant care, shift to more proactive and timely care, and make better informed and more accurate medical treatment and care planning recommendations. Payers may use this clinical record to give providers information that may assist in care coordination.

Payers also require clinical data from the provider ordering or providing services to document prior authorization, claims processing, audit submitted claims, to confirm medical necessity and appropriateness.  Clinical data is used by Payers to create risk profiles for members for value-based care contracts and population health adjustments. Quality reporting requirements and quality care scoring all require clinical data for evaluating clinical performance and outcomes.
{:.new-content}

<div markdown="1" class="new-content">

#### Example Scenarios

- Payer requests *attachments* to support a claim submission.

- Payer requests *attachments* to support medical necessity or a coverage rule.

- Payer requests *attachments* to support a claims audit.

- Payer requests additional information for prior authorization.  (See the [Da Vinci - Prior Authorization Support] for more information)

- Payer requests patient health record information to support a HEDIS/Stars quality program. <!--For example, by examining the record for care coordination information they may improve performance on the HEDIS TRC- Transitions of Care measure which looks at 1) notification of inpatient admission, 2) receipt of discharge information, 3) patient engagement after inpatient discharge and 4) medication reconciliation post-discharge.-->

- Payer requests patient health record information to support their Risk Adjustment submissions to CMS.

- Payer requests patient health record information to support their member records. (Some payers create a clinical record for each of their members to facilitate data exchange with providers. Payers use this clinical record to give providers the adequate information to execute care coordination decisions.)

- Payers requests patient health record information to meet new regulatory requirements (e.g., promoting patient access)
</div>

<div markdown="1" class="new-content">

### Provider to Provider Data Exchange

 Providers commonly need and request information from other providers about their patients.  For example, when referring a patient, the referred-to provider needs the order and supporting documentation and the referring provider needs the results from the referral.  Although this guide focuses on payor to provider to interactions, the technical exchange is no different than a provider to provider interaction.

#### Example Scenario

 - Referred-to provider solicits additional clinical information from referring provider to support performing the requested service.
</div>

### What Information is Needed?

A sampling of the type of information needed by Payers includes:

- Medical records - for example, a progress note or visit summary
- C-CDA’s of various types
- Medications
- Laboratory results
- Clinical Assessments for Diagnoses
- Vital Signs - for example Blood Pressure measurements
- Narrative - such as written or transcribed clinical notes

For Security and Privacy considerations refer to the [Security and Privacy] page.

### Where Does CDEX Fit in the Da Vinci Project?

<div markdown='1' class="new-content">
There are over a dozen use cases and corresponding Implementation guides being developed by the Da Vinci Project.  Figure 1 illustrates how the Clinical Data Exchange (CDex) use case fits in the family of Da Vinci Use Cases/Implementation Guides.  CDex not intended to supplant existing standards that already define how to share clinical information.  However, there are many areas of functional overlap between this guide and other Da Vinci guides which are summarized in this [table](https://confluence.hl7.org/display/DVP/CDEX+Overlap+with+Other+DaVinci+IGs). CDex may be used to request clinical data from a provider when:

- an alternative is needed to cover some aspect of an exchange. For example, in [Da Vinci - Coverage Requirements Discovery], if a CDS hook client refuses prefetch requests, the CDS service could use CDex to request the data instead.
- there is a specific exchange is not already addressed by one of the other IGs  For example, in [Da Vinci Prior Authorization Support (PAS) FHIR IG], the Payer could requests additional information for prior authorization using CDex.
- the other IG has not been or can not be implemented for the use case.  For example, the [Data Exchange For Quality Measures (DEQM) Implementation Guide] provides a standard method for automating the reporting of Quality Measures. CDex can be used when:
  1. The measure is not yet implementable using DEQM
  1. A Provider has not implemented DEQM
  1. Additional information is required for an audit of the Quality Measure.

{% include img.html img="davinci-use-cases.svg" caption="Figure 1" %}
</div>

<div markdown='1' class="new-content">

### Workflow Overview

FHIR offers numerous architectural approaches for sharing data between systems. The guide focuses on **three** FHIR transaction approaches for requesting information:

1. **[Direct Query] (preferred):** Payer directly queries EHR for specific data using the standard FHIR RESTful search.
1. **[Task Based Approach]:** Payer identifies the 'type' of information desired and the EHR supplies the data possibly with human involvement to find/aggregate/filter/approve it.
1. **[Unsolicited Attachments]** Based on pre-defined payor rules or business needs the EHR sends claims data directly to Payer without an explicit Payer request.

See the Specification pages for a detailed description of the technical workflow and API guidance.

#### Direct Query and Task-Based Workflow

Figure 2 below illustrates the exchange of clinical data between a Payer (or Provider) system and a Provider system using the *Direct Query*  and *Task-Based* workflows.  

{% include img.html img="workflow-overview.svg" caption="Figure 2" %}

##### Actors and Roles

- The Payer or External Provider System acts in the role of a *data consumer*.
- The Provider system acts in the role of a *data source*.\*
- A human practitioner involved in approving/filtering the information provided.
  - A pre-existing agreement could be in place that allows data to be shared *without* human intervention.

\* For most payer use-cases, payers can not use the data if they cannot identify who is responsible for the clinical event (for example an observation, diagnosis, order, etc).  Therefore, payer's health records needs to identify the provider who is making the assertion. This information is typically supplied by provider systems.  An *Electronic Health Information Exchange* (HIE) that has the ability to validate the authorship of the information would also be an acceptable data source.  However, not all HIEs do this (and not for all records) and they would *not* be acceptable data sources.
{:.bg-warning}

##### Steps
1. The data consumer initiates a request for information.
1. The data source retrieves the the requested data.
1. The data may be reviewed by a human practitioner prior to sending it back to the data consumer.
1. The data is sent back to the the data consumer.

<div markdown="1" class="stu-note">

**The following content is to be considered DRAFT, because it has not yet undergone HL7 balloting.**

#### Unsolicited Attachments Workflow

Figure 3 below illustrates the exchange of clinical data between a Payer (or Provider) system and a Provider system using the *Unsolicited Attachments* workflow.  

{% include img.html img="workflow-unsolicited.svg" caption="Figure 3" %}

#### Actors and Roles

- The Payer or External Provider System acts in the role of a *data consumer*.
- The Provider system acts in the role of a *data source*.

#### Steps

1. Based on pre-defined payor rules or business needs the data source sends data to the data consumer.
1. The subsequent payor steps are out of scope.

</div>
</div>

{% include link-list.md %}
