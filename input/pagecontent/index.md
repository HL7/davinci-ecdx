
<div class="new-content" markdown="1">
For review of changes, new and updated content will be highlighted with green text and background where possible
</div>

{% include ballot_intro.md %}

This IG provides detailed guidance that helps implementers use FHIR-based interactions to support specific exchanges of clinical data between providers and payers (or other providers).  This guide documents the **Direct Query**, **Task Based** and **Attachments** transaction approaches for requesting and sending information. Key scenarios this IG can support include:

 - <span class="bg-success" markdown="1">Requesting and</span><!-- new-content --> Sending attachments for claims and prior authorization
 - Requesting additional data to support claims audits, medical necessity, and other reasons <span class="bg-success" markdown="1">for data exchange</span><!-- new-content --> between payers and providers
 - Gathering information for Quality programs and Risk Adjustment between payers and providers
 - Exchanging clinical data between referring providers


In the context of this guide, "clinical data" means *any* information a provider holds in a patient's health record. The format of the data exchanged is not limited to FHIR resources, but includes C-CDA documents, pdfs, text files and other types of data. There may be requests for payloads of clinical records of care such as CCD Documents, clinical data sets that may be represented in a FHIR Bundle (or [C-CDA on FHIR Documents](http://hl7.org/fhir/us/ccda/)), and clinical data such as a specific FHIR resource.

By using the FHIR standard and implementing this guide, payers can be explicit about the data they are requesting as opposed to general requests which often result in providers sending more information than is necessary. The anticipated benefit of using FHIR is more efficient and effective exchange of health record information in several areas such as claims management, care coordination, risk adjustment and quality reporting.

This IG provides several *generic* examples to illustrate the different approaches for exchanging clinical data when using the Direct Query and Task Based approaches. <span class="bg-success" markdown="1">It also documents and provide examples for the specific use case of requesting and sending attachments for claims and prior authorization.</span><!-- new-content -->  We plan to create a set of [Clinical Data Exchange- Supplemental Guides] which will document and provide examples <span class="bg-success" markdown="1">for other</span><!-- new-content --> specific use cases.
{:.bg-info}

### About This Guide

This Implementation Guide is supported by the [Da Vinci] initiative which is a private effort to accelerate the adoption of Health Level Seven International Fast Healthcare Interoperability Resources (HL7® FHIR®) as the standard to support and integrate value-based care (VBC) data exchange across communities. Like all Da Vinci Implementation Guides, it follows the [HL7 Da Vinci Guiding Principles] for exchange of patient health information.  The guide is based upon the prior work from the [US Core] and [Da Vinci Health Record Exchange (HRex)] Implementation Guides. As illustrated in figure 1 below, this guide is built on top of FHIR and other implementation guides that provide more and more focused use cases by constraining profiles and extending functionality to cover gaps.

{% include img.html img="profile-pyramid.svg" caption="Figure 1: Relationship of CDex to Other FHIR Standards" %}

Changes to this specification are managed by the sponsoring HL7 [Patient Care] workgroup and are incorporated as part of the standard HL7 balloting process. You can suggest changes to this specification by creating a *change request tracker* by clicking on the [Propose a Change] link at the bottom of any page.

#### How to read this Guide

This Guide is divided into several pages which are listed at the top of each page in the menu bar.

- [Home]\: The home page provides the introduction for the Da Vinci Clinical Data Exchange Project.
- [Background]\: This page provides the background and a summary of the Da Vinci Clinical Data Exchange Project.
- [Direct Query]\: Documents how to exchange clinical data using the standard FHIR RESTful search.
- [Task Based Approach]\: Documents how to exchange clinical data using the FHIR Task resource. This approach supports asynchronous workflows where human involvement to find/aggregate/filter/approve requests may be required.
- <span class="bg-success" markdown="1">[Attachments]\: <span class="bg-warning">This content is DRAFT and is open for review.</span> Documents how to exchange attachments for claims or prior authorization.</span><!-- new-content -->
    - <span class="bg-success" markdown="1">[Solicited and Unsolicited Attachments]\: Documents the differences and similarities between solicited and unsolicited attachments workflows and the CDex transactions that can be used for each.</span><!-- new-content -->
    - <span class="bg-success" markdown="1">[Sending Attachments]\:This page documents a FHIR based approach for sending attachments for claims or prior authorization directly to a Payer.</span><!-- new-content -->
    - <span class="bg-success" markdown="1">[Requesting Attachments]\: This page documents a FHIR based approach for requesting attachments for claims or prior authorization from a Provider.</span><!-- new-content -->
    - <span class="bg-success" markdown="1">[Using CDex Attachments with DaVinci PAS]\: This Page illustrate where in the PAS workflow the Payer could use CDEX to request attachments and the Provider could use CDEX to submit attachments.</span><!-- new-content -->
- [Signatures]\: This page provides specific guidance and rules to exchange *signed* data using FHIR and non-FHIR signatures.
- [Security and Privacy]\: This page provides general expectations to ensure security, privacy, and safety of Da Vinci CDex exchanges.
- [FHIR Artifacts]\: This page list the FHIR Profiles, Operations, Terminology, CapabilityStatements, and example resources used within this guide.
- [Downloads]\: This page provides links to downloadable artifacts that can be used by developers to help them implement this guide.

---

*This Implementation Guide was made possible by the contributions of the [Da Vinci] Project member organizations and project management staff, the [Patient Care] Work Group and the [Payer/Provider Information Exchange] Work Group.*

*Authors:*

- *Eric Haas, Health eData Inc*
- *Lloyd Mckenzie, Gevity Consulting*
- *Robert Dieterle, EnableCare*

---

<br />

{% include link-list.md %}
