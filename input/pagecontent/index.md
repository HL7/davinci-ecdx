<!-- {% raw %}
<div class="bg-info" markdown="1">
Publishing Punch list for Jan Ballot:

- [X] Remove contained guidance and Task Profile
- [X] Add content to make clear in data includes non-FHIR resources
- [X] Flesh out the Scope and Usage section
  - [X] how does this IG fit into the family of Da Vinci IGs
  - [X] List potential scenarios where it could be Used
  - [X] explain the value it adds over HRex and US Core
- [X] Add Section on Background and include the 6 use cases
- [X] Review Trackers for specific adds to this Version
  - The vast majority of these trackers won't apply to a rewritten IG and we resolve them en bloc? A few may require edits to the background section
- [X] Task Profile?
  - [X] tighten down codes  - e.g. LOINC for document types
- [X] Establish CapabilityStatements for roles
    - [X] data source client
    - [X] data source server
    - [X] data requester client
    - [X] data source server
- [X] Describe and show how CommunicationRequest ServiceRequest for authorization
- [X] Create Decision Tree/Section for when to use Task
  - Decision based on Authorization, Access/Privacy, Appropriateness or knowledge of Codes/free text request
- [X] Decision on whether to Bulk Data is in scope for this version
  - e.g. `POST [base]/Patient/$everything` for all patients in Group
- [X] Review what examples are needed and whether RI can do it for Task based approach ( will repeat for direct query )
  1. [X] Patient's Active Conditions
  1. [X] Patient's a1c results
  1. [X] Pateint's Latest H&P
- [X] Add Example Scenarios
- [ ] QA
  - [X] CapabilityStatement	error	URL value 'http://hl7.org/fhir/us/davinci-hrex/ImplementationGuide-hl7.fhir.us.davinci-hrex|0.2.0' does not resolve)- check with GG [Zulip](https://chat.fhir.org/#narrow/stream/179252-IG-creation/topic/hrex.20references.20not.20resolving)
  - [X] The link 'history.html' for "History" cannot be resolved - See [Zulip](https://chat.fhir.org/#narrow/stream/179252-IG-creation/topic/searchform.20issue.20--.20how.20to.20resolve.3F)
  - [X] Warnings: [fix Jira issues](https://confluence.hl7.org/display/HL7/Configuring+Specification+Feedback) PR Cdex #93
  - [X] Warnings: add Name and Descriptions to instances
  - [ ] QA editing ( typos/ grammar )
  - [X] compare for consistency with [Da Vinci - Payer Coverage Decision Exchange](http://build.fhir.org/ig/HL7/davinci-pcde/usecases.html)
  - [X] update JIRA
  - [ ] update 'input/ignoreWarnings.txt'
- [X] NIB: http://www.hl7.org/special/committees/tsc/ballotmanagement/ConfirmNIB.cfm  (vote 11/1/2020  PC WG Call  provisionally to Block Vote, see below )
- [X] trackers
   - [X] applied all dispositioned trackers - (The refactoring has been sufficiently large that it is not practical/useful to apply all the trackers as dispositioned - noted where the changes essentially satisfied the tracker.)
   - [X] Block Vote 5 - preapplied (scheduled for 11/8/2020  PC WG Call)
   - [X] Reopen FHIR-23441 - (scheduled for 11/8/2020  PC WG Call)
   - [X] Reconciliation Spreadsheet

</div>

{% endraw %} -->

Based on balloter feedback, this IG has been completely re-written. The refactoring has been sufficiently large that it is not practical/useful to enumerate a list of changes.
{:.note-to-balloters}

{{ site.data.ig.description }}

### About This Guide

This Implementation Guide is supported by the [Da Vinci] initiative which is a private effort to accelerate the adoption of Health Level Seven International Fast Healthcare Interoperability Resources (HL7® FHIR®) as the standard to support and integrate value-based care (VBC) data exchange across communities. Like all Da Vinci Implementation Guides, it follows the [HL7 Da Vinci Guiding Principles] for exchange of patient health information.  The guide is based upon the prior work from the [US Core] and [Da Vinci Health Record Exchange (HRex)] Implementation Guides. Changes to this specification are managed by the sponsoring HL7 [Patient Care (PC)] workgroup and are incorporated as part of the standard HL7 balloting process. You can suggest changes to this specification by creating a *change request tracker* by clicking on the [Propose a Change] link at the bottom of any page.

#### How to read this Guide

This Guide is divided into several pages which are listed at the top of each page in the menu bar.

- [Home]\: The home page provides the introduction for the Da Vinci Clinical Data Exchange Project.
- [Background]\: This page provides the background and a summary of the Da Vinci Clinical Data Exchange Project.
- [Specification]\: This page provides detailed guidance on the set of FHIR transactions and the FHIR artifacts used in a general framework to support exchange of clinical information between provider and payers.
- [FHIR Artifacts]\: These pages provide detailed descriptions and examples for

---

**This Implementation Guide was made possible by the thoughtful contributions of the following people and organizations:**

- *The twenty-two founding [Da Vinci Project](http://www.hl7.org/about/davinci/index.cfm?ref=common) member organizations.*

- *Eric Haas, Health eData Inc*
- *Lloyd Mckenzie, Gevity*
- *Robert Dieterle, EnableCare*
- *Viet Nguyen, Stratametrics*
- *Jocelyn Keegan, Point of Care Partners*
- *Lisa Nelson MaxMD*
- *Rick Geimer Lantana Consulting Group*

---

<br />

{% include link-list.md %}
