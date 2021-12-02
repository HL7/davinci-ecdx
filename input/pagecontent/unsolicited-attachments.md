---
tags: CDEX
title:  Unsolicited Attachments
---

# Unsolicited Attachments

<div markdown="1" class="stu-note">

**The following content is to be considered DRAFT, because it has not yet undergone HL7 balloting.**


### Attachments for Claims or Prior Authorization

The guide documents a FHIR based approach for exchanging attachments for claims or prior authorization directly to a Payer. In contrast to the Direct Query and Task Based approach, the CDex Unsolicited Attachment transaction is not a response to a FHIR-based request for clinical data. Instead it is either based on a set of pre-defined rules by the payer or jurisdictional mandates ("Unsolicited"), or the request for attachments comes through an X12 transaction or Prior Authorization ("Solicited").

Today claims come through X12, portal submission, or other ways.  The additional information to support these claims (a.k.a. attachments) come through X12 transactions, fax, portal, other ways *before, with or after* a claim.  The attachment is then re-attached to the claim and the claim processed. 

The following scenarios illustrate where Unsolicited Attachments transaction can be used:
  
1. Additional information based on a set of pre-defined rules by the payer or in state mandates without a specific request.
1. Attachments for a claim, because a Provider thinks the Payer will want it.
1. A Provider is under review and needs to provide additional information for all claims.
1. Filing a claim for two surgeons in one surgery.
1. Submit additional information for prior authorization.

In all these case, the payer will require a trading partner agreement for unsolicited attachments based based on predefined rules.

### `$attachment` Operation

This guide defines a simple RESTful interaction using a [FHIR Operation] for exchanging attachments and the necessary information needed to re-attach it to the claim. 


Data Elements needed for re-attachment:
1. Sending org/location id (value)
2. Sending provider (e.g. NPI - value) – combine into #1?
3. Patient member identifier ( value)
4. Artifact type (Claim or prior auth)
5. Claim/pauth id (value, and type=placer/filler)
6. 0..1 | 0..* Item id (value, type=placer/filler)
7. 1..* Attachment


 ...operationdefinition pending....

### FHIR Technical Workflow : 


As shown in the figure below, the attachments are “pushed” using the `$attachment` operation directly to the Payer or an Intermediary.

```sequence
Note left of Provider: Provider assembles\n claim attachments
Provider->Payer: POST $attachment
Payer-->Provider: http Response
Note right of Payer: Out of Scope:\n Payer attaches data\n to claim and\n processes claim
```

1. Provider assemble attachments and re-attachment data for a claim in payload
1. Provider invokes `$attachment` operation to submit attachments to Payer
1. Payer responds with http transactionl layer
1. Payer attaches data to claim and processes claim (out of scope) 


### Signatures



### Examples



{% include link-list.md %}
