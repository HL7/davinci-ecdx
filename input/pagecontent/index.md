
<!-- {% raw %} {%include new-content-note.md %} {% endraw %} -->

### Introduction

This IG provides detailed guidance that helps implementers use FHIR-based interactions to support specific clinical data exchanges between providers and payers (or other providers). This guide documents the **Direct Query**, **Task Based**, and **Attachments** transaction approaches for requesting and sending information. Key scenarios this IG can support include:

 - Requesting and Sending attachments for claims and prior authorization
 - Requesting documentation to support payer operations such as claims audits
 - Exchanging clinical data between referring providers

In the context of this guide, "clinical data" means *any* information a provider holds in a patient's health record. The data exchange format is not limited to FHIR resources but includes C-CDA documents, PDFs, text files, and other formats. Implementers can request and receive clinical records of care such as CCD Documents or [C-CDA on FHIR Documents], clinical data sets represented by a FHIR [Bundle], FHIR [QuestionnaireResponse], and other types of FHIR resources. 

By using the FHIR standard and implementing this guide, payers can be explicit about the data they are requesting instead of general requests, which avoids sending more information than necessary. As a result, the anticipated benefit of using FHIR is a more efficient and effective exchange of health record information in several areas, such as claims management, care coordination, risk adjustment, and quality reporting.  


This IG provides several *generic* examples to illustrate the Direct Query and Task-Based approaches to exchanging clinical data. It also documents and provides examples for Requesting and Sending Attachments for claims and prior authorization. We also plan to create *Clinical Data Exchange - Supplemental Guides*, which will document and provide examples for other specific use cases.
{:.bg-info}


### About This Guide

The [Da Vinci] initiative supports this implementation guide. Da Vinci is a private effort to accelerate the adoption of Health Level Seven International Fast Healthcare Interoperability Resources (HL7® FHIR®) as the standard to support and integrate value-based care (VBC) data exchange across communities. This guide and implementers of it **SHALL** adhere to the [HL7 Da Vinci Guiding Principles] for exchanging patient health information. 


As illustrated in Figure 1 below, this version of CDex is based on FHIR R4, and much of its content is dependent upon the [[Da Vinci Health Record Exchange (HRex)], [US Core 3.1.1] (FHIR R4), [US Core 6.1.0] (FHIR R4), and , [US Core 7.0.0] (FHIR R4)implementation guides.
 For general [Background on FHIR], [Conformance Expectations], and [Security and Privacy] considerations, refer to the corresponding sections in HRex. US Core 3.1 meets regulatory requirements mandating support for [ONC United States Core Data for Interoperability V1 (USCDI V1)], US Core 6.1.0 meets regulatory requirements mandating support for [ONC United States Core Data for Interoperability V3 (USCDI V3)]], and US Core 7.0.0 meets regulatory requirements mandating support for [ONC United States Core Data for Interoperability V4 (USCDI V4)]].
 For Direct Query and Task-Based queries, US Core and HRex define the underlying content, and CDex provides additional context, definitions, and constraints. CDex provides more focused use cases by constraining profiles and extending functionality to cover gaps. For example, CDex defines all the content for Attachments.


{% include img.html img="profile-pyramid.svg" caption= "Figure 1: Relationship of CDex to Other FHIR Standards" %}

 The sponsoring HL7 [Payer/Provider Information Exchange] workgroup manages changes to this specification. Changes are incorporated as part of the standard HL7 balloting process  and version updates. You can suggest changes to this specification by clicking the [Propose a Change] link at the bottom of any page to create a *change request tracker*.

### How To Read This Guide

This guide uses the following terms to document the CDex transactions:

Data Consumer
: The term "Data Consumer" means both payer and provider systems when they request data.

Data Source
: The term "Data Source", refers to an EHR, HIM, Practice Management System, Population Health, Registration, or other HIT system that stores the data and responds to data requests.

Payer
: "Payer" refers to the payer system (or an intermediary on behalf of a payer) and is used when they are requesting data.

Provider
: "Provider" refers to the provider system and can be the Data Source or the Data Consumer.

Attachments
: This guide uses the terms "attachments" and "additional information" to mean additional information needed for claims and prior authorization.  In the context of requesting and sending attachments using attachment codes, attachments are limited to the documents defined by the [LOINC Document Ontology] and [X12] attachment codes.  When requesting and sending attachments using [Questionnaire], attachments mean *any* additional information.

