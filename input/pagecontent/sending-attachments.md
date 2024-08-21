

This page documents a FHIR-based approach to sending attachments for claims or prior authorization directly to a Payer.\* This transaction is used for both *solicited* and *unsolicited* attachments. It is intended to be compatible with the X12n 275 transaction, the X12 N 837I and 837P for claims purposes, and the 278 response for authorizations (for more information on X12 defined transactions, see [X12 Transaction Sets]). Compatibility assumes that the appropriate identifiers are supported in the submission to facilitate the association of the attachment with the claim submission or authorization request. 

{% include see-conf.md %}

### `$submit-attachment` Operation

This guide defines [`$submit-attachment`], a simple RESTful interaction for exchanging attachments using a FHIR [Operation]. {{ site.data.resources.['OperationDefinition/submit-attachment']['description'] }}

See the [`$submit-attachment`] operation definition for further details.

<div class="stu-note " markdown="1">
Based upon additional testing, we intend to to upgrade the Endpoint Discovery Strategy guidance (**SHOULD**) to  a requirement (**SHALL**) in the next version of CDex
</div><!-- stu-note -->

### Technical Workflow

As shown below in Figure 13, the attachments are "pushed" using the [`$submit-attachment`] operation directly to the Payer or an Intermediary.


{% include img.html img="attachments-sequencediagram.svg" caption="Figure 13" %}


1. The Provider assembles the attachments and metadata to associate the attachments to a claim or prior authorization
2. The Provider invokes [`$submit-attachment`] operation to submit attachments to the Payer
3. The Payer responds with an HTTP response that accepts or rejects the transaction.
   - The Payer **SHOULD** return an informational OperationOutcome with the HTTP accept response if the attachments can not be associated with a *current* claim or prior authorization and are being held for association with a *future* claim or prior authorization. An OperationOutcome example is used in Scenario 1b below.
4. The Payer associates the attachments to the claim or prior authorization and processes the claim.


### Data Elements for Sending Attachments

When sending attachments, the following data elements are needed to associate an attachment to a claim or prior authorization. They are mapped to the [`$submit-attachment`] parameters and their corresponding x12n 275 elements in the following table. {% include X12_IP.md %}  

{% include attachments_to_275.md %}

For *solicited* attachments, the Payer sends the same data elements in the request for attachments. See the [Requesting Attachments Using Attachment Codes] and [Requesting Attachments Using Questionnaires] pages for a detailed discussion on how these data elements are used in the CDex Attachment Request Profile to request attachments and in the [`$submit-attachment`] response to the Payer.

### Examples

In the following examples, a Provider creates a claim and sends *unsolicited attachments* using the FHIR operation, [`$submit-attachment`]. For *solicited attachments* examples, see the [Requesting Attachments Using Attachment Codes] and [Requesting Attachments Using Questionnaires] pages.

`POST [base]/$submit-attachment`

##### Scenario 1a: CCDA Document Attachments

- Based on the Payer's pre-defined rules, the Provider submits C-CDA Documents as additional documentation for a claim.
  - Typically, when the attachments are C-CDA documents, as in this scenario, they are already digitally signed and supply provenance information. Therefore, FHIR signatures and external Provenance resources are not needed.
- The Provider knows the Payer's endpoint for sending attachments. Note that the Provider can POST the [`$submit-attachment`] operation to endpoints that are not FHIR RESTful servers.
- An unsolicited workflow implies that the *Provider* assigns the claim and line item identifiers upon claim generation.
- The Payer associates attachments to the claim.

{% include examplebutton_default.html example="unsolicited-attachment-scenario1a.md" b_title = "Click Here To See Example CCDA Document Attachments" %}

#### Scenario 1b: CCDA Document Attachments Submitted *Prior* to claim

This scenario is the same as Scenario 1a above, except the attachments are submitted *prior* to the claim. The Payer accepts the attachments and returns an OperationOutcome informing the Provider system that the attachments are waiting for the claim.

{% include examplebutton_default.html example="unsolicited-attachment-scenario1b.md" b_title = "Click Here To See Example CCDA Document Attachments" %}

##### Scenario 2: Laboratory Results Attachments

 This scenario is the same as Scenario 1a, except the Provider submits laboratory results supporting a claim. There are multiple attachments, each populated with a FHIR Observation resource. If a signature were required, the provider system would convert it to a signed FHIR document, as shown in the example in the signatures section.

{% include examplebutton_default.html example="unsolicited-attachment-scenario2.md" b_title = "Click Here To See Example Laboratory Results Attachments" %}

---

### Signatures

{% include signature-support.md %}

Some data consumers may require that the data they receive be signed. When signatures are required, the following general rules apply:

{% include human-signature.md %}
{% include inherently-signed.md %}

{% include signature-disclaimer.md %}

#### The Payer Requirements

- For *Unsolicited* Attachments, the Payer *pre-negotiates* with the Provider whether electronic or digital signatures are required. If signatures are required, *all* attachments will be signed by the provider submitting them.
- For *Solicited* Attachments, the Payer *pre-negotiates* with the Provider whether electronic or digital signatures are required for:
  1. *all* attachments
  2. or *only* for attachments where the attachment request communicates the signature requirement using the `Task.input` "signature" input parameter.
- The Payer/Requester follows the documentation on the [Signatures] page to validate signatures.
  - If the signatures fail verification when processing the [`$submit-attachment`] operation, the Data Source/Responder **SHALL** return an HTTP `400 Bad Request` *and* an OperationOutcome declaring that the signature was invalid.

#### Provider Requirements

{% include data-source-sig-rules.md %}

- In this example, the Provider submits a patient's active conditions to the Payer to support a claim.
Unlike Scenario 1, which uses DocumentReference resources to index the C-CDA attachment, FHIR resources representing the patient's active conditions are transformed into a digitally signed FHIR Document bundle.
- See the [Signatures] page for a detailed explanation of how the signature was created and verified.

{% include examplebutton_default.html example="unsolicited-attachment-scenario3.md" b_title = "Click Here To See Example Signed FHIR Resource Attachments" %}

#### Example: The Signature Cannot Be Verified

This example is the same as the previous one, except the digital signature cannot be verified.  However, the interaction it illustrates would be the same whether the attachment was a digitally signed C-CDA, FHIR Document, or QuestionnaireResponse.

- In this example, the Provider submits the patient's active conditions to the Payer to support a claim.
- Unlike the previous example, the Payer cannot verify the signature because the certificate is expired.
- An HTTP `400 Bad Request` and OperationOutcome are returned.

{% include examplebutton_default.html example="unsolicited-attachment-scenario7.md" b_title = "Click Here To See an Example Where a Signature Cannot Be Verified" %}

#### Example: Signature Missing

This example is the same as Scenario 1 above, except a digital signature is required but is absent.  The interaction it illustrates would be the same whether the attachment was a digitally signed C-CDA, FHIR Document, or QuestionnaireResponse.

- The Provider submits CCDA Documents as additional documentation for a claim.
- The attachment is an *unsigned* CCDA document, and the Payer requires a digital signature in this scenario.
- An HTTP `400 Bad Request` and OperationOutcome are returned.

{% include examplebutton_default.html example="unsolicited-attachment-scenario4.md" b_title = "Click Here To See an Example Where the Signature is Missing" %}

{% include link-list.md %}
