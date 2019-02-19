---
title: Implementation Guide HomePage
layout: default
active: home
---

{% include publish-box.html %}

<!-- { :.no_toc } -->

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

<!-- end TOC -->

### Description

The Clinical Data exchange (CDex) is part of the larger Da Vinci use case for Health Record exchange (HRex).

After careful evaluation, the eHRx project was decomposed into four independent efforts (and tied to 4 separate PSSs). The exchange of Quality Measures was included in the existing work on the Data Exchange for Quality Measures (DEQM) that is sponsored by the CQI workgroup. The exchange of Payer Data (PDex) is sponsored by Financial Management. The overall HRex Framework is planned to be sponsored by the Clinical Interoperability Council (CIC) and we looking to a combination of Structured Documents, Patient Care and Attachments to sponsor the work on e Clinical Data exchange (CDex).

The scope of the CDex project is to defined combinations of exchange methods (push, pull, subscribe, CDS Hooks, ), specific payloads (Documents, Bundles, and Individual Resources), search criteria, conformance, provenance, and other relevant requirements to support specific exchanges of clinical information between provider and other providers and/or payers. The goal is to identify, document and constrain very specific patterns of exchange so that providers and payers can reliably exchange information for patient care (including coordination of care), risk adjustment, quality reporting, identifying that requested services are necessary and appropriate (e.g. should be covered by the payer) and other uses that may be documented as part of this effort. Clinical data payloads will include C-CDA, C-CDA on FHIR, compositions, bundles, specific resources, and bulk data exchange. This list is intended to be illustrative and not prescriptive.

This project will reference, where possible the "standards" defined by the Health Record exchange (HRex) Framework Implementation Guide which in turn will utilize prior work from Argonaut, US Core and QI Core effort for FHIR DSTU2, STU3, and R4. 

The ultimate goal is to support the exchange of provider data on specific patients/members for better patient care with other providers and payers using technology that support FHIR DSTU2, STU3, and R4 releases of the FHIR standard.

The project team plans to work with existing FHIR artifacts where possible. If changes are necessary, the project team will work with the responsible Work Group to review and implement (via tracker items or new PSS) any necessary enhancements to base FHIR resources, extensions, and/or profiles.

