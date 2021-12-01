
<div class="bg-info" markdown="1">
Publishing Punch list:

- [ ] Finish [Resolving Trackers](https://jira.hl7.org/secure/Dashboard.jspa?selectPageId=11801)
- [ ] Finish Applying Resolved Trackers
- [ ] QA
- [ ] Reconciliation Spreadsheet
- [ ] publication checklist

Where possible, new and updated content will be highlighted with green text and background
{:.new-content}

{{ site.data.pl.list[0].desc }}

</div>

{{ site.data.ig.description }}

This IG provides several *general* examples to illustrate the different approaches for exchanging clinical data, but it does not to document specific use cases.  We plan to create a set of [Clinical Data Exchange- Supplemental Guides] which will document and provide examples for specific use cases.
{:.bg-info}

### About This Guide

This Implementation Guide is supported by the [Da Vinci] initiative which is a private effort to accelerate the adoption of Health Level Seven International Fast Healthcare Interoperability Resources (HL7® FHIR®) as the standard to support and integrate value-based care (VBC) data exchange across communities. Like all Da Vinci Implementation Guides, it follows the [HL7 Da Vinci Guiding Principles] for exchange of patient health information.  The guide is based upon the prior work from the [US Core] and [Da Vinci Health Record Exchange (HRex)] Implementation Guides. Changes to this specification are managed by the sponsoring HL7 [Patient Care (PC)] workgroup and are incorporated as part of the standard HL7 balloting process. You can suggest changes to this specification by creating a *change request tracker* by clicking on the [Propose a Change] link at the bottom of any page.

#### How to read this Guide

This Guide is divided into several pages which are listed at the top of each page in the menu bar.

- [Home]\: The home page provides the introduction for the Da Vinci Clinical Data Exchange Project.
- [Background]\: This page provides the background and a summary of the Da Vinci Clinical Data Exchange Project.
- Specification\: The Specification pages provides specific guidance on exchanging clinical data between Payers and Providers:
  - {:.bg-success}[Exchanging Clinical Data]\: Exchanging Clinical data overview page.
  - {:.bg-success}[Direct Query]\: Payer directly queries EHR for specific data using the standard FHIR RESTful search
  - {:.bg-success}[Task Based Approach]\: Payer identifies the ‘type’ of information desired and the EHR supplies the data possibly with human involvement to find/aggregate/filter/approve it.
  - {:.bg-success}[Unsolicited Push]\: ...TODO...
- {:.bg-success}[Signatures]\: This page provides specific guidance and rules to exchange *signed* data using FHIR and non fhir signatures.
- {:.bg-success}[Security and Privacy]\: This page provides general expectations to ensure security, privacy, and safety of Da Vinci CDex exchanges.
- {:.bg-success}[FHIR Artifacts]\: These pages provide detailed descriptions and examples for Task based data exchange approach.
- [Downloads]\: This page provides links to downloadable artifacts.

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
