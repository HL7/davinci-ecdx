

### Introduction

The Da Vinci Burden Reduction Implementation Guides (IGs), [Da Vinci Coverage Requirements Discovery (CRD)], [Da Vinci Documentation Templates and Rules (DTR)], and [Da Vinci Prior Authorization Support (PAS)], support an integrated workflow to enable automated submission of required documentation and prior authorization from EHR and payer systems respectively.  In [Da Vinci Prior Authorization Support (PAS)], a final decision is expected to be generated immediately and automatically in most cases. However, a payer may request additional information (aka attachments) from the Provider to support a prior authorization request. See the [Request for Additional Information] section in the PAS Implementation Guide.

### Differences between PAS and CDex

The PAS guide leverages CDex to request additional information for prior authorization:

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

###  When to Use PAS or CDex for Requesting Attachments for Prior Authorization

The decision tree in Figure 1 below summarizes when to Use PAS or CDex for requesting attachments for prior authorization:

{% include img.html img="pas_cdex_decision_tree.svg" caption="Figure 1" %} 

1. Use PAS when implementing Da Vinci Burden reduction for prior authorization, the initial authorization request is 'pended', and additional information is requested from the Provider with an X12 278 Response or [PAS Response Bundle].
1. Use CDex when the Provider uses another channel to request a prior authorization (e.g., fax, portal, phone).
2. Use CDex if the Payer makes subsequent requests for additional information after using PAS for the initial request.

{% include link-list.md %}

