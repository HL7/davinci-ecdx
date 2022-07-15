{% include page_for_ballot.md %}

This page documents a FHIR based approach for sending attachments for claims or prior authorization directly to a Payer.  This transaction is use for both *solicited* and *unsolicited* attachments.   <span class="bg-danger" markdown="1">It is intended to be compliant with HIPAA Attachment rules for CMS and an alternative to the X12n 275 transaction.</span><!-- new-content -->

### `$submit-attachment` Operation

This guide defines [`$submit-attachment`], a simple RESTful interaction for exchanging attachments using a FHIR [Operation]. {{ site.data.resources.['OperationDefinition/submit-attachment']['description'] }}

See the [`$submit-attachment`] operation definition for further details.

### Technical Workflow

As shown in the figure 7 below, the attachments are “pushed” using the [`$submit-attachment`] operation directly to the Payer or an Intermediary.

<div class="bg-success" markdown="1">

{% include img.html img="attachments-sequencediagram.svg" caption="Figure 7" %}


1. Data Source assembles attachments and the meta data to associate the attachments to a claim or prior authorization
1. Data Source invokes [`$submit-attachment`] operation to submit attachments to Payer
1. Payer responds with an http transactional layer response either accepting or rejecting the transaction.
   - The Payer **SHOULD** return an informational OperationOutcome with the http accept response if the attachments can not be associated with a *current* claim or prior authorization and are being held for association with a *future* claim or prior authorization.  An OperationOutcome example is used in Scenario 1b below.
2. The Payer associates the attachments to the claim or prior authorization, and processes the claim.

</div><!-- new-content -->

### Data Elements for Sending Attachments

The following data elements are needed to associate an attachment to a claim or prior authorization when sending attachments.  They are mapped to the [`$submit-attachment`] parameters and their corresponding x12n 275 analog in the following table: 

{% include attachments_to_275.md %}

The data element mapping table is available as a [CSV](data-element-mapping.csv) and [Excel](data-element-mapping.xlsx) file.

For *solicited* attachments, the same data elements are sent in the request for attachments. See the [Requesting Attachments] page for a detailed discussion on how these data element are used in the CDex Attachment Request Profile to request attachments and in the [`$submit-attachment`] response back to the Payer.

 <!-- The table below shows the mappings between the corresponding data communicated in the attachments request for CDex Request Attachment, X12n 277, and 278response forms and the  [`$submit-attachment`] parameters.  -->


### Examples

In the following examples, a Provider creates a claim and sends supporting CCDA documents as *unsolicited attachments* using the FHIR operation, [`$submit-attachment`]. For *solicited attachments* examples, see the [Requesting Attachments] page.

`POST [base]/$submit-attachment`

##### Scenario 1a: CCDA Document Attachments

- Based on a set of pre-defined rules set by the Payer, Provider submits CCDA Documents as additional documentation for a claim.
  - Typically, when the attachments are CCDA documents as in this scenario, they are already digitally signed and supply provenance information. Therefore, FHIR signatures and external Provenance resources are not needed.
- Provider knows the Payer's endpoint for sending attachments.  Note that the [`$submit-attachment`] operation can be used by any HTTP endpoint, not just FHIR RESTful servers.
- An unsolicited workflow implies that the *Provider* assigns the claim and line item identifiers upon claim generation.
- <span class="bg-success" markdown="1">Payer associates attachments to the claim.</span><!-- new-content -->

{% include examplebutton_default.html example="attachment-scenario1a.md" b_title = "Click Here To See Example CCDA Document Attachments" %}

<div class="bg-success" markdown="1">

#### Scenario 1b: CCDA Document Attachments Submitted *Prior* to Claim

This Scenario is the same as Scenario 1a above except that the attachments are submitted *prior* to the claim.  The Payer accepts the attachments and returns an OperationOutcome informing the Provider system that the attachments are waiting for the claim.

{% include examplebutton_default.html example="attachment-scenario1b.md" b_title = "Click Here To See Example CCDA Document Attachments" %}

</div><!-- new-content -->

---

### Signatures

<div class="bg-success" markdown="1">
Some data consumers may require that the data they receive are signed. When signatures are required, the following general rules apply:

{% include human-signature.md %}
{% include inherently-signed.md %}

{% include signature-disclaimer.md %}
</div><!-- new-content -->

#### The Data Consumer Requirements

<div class="bg-success" markdown="1">
- For *Unsolicited* Attachments, the Data Consumer/Requester *pre-negotiates* with the organization representing the Data Source/Responder whether electronic or digital signatures are required.  If the signatures are required *all* attachments will be signed by the provider submitting them.
- For *Solicited* Attachments, the Data Consumer/Requester *pre-negotiates* with the organization representing the Data Source/Responder whether electronic or digital signatures are required for:
  1. *all* attachments will be signed or
  1. *only* attachments for attachment requests that communicate the signature requirement using the `Task.input` [signature flag](StructureDefinition-cdex-task-attachment-request-definitions.html#Task.input:signature) input parameter.
- The Data Consumer/Requester follows the documentation in the [Signatures] page for validating signatures.
</div><!-- new-content -->

#### Data Source Requirements

<div class="bg-success" markdown="1">
{% include data-source-sig-rules.md %}
</div><!-- new-content -->

#### Example: *Signed* FHIR Resource Attachments

- This example is the same as Scenario 1 above except that the attachment is a FHIR resource and a FHIR digital signature is required.
  - Unlike Scenario 1 which uses DocumentReference resource to index the CCDA attachment, FHIR resources representing the clinical/administrative data are transformed into a FHIR Document bundle and the bundle is digitally signed.
- See the [Signatures] page for complete examples on how the signature was created.

{% include examplebutton_default.html example="attachment-scenario2.md" b_title = "Click Here To See Example *Signed* FHIR Resource Attachments" %}


{% include link-list.md %}
