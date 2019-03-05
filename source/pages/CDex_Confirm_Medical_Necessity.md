---
title: CDex Confirm Medical Necessity
layout: default
active: CDex Confirm Medical Necessity
---

## Use Case Description
Payers need clinical documentation to support prior authorization, claims processing, audit submitted claims, and to confirm medical necessity and appropriateness. The information is needed at the time prior authorization is requested, or during care planning. Clinical information may be needed asynchronously to support an audit or claims processing. It also is needed when providers are ordering a service. The information used when ordering the service needs to be shared with the provider referred to render the service because they need it to support the claim. Consulting providers may need to request additional information from the ordering physician in order to support their claim. The information can be supplied in a standard exchange document format such as a progress note, or encounter summary. However, in some cases, just a specific subset of information may be needed such as certain results from diagnostic testing including diagnosis codes, assessment and diagnoses, or records of certain treatments or procedures.

## Examples
Payers employ several types of Review Contractors (RCs) to review select medical claims to ensure medical necessity of the services provided and are in compliance with Medicare rules. The goal of these reviews is to reduce improper payments and prevent fraud, waste, and abuse. Additionally, reviews are performed to measure and report on the rate of improper payments under a given program. As part of all such reviews the payer may request the provider for additional medical records and documentation. When requesting for documentation, the payer needs to specify the details of the claim and the member for whom the information is being requested. Some of the information in this request may be sensitive (including PHI). Therefore, the payer needs to send this request to the provider via a secure channel which the provider and payer have agreed upon. Similarly, the destination to which the request is being sent also needs to be pre-agreed upon so as to reach the provider securely. 
