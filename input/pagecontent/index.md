<!--{raw}
<div class="bg-info" markdown="1">
Publishing Punch list:

- [X] Finish [Resolving Trackers](https://jira.hl7.org/secure/Dashboard.jspa?selectPageId=11801)
- [X] Finish Applying Resolved Trackers
- [ ] technical QA
- [ ] ProofRead
  - [ ] update to US Core 3.1.1
  - [ ] update to published version of HREX
  - [ ] evaluate pathway to US Core 4.0.0 and US Core 5.0.0
  - [ ] Update PL
  - [ ] Remove all new content highlighting
  - [X] home
  - [X] downloads
  - [X] artifacts
  - [X] Attachments
  - [X] $submit-attachments
  - [X] security and privacy
  - [ ] background
  - [ ] Exchanging Clinical Data
  - [ ] Direct Query
  - [ ] Task Based Approach
  - [ ] Attachments
  - [ ] signatures
  - [ ] Profiles
  - [ ] Terminology
  - [ ] CapabilityStatements
  - [ ] Examples
- [X] Reconciliation Spreadsheet
- [ ] publication request
- [ ] publication checklist

Where possible, new and updated content will be highlighted with green text and background


{{ site.data.pl.list[0].desc }}

</div>
{endraw}-->

This IG provides detailed guidance that helps implementers use FHIR-based interactions to support specific exchanges of clinical data between providers and payers (or other providers).  This guide documents the **Direct Query**, **Task Based** and **Attachments** transaction approaches for requesting and sending information. Key scenarios this IG can support include:

 - Requesting additional data to support claim submission, medical necessity and other reasons for attachments between payers and providers
 - Gathering information for Quality programs and Risk Adjustment between payers and providers
 - Exchanging clinical data between referring providers
 - Sending attachments for claims and prior authorization

In the context of this guide, "clinical data" means *any* information a provider holds in a patient's health record. The format of the data exchanged is not limited to FHIR resources, but includes C-CDA documents, pdfs, text files and other types of data. There may be requests for payloads of clinical records of care such as CCD Documents, clinical data sets that may be represented in a FHIR Bundle (or [C-CDA on FHIR Documents](http://hl7.org/fhir/us/ccda/)), and clinical data such as a specific FHIR resource.

By using the FHIR standard and implementing this guide, payers can be explicit about the data they are requesting as opposed to general requests which often result in providers sending more information than is necessary. The anticipated benefit of using FHIR is more efficient and effective exchange of health record information in several areas such as claims management, care coordination, risk adjustment and quality reporting.

This IG provides several *general* examples to illustrate the different approaches for exchanging clinical data, but it does not to document specific use cases.  We plan to create a set of [Clinical Data Exchange- Supplemental Guides] which will document and provide examples for specific use cases.
{:.bg-info}

### About This Guide

This Implementation Guide is supported by the [Da Vinci] initiative which is a private effort to accelerate the adoption of Health Level Seven International Fast Healthcare Interoperability Resources (HL7® FHIR®) as the standard to support and integrate value-based care (VBC) data exchange across communities. Like all Da Vinci Implementation Guides, it follows the [HL7 Da Vinci Guiding Principles] for exchange of patient health information.  The guide is based upon the prior work from the [US Core] and [Da Vinci Health Record Exchange (HRex)] Implementation Guides. As illustrated in figure 1 below, this guide is built on top of FHIR and other implementation guides that provide more and more focused use cases by constraining profiles and extending functionality to cover gaps.

{% include img.html img="profile-pyramid.svg" caption="Figure 1: Relationship of CDex to Other FHIR Standards" %}

Changes to this specification are managed by the sponsoring HL7 [Patient Care (PC)] workgroup and are incorporated as part of the standard HL7 balloting process. You can suggest changes to this specification by creating a *change request tracker* by clicking on the [Propose a Change] link at the bottom of any page.

#### How to read this Guide

This Guide is divided into several pages which are listed at the top of each page in the menu bar.

- [Home]\: The home page provides the introduction for the Da Vinci Clinical Data Exchange Project.
- [Background]\: This page provides the background and a summary of the Da Vinci Clinical Data Exchange Project.
- Specification\: The Specification pages provides specific guidance on transaction pattern for exchanging clinical data between Providers and Payers:
  - [Exchanging Clinical Data]\: Exchanging Clinical data overview page.
  - [Direct Query]\: Documents how to exchange clinical data using the standard FHIR RESTful search.
  - [Task Based Approach]\: Documents how to exchange clinical data using the FHIR Task resource. This approach supports asynchronous workflows where human involvement to find/aggregate/filter/approve requests may be required.
  - [Attachments]\: Documents how to exchange attachments for claims or prior authorization between provider and payers using a "PUSH-based" FHIR Operation. *This is DRAFT content because it has not yet undergone HL7 balloting.*
- [Signatures]\: This page provides specific guidance and rules to exchange *signed* data using FHIR and non-FHIR signatures.
- [Security and Privacy]\: This page provides general expectations to ensure security, privacy, and safety of Da Vinci CDex exchanges.
- [FHIR Artifacts]\: This page list the FHIR Profiles, Operations, Terminology, CapabilityStatements, and example resources used within this guide.
- [Downloads]\: This page provides links to downloadable artifacts that can be used by developers to help them implement this guide.

---

**This Implementation Guide was made possible by the thoughtful contributions of the following people and organizations:**

- *The twenty-two founding [Da Vinci Project](http://www.hl7.org/about/davinci/index.cfm?ref=common) member organizations.*

- *Eric Haas, Health eData Inc*
- *Lloyd Mckenzie, Gevity*
- *Robert Dieterle, EnableCare*
- *Viet Nguyen, Stratametrics*
- *Vanessa Candeloria, Point of Care Partners*
- *Jocelyn Keegan, Point of Care Partners*
- *Lisa Nelson MaxMD*
- *Rick Geimer Lantana Consulting Group*

---

<br />

{% include link-list.md %}