This guide is divided into several pages listed at the top of each page in the menu bar.

- [IG Home]\: The home page introduces the Da Vinci Clinical Data Exchange Project and Implementation Guide.
- [Background]\: This page provides background for the Da Vinci Clinical Data Exchange Project and summarizes its scope.
- [Direct Query]\: Documents how to exchange clinical data using the standard FHIR RESTful search.
- [Task Based Approach]\: Documents exchanging clinical data using the FHIR Task resource. This approach supports asynchronous workflows and may require human involvement.
- [Attachments]\: Documents exchanging attachments for claims or prior authorization using FHIR.
    - [Solicited and Unsolicited Attachments]\: Documents the differences and similarities between solicited and unsolicited attachments workflows and the CDex transactions for each.
    - [Sending Attachments]\: This page documents a FHIR-based approach for sending attachments for claims or prior authorization directly to a Payer.
    - [Requesting Attachments Using Attachment Codes]\: This page documents a FHIR-based approach for requesting attachments using LOINC attachment codes.
    - [Requesting Attachments Using Questionnaires]\: This page documents the CDex Attachments transaction for requesting additional data for claims or prior authorization from a Provider using 
FHIR Questionnaire and QuestionnaireResponse.
    - [Using CDex Attachments with DaVinci PAS]\: This page summarizes the similarities and differences between CDEX and the [Da Vinci Prior Authorization Support (PAS)] guide.
    - [Conforming to CDex Attachments]\: Summary of interactions for each role and the conformance resource and terminology that makes them unique. 
- [Signatures]\: This page provides specific guidance and rules to exchange *signed* data using FHIR and non-FHIR signatures.
- [Security and Privacy]\: This page provides general expectations to ensure the security, privacy, and safety of Da Vinci CDex exchanges.
- [FHIR Artifacts]\: This page lists all the FHIR resources (for example, FHIR Profiles, Operations, Valuesets)  that are defined and used within this guide.
- Support\: This page includes links to the FHIR core specification and the US Core spec, as well as a [Downloads] page of IG tools and artifacts for Da Vinci implementers.<!-- new-content -->
- [Change Log]\: This page documents the changes across the versions of CDex.

---

### Credits

*This Implementation Guide was made possible by the contributions of the [Da Vinci] Project member organizations and project management staff, the [Payer/Provider Information Exchange] Work Group, and the [Patient Care] Work Group.*

*Author:*

- *Eric Haas, Health eData Inc*

*CDex Core Team:*

- *Lloyd Mckenzie, Accenture/Dogwood Health Consulting*
- *Robert Dieterle, EnableCare*
- *Christol Green, Elevance Health*
- *Durwin Day, - Health Care Service Corporation*

*Project Management and Coordination:*
- *Viet Nguyen, Stratametrics, LLC*
- *Vanessa Candelora, Point of Care Partners*
- *Crystal Kallem, Point of Care Partners*
- *Yan Heras, Optimum eHealth LLC*

*Reference Implementation and TestScripts:*
- *Karell Ruiz, HealthLX*
- *Joel Walker, HealthLX*
- *David Riddle, HealthLX*
- *Carie Hammond, Aegis*

*Special thanks go to the numerous individuals who have participated in conference calls, ballots, and reviews of this IG:*

- *Celine Lefebvre, AMA*
- *Andrea Preisler, AHA*
- *Isaac Vetter, Epic*
- *Brett Stringham, Optum*
- *Chris Johnson, Blue Cross and Blue Shield of Alabama*
- *Diederik Muylwyk, Smile CDR*
- *Nick Radov, Optum*
- *Linda Michaelson, Optum*
- *Peter Gunter, VA*
- *Scott Fradkin, Flexion*
- *Andrew Barbieri, Epic*
- *Hans Buitendijk, Oracle*
- *Kyle Johnsen, Epic*
- *Liora Alschuler, Lantana*
- *Mitra Rocca, FDA*
- *Rob McClure, MD Partners, Inc.*
- *Ron G. Parker, Canada Health Infoway*
- *Spencer Utley, Epic*
- *Scott Rossignol, eHealth Exchange*

---

<br />

{% include link-list.md %}
