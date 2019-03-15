---
title: CDex Confirm Medical Necessity
layout: default
active: CDex Confirm Medical Necessity
---

## Use Case Description
Payers review select medical claims and associated medical documentation to ensure the services billed were medical necessary and in compliance with Payer rules.  Such reviews safeguard the Payers programs by measuring, identifying and preventing improper payments. To gather information necessary to complete a review, the Payer may request the patients medical record from the provider.  When requesting documentation, the payer must specify the claim and member (patient) details including PHI.  Therefore, both the secure channel used to send the request and the destination to which the request is being sent need to be agreed upon by the Payer and Provider in advance. 

Payers need clinical documentation to confirm medical necessity and appropriateness of care. Determination of medical necessity affects prior authorization, claims processing, and auditing of submitted claims. Thus, clinical information may be needed at the time an authorization for services is requested, when claims are being processed, or when audits occur. 

Payers review select medical claims and associated medical documentation to ensure the services billed were medical necessary and in compliance with Payer rules.  Such reviews safeguard the Payers programs by measuring, identifying and preventing improper payments. To gather information necessary to complete a review, the Payer may request the patients medical record from the provider.  

When requesting documentation, the payer must specify the claim and member (patient) details including PHI.  Therefore, both the secure channel used to send the request and the destination to which the request is being sent need to be agreed upon by the Payer and Provider in advance. 

The information can be supplied in a standard exchange document format such as a progress note, or encounter summary. However, in some cases, just a specific subset of information may be needed such as certain results from diagnostic testing including diagnosis codes, assessment and diagnoses, or records of certain treatments or procedures.

## Examples
### DME Claim Processing
1. A Durable Medical Equipment supplier submits a claim for a wheelchair.  The Payer reviews the claim and assesses that the documentation submitted by the Provider is insufficient to support medical necessity or Payer coverage rules.  

2. The Payer sends an Additional Documentation Request (ADR) via a secure channel that both the Provider and Payer have agreed upon requesting the specific documentation from the Provider.

3. The provider receives the Additional Documentation Request (ADR) from the payer requesting specific documentation.  

4. The Provider sends the requested medical documentation (via a secure channel that both the Provider, and the Payer have agreed upon) to the Payer.
