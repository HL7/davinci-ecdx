

### Introduction

The Da Vinci Burden Reduction Implementation Guides (IGs), [Da Vinci Coverage Requirements Discovery (CRD)], [Da Vinci Documentation Templates and Rules (DTR)], and [Da Vinci Prior Authorization Support (PAS)], support an integrated workflow to enable automated submission of required documentation and prior authorization from EHR and payer systems respectively.  In [Da Vinci Prior Authorization Support (PAS)], a final decision is typically generated immediately and automatically. However, a payer may request additional information (aka attachments) from the Provider to support a prior authorization request. See the [Request for Additional Information] section in the PAS Implementation Guide. <span class="bg-success" markdown="1">Use PAS when requesting more data via X12 278 Response or PAS Claim Response Bundle. Use CDex only when the Provider requests prior authorization through non-standard channels (e.g., fax, portal, or phone).</span><!-- new-content -->

### Differences between PAS and CDex

<span class="bg-success" markdown="1">This section highlights the similarities and differences between PAS and CDex in how they use the [`$submit-attachment`] operation to exchange attachments for prior authorization.</span><!-- new-content -->

- PAS and CDex use the [`$submit-attachment`] operation to push the attachments to the Payer.
- PAS and CDex request attachments using Codes or Questionnaires.
- PAS and CDex Use Task as a context parameter to launch a Smart on FHIR DTR app.

However, there are several key differences:

||PAS|CDEX|
|---|---|---|
|FHIR resource use by Payer/Intermediary to request additional information | [PAS Claim Response Bundle] | [CDex Task Attachment Request Profile]
|Primary function of Task | Launch context for DTR SMART on FHIR App. | Communicate request for additional information
|Author of Task | Provider | Payer|
|Task Profile | [PAS Task] | [CDex Task Attachment Request Profile]
{:.grid}

{% include link-list.md %}

