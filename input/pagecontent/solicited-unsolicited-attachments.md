{% include page_for_ballot.md %}

Today claims typically come through [X12 transactions] or portal submissions. Payers may need additional information - referred to as "attachments" - from a Provider to determine if the service being billed (claim) or requested (prior authorization) is supported by medical benefits or by policy benefits. Attachments for Claims or Prior Authorization can be divided into *solicited* and *unsolicited* workflows. The Sections below document the differences and similarities between these workflows and the CDex transactions that can be used for each. 

### *Unsolicited* Attachments

For an *unsolicited* attachment the Provider will submit additional information to support a claim or prior authorization based on Payer predefined rules without any type of request.  <span class="bg-success" markdown="1">The attachments may be submitted *before, at the same time as, or after* the claim or pre-authorization has been supplied to the Payer.</span><!-- new-content --> The attachment is then associated with the claim or prior authorization. 

#### Example Scenarios

1.	Additional information based on a set of pre-defined rules by the Payer or in state mandates without a specific request.
2.	Additional information for a claim that a Provider believes the Payer will need for processing.
3.	A Provider is under review and required to provide additional information for all claims.


In all of these cases, the Payer will require a trading partner agreement for sending attachments based on predefined rules.
{:.bg-warning}


The flow diagram for this transaction is shown in the figure below:


{% include img.html img="unsolicited-flow.svg" caption="Unsolicited Attachments Flow Diagram" %}


See the [Sending Attachments] page for how CDex transactions can be used to support  *unsolicited* attachment transactions.



### *Solicited* Attachments

For a *solicited* attachment the Provider will submit additional information using to support a claim or prior authorization *in response to*  a Payer's request for additional documentation.  The submitted attachments are then associated with the claim or prior authorization. The flow diagram for this transaction is shown in the figures below:


{% include img.html img="solicited-claim-flow.svg" caption="Solicited Attachments for a Claim" %}


{% include img.html img="solicited-prior-auth-flow.svg" caption="Solicited Attachments for a Prior Authorization" %}

Attachments may be requested via a non-CDex FHIR based request such as an X12 transactions, fax, portal, or other capabilities or they may be requested using CDex. See the [Requesting Attachments] page and [Sending Attachments] page for how CDex transactions can be used to support  *solicited* attachment transactions.

{% include link-list.md %}