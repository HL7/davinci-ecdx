<div class="bg-info" markdown="1">
Publishing Punch list for Jan Ballot:

- [X] Remove contained guidance and Task Profile
- [X] Add content to make clear in data includes non-FHIR resources
- [ ] Flesh out the Scope and Usage section
- [ ] Add Section on Background and include the 6 use cases
- [X] Review Trackers for specific adds to this Version
  - The vast majority of these trackers won't apply to a rewritten IG and we resolve them en bloc? A few may require edits to the background section
- [ ] Task Profile?
  - [ ] tighten down codes  - e.g. LOINC for document types
- [ ] Establish CapabilityStatements for roles
    - data source
    - data requester
- [X] Describe and show how CommunicationRequest ServiceRequest for authorization
- [X] Create Decision Tree/Section for when to use Task
  - Decision based on Authorization, Access/Privacy, Appropriateness or knowledge of Codes/free text request
- [ ] Decision on whether to Bulk Data is in scope for this version
  - e.g. `POST [base]/Patient/$everything` for all patients in Group
- [X] Review what examples are needed and whether RI can do it for Task based approach ( will repeat for direct query )
  1. [X] Patient's Active Conditions
  1. [X] Patient's a1c results
  1. [X] Pateint's Latest H&P
- [ ] QA
  - [X] fix bad dependency to hrex - check with GG
</div>

Based on balloter feedback, this IG has been completely re-written. The refactoring has been sufficiently large that it is not practical/useful to enumerate a list of changes.
{:.note-to-balloters}

{{ site.data.ig.description }}

### About This Guide

This Implementation Guide is supported by the [Da Vinci] initiative which is a private effort to accelerate the adoption of Health Level Seven International Fast Healthcare Interoperability Resources (HL7® FHIR®) as the standard to support and integrate value-based care (VBC) data exchange across communities. Like all Da Vinci Implementation Guides, it follows the [HL7 Da Vinci Guiding Principles] for exchange of patient health information.  The guide is based upon the prior work from the [US Core] and [Da Vinci Health Record Exchange (HRex)] Implementation Guides. Changes to this specification are managed by the sponsoring HL7 [Patient Care (PC)] workgroup and are incorporated as part of the standard HL7 balloting process. You can suggest changes to this specification by creating a *change request tracker* by clicking on the [Propose a Change] link at the bottom of any page.

#### How to read this Guide

This Guide is divided into several pages which are listed at the top of each page in the menu bar.

- [Home]\: The home page provides the introduction and background for the Da Vinci Clinical Data Exchange Project.
- [Framework]\: This page provides detailed guidance on the set of FHIR transactions and the FHIR artifacts used in a general framework to support exchange of clinical information between provider and payers.
- [Example Scenarios]\: The IG describes 6 example scenarios using the framework defined in this guide. Each use case is designed around a benefit resulting from the information exchange interaction.
- [FHIR Artifacts]\: These pages provide detailed descriptions and examples for the FHIR objects defined in this guide.
  - [Profiles]\: This page lists the set of Profiles that are defined in this guide.
  - [Terminology]\: This page lists the value sets and code system defined for this guide.
  - [Capability Statements]\: This set of pages describes the expected FHIR capabilities of the various Da Vinci Notification actors.
  - [Examples]\: List of links to all the examples used in this guide.
- [Downloads]\: This page provides links to downloadable artifacts.

### background

#### What do Payers do with clinical information?

Payers want to create a complete clinical record of their members to improve care coordination and provide optimum medical care. For example with this information they can reduce redundant care, shift to a more proactive and timely care, and make better informed and more accurate medical treatment and care planning recommendations.  Improve processes between the payer and provider improves member experience.  The member has fewer issues, such as shorter wait times and better planning/cost information. It allows the payer to have a more informed conversation with the member.

Payers also require clinical data from the provider ordering or providing services to document prior authorization, claims processing, audit submitted claims, to confirm medical necessity and appropriateness.  Clinical data is also used by Payers to create complete, accurate risk profiles for members for value-based care contracts and population health adjustments. Quality reporting requirements and quality care scoring all require clinical data. This data helps to reduce preventable medical errors.  Payers review member information to identify gaps in care. They work with providers and hunt down information showing the gap in care has been closed. Improving HEDIS measure scores has a positive impact on revenue for payers and reimbursements for providers.

#### What information is needed?

A sampling of the type of information needed by Payers includes:

- Medical records - for example, a progress note or visit summary
- C-CDA’s of various types
- Medications
- Laboratory results
- Clinical Assessments for Diagnoses
- Vital Signs - for example Blood Pressure measurements
- Narrative - such as clinical notes

### Example Scenarios

- Some payers create a complete clinical record for each of their members to facilitate data exchange with providers. Payers use this clinical record to give providers the adequate information to execute care coordination decisions.

- Clinical information gathered from providers to support the HEDIS/Stars quality program. For example, by examining the record for care coordination information they may improve performance on the HEDIS TRC- Transitions of Care measure which looks at 1) notification of inpatient admission, 2) receipt of discharge information, 3) patient engagement after inpatient discharge and 4) medication reconciliation post-discharge.

- Payers need information that helps them meet new regulatory requirements that promote patient access and exchange of information.

- A Durable Medical Equipment supplier submits a claim for a wheelchair. The Payer reviews the claim and assesses that the documentation submitted by the Provider is insufficient to support medical necessity or Payer coverage rules.

- Payers need to provide CMS with Risk Adjustment submissions annually.

### Workflow Overview

See the [Framework] page for a detailed description of the technical workflow and API guidance.

Figure 1 below illustrates the general workflow for the exchange of clinical data between a Payer system and a Provider system.

{% include img.html img="image2020-9-25_14-15-22.png" caption="Figure 1" %}

#### Actors and Roles:

- The Payer system (Payer) acts in the role of a *data consumer*
- The Provider systemt (Provider) acts in the role of a *data source*

#### Steps
1. The Payer system initiates a request for clinical information
1. The Provider system retrieves the the requested data.
1. The data may be review by the provider prior to sending back to the Payer system
1. The data is sent back to the Payer system

<br/>

---

 **This Implementation Guide was made possible by the thoughtful contributions of the following people and organizations:**

 - *The twenty-two founding [Da Vinci Project](http://www.hl7.org/about/davinci/index.cfm?ref=common) member organizations.*

 - *Eric Haas, Health eData Inc*
 - *Lisa Nelson (MaxMD)*
 - *Rick Geimer (Lantana Consulting Group)*
 - *Lloyd Mckenzie, Gevity*
 - *Robert Dieterle, EnableCare*
 - *Viet Nguyen, Stratametrics*
 - *Jocelyn Keegan, Point of Care Partners*

---

<br />

{% include link-list.md %}
