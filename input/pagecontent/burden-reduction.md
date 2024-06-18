<div class="bg-success" markdown="1">

### Introduction

In [Da Vinci Prior Authorization Support (PAS)], the expectation is that a final decision is generated immediately and automatically in the majority of cases.  However, a payer may request additional information (aka attachements) from the provider to support a prior authorization request.  See the [Request for Additional Information] section in the PAS Implementation Guide.

### Differences between PAS and CDex

The PAS guide leverages CDex for requesting additional information for prior authorization:

- Uses CDex's [`$submit-attachment`] operation to push the attachments to the Payer.
- Requests attachments using Codes or Questionnaires
- Uses a Task as a context parameter to launch a Smart on FHIR DTR app.

However, there are several key differences:

||PAS|CDEX|
|---|---|---|
|FHIR resource use by Payer/Intermediary to request additional information | [PAS Claim Response Bundle] | [CDex Task Attachment Request Profile]
|Task Profile | [PAS Task] | [CDex Task Attachment Request Profile]
|Author of Task | Provider | Payer|
|Primary function of Task | Launch context for DTR SMART on FHIR App. | Communicate request for additional information
{:.grid}

###  When to Use PAS or CDex for Requesting Attachments for Prior Authorization

The decision tree in Figure 1 below summarizes when to Use PAS or CDex for requesting attachments for prior authorization:

{% include img.html img="pas_cdex_decision_tree.svg" caption="Figure 1" %} 

1. Use PAS, When implementing Da Vinci Burden reduction for prior authorization and the prior authorization request is ‘pended' and additional information is requested from the provider with a X12 278 Response or [PAS Response Bundle].
1. Use CDex, When the Provider uses some other channel to request a prior authorization (e.g., fax, portal, phone).
2. Use CDex, If the Payer makes subsequent requests for additional information after using PAS for the initial request.

{% include link-list.md %}

</div><!-- new-content -->