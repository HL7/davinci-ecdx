{% include draft_intro.md %}

### Introduction

This IG provides detailed guidance that helps implementers use FHIR-based interactions to support specific clinical data exchanges between providers and payers (or other providers). This guide documents the **Direct Query**, **Task Based**, and **Attachments** transaction approaches for requesting and sending information. Key scenarios this IG can support include:

 - Requesting and Sending attachments for claims and prior authorization
 - Requesting documentation to support payer operations such as claims audits
 - Gathering information for Quality programs and Risk Adjustment between payers and providers
 - Exchanging clinical data between referring providers


In the context of this guide, "clinical data" means *any* information a provider holds in a patient's health record. The format of the data exchanged is not limited to FHIR resources but includes C-CDA documents, PDFs, text files, and other types of data.  In addition to requesting FHIR resources, there can Implementers can request clinical records of care such as CCD Documents or [C-CDA on FHIR Documents], or clinical data sets represented by a FHIR [Bundle], a FHIR QuestionnaireResponse, or other types of FHIR resources. 

By using the FHIR standard and implementing this guide, payers can be explicit about the data they are requesting instead of general requests, which avoids sending more information than necessary. As a result, the anticipated benefit of using FHIR is a more efficient and effective exchange of health record information in several areas, such as claims management, care coordination, risk adjustment, and quality reporting.  

This IG provides several *generic* examples to illustrate the different approaches for exchanging clinical data using Direct Query and Task-Based transactions. It also documents and provides examples for Requesting and Sending Attachments for claims and prior authorization. In addition, we plan to create a set of [Clinical Data Exchange- Supplemental Guides] which will document and provide examples for other specific use cases.
{:.bg-info}

### About This Guide

The [Da Vinci] initiative supports this implementation guide. Da Vinci is a private effort to accelerate the adoption of Health Level Seven International Fast Healthcare Interoperability Resources (HL7® FHIR®) as the standard to support and integrate value-based care (VBC) data exchange across communities. This guide adheres to the [HL7 Da Vinci Guiding Principles] for the exchange of patient health information. Much of the content in this guide is based upon the prior work from the [US Core] and [Da Vinci Health Record Exchange (HRex)] Implementation Guides. For general [Background on FHIR] and [Conformance Expectations], refer to the corresponding sections in the [Da Vinci Health Record Exchange (HRex)] Implementation Guide. For Security and Privacy considerations, refer to the [Security and Privacy] page. As illustrated in figure 1 below, this guide is built on top of FHIR and other implementation guides that provide more and more focused use cases by constraining profiles and extending functionality to cover gaps. For Direct Query and Task-Based queries, US Core and HRex define the underlying content, and CDex provides additional context, definitions, and constraints. In contrast, CDex defines all the content for Attachments.

{% include img.html img="profile-pyramid.svg" caption= "Figure 1: Relationship of CDex to Other FHIR Standards" %}

 The sponsoring HL7 [Patient Care] workgroup manages changes to this specification. Changes are incorporated as part of the standard HL7 balloting process. You can suggest changes to this specification by creating a *change request tracker* by clicking on the [Propose a Change] link at the bottom of any page.

### How to read this Guide

This guide uses the following terms to document the CDex transactions:

Data Consumer
: The term "Data Consumer" is used to mean both payer and provider systems when they are requesting data.

Data Source
: The term "Data Source", "Data Source(HIT)", or "HIT system" refers to an EHR, HIM, Practice Management System, Population Health, Registration, or other systems that stores the data and responds to data requests.

Payer
: "Data Consumer(Payer)" or "Payer" refers to the payer system (or an intermediary on behalf of a payer) and is used when they are requesting data. 

Provider
: "Provider" refers to the provider system and can be either the Data Source or the Data Consumer.

Attachments
: This guide uses the terms "attachments", "additional information", and "attachments and additional information" to mean additional information needed for claims and prior authorization. Attachments are limited to the documents defined by the [LOINC Document Ontology] in the context of requesting and sending attachments using attachment codes. When requesting and sending attachments using [Questionnaire],  attachments mean any additional information. 

This guide is divided into several pages listed at the top of each page in the menu bar.

- [Home]\: The home page introduces the Da Vinci Clinical Data Exchange Project and Implementation Guide.
- [Background]\: This page provides the background and a summary of the Da Vinci Clinical Data Exchange Project.
- [Direct Query]\: Documents how to exchange clinical data using the standard FHIR RESTful search.
- [Task Based Approach]\: Documents exchanging clinical data using the FHIR Task resource. This approach supports asynchronous workflows and may require human involvement.
- [Attachments]\: Documents exchanging attachments for claims or prior authorization using FHIR.
    - [Solicited and Unsolicited Attachments]\: Documents the differences and similarities between solicited and unsolicited attachments workflows and the CDex transactions for each.
    - [Sending Attachments]\: This page documents a FHIR-based approach for sending attachments for claims or prior authorization directly to a Payer.
    - [Requesting Attachments Using Attachment Codes]\: This page documents a FHIR-based approach for requesting attachments that is compatible with the X12n 277 Request for Additional Information (RFAI) and 278 response transactions.
    - [Requesting Attachments Using Questionnaires]\: <span class= "bg-warning">This page is DRAFT</span> This page documents an *optional* CDex Attachments transaction for requesting additional data for claims or prior authorization from a Provider using Questionnaire, CQL, and QuestionnaireResponse as supported by [Da Vinci DTR]. 
    - [Using CDex Attachments with DaVinci PAS]\: This page illustrates where the Provider could use CDEX to submit attachments in the PAS workflow.
    - [Conforming to CDex Attachments]\: Summary of interactions for each role and the conformance resource and terminology that makes them unique. 
- [Signatures]\: This page provides specific guidance and rules to exchange *signed* data using FHIR and non-FHIR signatures.
- [Security and Privacy]\: This page provides general expectations to ensure the security, privacy, and safety of Da Vinci CDex exchanges.
- [FHIR Artifacts]\: This page lists the FHIR Profiles, Operations, Terminology, CapabilityStatements, and example resources used within this guide.
- [Downloads]\: This page provides links to downloadable artifacts that developers can use to help them implement this guide.
- [Change Log]\: This page documents the changes across the versions of CDex.

---

*This Implementation Guide was made possible by the contributions of the [Da Vinci] Project member organizations and project management staff, the [Patient Care] Work Group, and the [Payer/Provider Information Exchange] Work Group.*

*Authors:*

- *Eric Haas, Health eData Inc*
- *Lloyd Mckenzie, Gevity Consulting*
- *Robert Dieterle, EnableCare*

---

<br />

{% include link-list.md %}
