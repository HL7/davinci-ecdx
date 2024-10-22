
Currently, claims and prior authorization requests can come through [X12 transactions] or portal submissions. Payers may need additional information or "attachments" from a Provider to determine if the service being billed (for claims) or requested (for prior authorizations) is supported by medical or policy benefits. In this guide, the term "attachments" includes a subset of additional information represented in document form defined by the [LOINC Document Ontology] and [X12]. When requesting and sending attachments using [Questionnaire], attachments mean *any* additional information. Attachments for claims or prior authorization can be divided into *solicited* and *unsolicited* workflows. The sections below document the differences and similarities between these workflows and define the CDex transactions that implementers can use for solicited and unsolicited prior authorization and claims attachments. See the [Conforming to CDex Attachments] for guidance on how systems define their support for each.

The Da Vinci Burden Reduction Implementation Guides (IGs), [Da Vinci Coverage Requirements Discovery (CRD)], [Da Vinci Documentation Templates and Rules (DTR)], and [Da Vinci Prior Authorization Support (PAS)], support an integrated workflow to enable automated submission of required documentation and prior authorization from EHR and payer systems respectively. Although the PAS guide leverages CDex, implementers should follow the Burden Reduction IGs to request additional information for prior authorization. See [Using CDex Attachments with DaVinci PAS] page for more details.
{:.bg-info}

### *Unsolicited* Attachments

For *unsolicited* attachments, the Payer does not explicitly request them - instead, the Provider will submit the attachments to support a claim or prior authorization based on the Payer's predefined rules. The Provider may submit the attachments *before, at the same time as, or after* the claim or prior authorization. After submission, the Payer associates the attachment with the claim or prior authorization.

#### Example Scenarios

1. A set of predefined rules, made by the Payer or state mandates, necessitates that the Provider submit additional information without a specific request.
2. A Provider believes the Payer will need additional information to process a claim.
3. A Provider is under review and must provide additional documentation for all claims.

The flow diagram below shows this transaction:

{% include img.html img="unsolicited-flow.svg" caption="Figure 10: Unsolicited Attachments Flow Diagram" %}

See the [Sending Attachments] page for information on how Providers can use CDex to support unsolicited attachment transactions.

### *Solicited* Attachments

For a *solicited* attachment, the Provider will submit attachments to support a claim or prior authorization *in response to* a Payer's request for additional documentation. The Payer associates the submitted attachments with the claim or prior authorization. The flow diagrams below show this transaction:

{% include img.html img="solicited-claim-flow.svg" caption="Figure 11: Solicited Attachments for a Claim" %}

---

{% include img.html img="solicited-prior-auth-flow.svg" caption="Figure 12: Solicited Attachments for a Prior Authorization" %}

In addition to using CDEX to request attachments, a Payer can request them via a non-CDex-FHIR-based request such as an X12 transaction, fax, portal, or other platform. See the [Requesting Attachments Using Attachment Codes], [Requesting Attachments Using Questionnaires], and [Sending Attachments] pages for how Payers and Providers can use CDex to support  *solicited* attachment transactions.

{% include link-list.md %}