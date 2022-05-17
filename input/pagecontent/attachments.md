<!-- ---
tags: CDEX
title: Attachments
---

# Attachments -->

This page documents a FHIR based approach for exchanging *attachments* (in other words, additional information) for claims or prior authorization directly to a Payer.

### Attachments (additional information) for Claims or Prior Authorization

Today claims typically come through [X12 transactions] or portal submissions. Payers may need additional information - referred to as "attachments" - from a provider to determine if the service being billed (claim) or requested (prior authorization) is consistent with medical policies. In contrast to the Direct Query and Task Based approach, the CDex Attachments transaction is not a response to a CDex FHIR-based request for clinical/administrative data.  However, the additional information to support these claims or prior authorizations *may* be requested via a non-CDex FHIR based request such as an X12 transactions, fax, portal, or other capabilities.

Attachments for Claims or Prior Authorization introduces the concepts of *solicited* and *unsolicited* workflows:

#### Solicited Workflow
A *solicited* based attachment request, is a non-CDex FHIR request where a payer may send a portal, letter, X12 message or other type of request to the provider for additional information to support a claim or prior authorization. In response, the additional information is being sent from the provider system/EMR using CDex Attachments. The attachment is then re-associated with the claim or prior authorization.

##### Example Scenarios:
1.	Submitting additional information for a prior authorization.
2.	Submitting supplemental information for a claim based on a X12 (or other non-CDex FHIR) based payer request

#### Unsolicited Workflow
For an *unsolicited* attachment the provider will submit additional information using CDex Attachments to support a claim or prior authorization based on payer predefined rules without any type of request.  The attachment is then re-associated with the claim or prior authorization.

##### Example Scenarios:
1.	Additional information based on a set of pre-defined rules by the payer or in state mandates without a specific request.
2.	Additional information for a claim that a Provider believes the Payer will need for processing.
3.	A Provider is under review and required to provide additional information for all claims.


In all of these cases, the payer will require a trading partner agreement for sending attachments based on predefined rules.
{:.bg-warning}

### `$submit-attachment` Operation

This guide defines a simple RESTful interaction for exchanging attachments using [`$submit-attachment`], a FHIR [Operation].  This operation accepts the clinical attachments and the necessary information needed to re-associate  them to the claim or prior authorization, and returns a transaction layer http response. See the [`$submit-attachment`] operation definition and examples below for further details.


### FHIR Technical Workflow


As shown in the figure 7 below, the attachments are “pushed” using the [`$submit-attachment`] operation directly to the Payer or an Intermediary.

{% include img-med.html img="attachments-sequencediagram.svg" caption="Figure 7" %}

1. EHR assembles attachments and re-association  data for a claim or prior authorization
1. EHR invokes [`$submit-attachment`] operation to submit attachments to Payer
1. Payer responds with an http transactional layer response either accepting or rejecting transaction
1. Payer re-associates additional information with claim or prior authorization

### Attachments Transaction Scenario

In the following example, a Provider creates a claim and sends supporting CCDA documents using the FHIR operation, [`$submit-attachment`]:

`POST [base]/$submit-attachment`

#### Scenario 1: CCDA Document Attachments

- Based on a set of pre-defined rules set by the Payer, Provider submits CCDA Documents as additional information for a claim. (*Unsolicited Attachments*).
  - Typically, when the attachments are CCDA documents as in this scenario, they are already digitally signed and supply provenance information. Therefore, FHIR signatures and external Provenance resources are not needed.
- Provider knows the Payer's endpoint for sending attachments.  Note that the [`$submit-attachment`] operation can be used by any HTTP endpoint, not just FHIR RESTful servers.
- An unsolicited workflow implies that the *Provider* assigns the claim and line item identifiers upon claim generation.
- Re-association of attachments to the claim and subsequent steps are out of scope for this guide.

{% include examplebutton_default.html example="attachment-scenario1.md" b_title = "Click Here To See Example CCDA Document Attachments" %}

---

### Signatures

Some data consumers may require that the data they receive are signed. When performing CDex Attachments transactions and signatures are required, the following general rules apply:

- The signature **SHALL** represent a *human provider* signature on resources attesting that the information is true and accurate.
- The returned object is either already inherently signed (for example, a wet signature on a PDF or a digitally signed CCDA) or it **SHALL** be transformed into a signed [FHIR Document](http://hl7.org/fhir/documents.html) and `Bundle.signature`  **SHALL** be used to exchange the signature.

#### The Data Consumer Requirements

When an electronic or digital signature is required for CDex Attachments, the Data Consumer **SHALL**:

- *Pre-negotiate* the signature requirement with the organization representing the Data Source.
   - If the signature requirement is pre-negotiated, it **SHALL** be assumed that *all* attachments will be signed.
   - Conversely, it **SHOULD** be assumed that no CDex Attachments transaction will be signed unless there exists a pre-negotiated agreement
   - Based on the agreement, *electronic* or *digital* signatures **MAY** be used  
- Follow the documentation in the [Signatures] page for validating signatures.


#### Data Source Requirements

Refer to the [Data Source/Responder Requirements](task-based-approach.html#data-sourceresponder-requirements) section in the Task Based Approach to signatures.

#### Example: *Signed* FHIR Resource Attachments

- This example is the same as Scenario 1 above except that the attachment is a FHIR resource and a FHIR digital signature is required.
  - Unlike Scenario 1 which uses DocumentReference resource to index the CCDA attachment, FHIR resources representing the clinical/administrative data are transformed into a FHIR Document bundle and the bundle is digitally signed.
- See the [Signatures] page for complete examples on how the signature was created.

{% include examplebutton_default.html example="attachment-scenario2.md" b_title = "Click Here To See Example *Signed* FHIR Resource Attachments" %}


{% include link-list.md %}
