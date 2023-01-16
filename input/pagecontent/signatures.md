
### About Signatures

{% include signature-support.md %}

Data Consumers such as a Payer may require signatures from a Data Source to attest to the information being exchanged. For example, for a Centers for Medicare and Medicaid Services (CMS) worker to adequately review a Provider’s claim, the submitted information needs to be signed.[^first][^second]  In direct query transactions where there is no human intervention, Data Consumers may require signatures from Data Source attesting that they supplied the information. To comply with these signature requirements, this page documents how to create and verify FHIR Digital Signatures when using CDex Transactions. 
 
### The Signer

As illustrated in the table below, the signatory depends on the transaction.  For synchronous or automated transactions it is a system-level signature, for asynchronous transactions involving a human it is a provider signature. 

||Direct Query|Task Based Query|Attachments|
|---|---|---|---|
|System Level|X|X||
|Human Provider||X|X|
{:.grid}

System-level and provider signatures represent different levels of attestation:

{% include human-signature.md %}
{% include system-signature.md %}

{% include signature-disclaimer.md %}


### What is Signed

The data returned in CDEX is not limited to FHIR resources, but may also include C-CDA documents, pdfs, text files, and other types of data. Depending on the data type and format returned, the signature may be in the actual payload or a [FHIR Signature] in the Bundle that envelopes the payload.  The following table summarizes what artifacts are signed:

|Data Type Returned|Location of Signature|
|---|---|
|Non-FHIR data formats attached to or referenced by DocumentReference (e.g., CCDA)|Referenced or attached data|
|FHIR Documents (e.g., CCDA on FHIR, Task-based request\*, Unsolicited Attachment\*)|Document Bundle|
|FHIR Search Bundle (e.g., a query response)|Search Bundle|
|<span class="bg-success" markdown="1">FHIR QuestionnaireResponse (e.g., a query response)</span><!-- new-content -->|<span class="bg-success" markdown="1">QuestionnaireResponse</span><!-- new-content -->|
|Combination of above  (e.g., FHIR Search Bundle, FHIR Documents, and/or binary files referenced by DocumentReference)|Combination of Above|
{:.grid}

\* A *signed [FHIR Document]* is sent for task-based requests and some attachments transactions when the artifact would otherwise, if unsigned, be individual FHIR resources.

The details for how to indicate the signature requirement and how to respond with signed transactions are documented in the corresponding sections on signatures for [Direct Query], [Task Based Approach], [Sending attachments], [Requesting Attachments Using Attachment Codes], and <span class="bg-success" markdown="1">[Requesting Attachments Using Questionnaires]</span><!-- new-content -->.

Requirements for using *FHIR Signatures* to sign a Bundle <span class="bg-success" markdown="1">or QuestionnaireResponse</span><!-- new-content --> with electronic or digital signatures are documented in the sections below.  For guidance on signing other types of documents such as CDA or CCDA on FHIR documents refer to their specifications.

<div class="bg-success" markdown="1">

### CDex *Enveloped* Signatures

Signatures in CDex are an element in the signed Bundle or QuestionnaireResponse resource. This type of signature is referred to as an [enveloped signature]. For Bundles, the FHIR Bundle is the envelope, and the signature populates the [`Bundle.signature`] element. For QuestionnaireResponse, The envelope can be the resource, individual `QuestionnaireResponse.item` elements, or both, and the signature populates the [CDex Questionnaire Signature Extension]* The enveloped signatures must take care not to include the signature element in the calculation of the digital signature.

\* Both [CDex Task Attachment Request Profile] and the [DTR SDC Questionnaire] profile have the overlapping capability to indicate a signature is required. Signers must meet both the Task *and* Questionnaire signature expectations. The Task's signature input parameter represents the need for a verification signature for the QuestionnaireResponse. The [DTR SDC Questionnaire] profile supports many types of signatures, including verification signatures using the FHIR standard [signatureRequired] extension at the QuestionnareiResponse resource or `QuestionnareiResponse.item` level.

#### CDex Signature Profiles

This guide defines three profiles for using signatures:

1. [CDex Signature Profile] 
2. [CDex Signature Bundle Profile]
3. [CDex SDC QuestionnaireResponse Profile]

##### CDex Signature Datatype Profile

{{ site.data.resources.['StructureDefinition/cdex-signature']['description'] }}

See the [CDex Signature Profile] formal definition for further details.

##### CDex Signature Bundle Profile

{{ site.data.resources.['StructureDefinition/cdex-signature-bundle']['description'] }}

See the [CDex Signature Bundle Profile] formal definition for further details.


##### CDex SDC Questionnaire Response Profile

{{ site.data.resources.['StructureDefinition/cdex-sdc-questionnaireresponse']['description'] }}

See the [CDex SDC QuestionnaireResponse Profile] formal definition for further details.

</div><!-- new-content -->

### Electronic Signatures

>The term “electronic signature” means an electronic sound, symbol, or process, attached to or logically associated with a contract or other record and executed or adopted by a person with the intent to sign the record.[^third]

The various forms of electronic signatures include:
- a typed-out name
- a graphical image that represents a handwritten signature
- a digitized handwritten signature
- digital signature using encryption technology

This guide specifies how to implement digital signatures in the following sections. Specific guidance for other types of electronic signatures is an implementation detail that is out of scope for this guide.

#### Electronic Signature Example

In this example, a `Bundle.signature` is added to a FHIR Document. The electronic signature is a JPG Image that represents this handwritten signature:

<!-- ![](https://hackmd.io/_uploads/H1owYTqVK.jpg)

{%raw%}{%gist Healthedata1/db1e5b9cfe0232fb366973f89a426369 %}{%endraw%} -->

{% include img.html img="jh-signature.jpg" %}

<p>
  <button class="btn btn-info btn-lg btn-block" type="button" title="Click to Open or Close Example" data-toggle="collapse" data-target="#Bundle-cdex-electronic-sig-example-json-html" aria-expanded="false" aria-controls="collapseExample">
    Electronic Signature Example
  </button>
</p>

<div class="collapse" id="Bundle-cdex-electronic-sig-example-json-html">
  <div class="card card-body">
      {% include Bundle-cdex-electronic-sig-example-json-html.xhtml %}
  </div>
</div>
<br />

### Digital Signatures

*Digital Signatures* are a type of *Electronic signature* that meet the following functional requirements:

1. authentication  - They verify the identity of a person.
2. integrity -  They ensure the signed document has not been altered.
3. non-repudiation - The signer can not dispute their authorship (For example, if there is subsequent legal activity related to the signed document).

Digital Signatures employ encryption technology and a digital certificate issued by a certification authority (CA). The encryption ensures the integrity of the data has been attested by the signee. A certificate issued by a CA that the Data Consumer trusts ensure that the Data Consumer can trust that the signature is authentic and non-repudiable.

#### Digital Signature Rules For CDEX FHIR Bundle and QuestionnaireResponse:

1. **SHALL** use the [CDex Signature Bundle Profile] or [CDex SDC Questionnaire Response Profile]
2. **SHALL** use JSON Web Signature (JWS)(see [RFC 7515])
   >JSON Web Signature (JWS) is a means of representing content secured with digital signatures or Hash-based Message Authentication Codes (HMACs) using JSON data structures. Cryptographic algorithms and identifiers used with this specification are enumerated in the separate JSON Web Algorithms (JWA). [^fourth]

    Implementers that choose to support XML need to be aware that JSON Web Signatures can only be created and validated in the original native JSON.  Transforms to and from XML will invalidate signatures.
    {:.bg-warning} 

3. [JSON Signature rules](http://hl7.org/fhir/datatypes.html#JSON) specified in the FHIR specification. (reproduced below for reader convenience):
   >When the signature is a JSON Digital Signature (contentType = application/jose), the following rules apply:
   >- The Signature.data is base64 encoded JWS-Signature [RFC 7515: JSON Web Signature (JWS)]
   >- The signature is a [Detached] Signature (where the content that is signed is removed from the JWS)
   >- When FHIR Resources are signed, the signature is across the [Canonical JSON] form of the resource(s)
   >- The Signature **SHOULD** use the hashing algorithm SHA256. The signature validation policy will apply to the signature and determine acceptability
   >- The Signature **SHALL** include a "CommitmentTypeIndication" element for the purpose(s) of the signature. The Purpose can be the action being attested to, or the role associated with the signature. The value shall come from ASTM E1762-95(2013). The `Signature.type` shall contain the same values as the CommitmentTypeIndication element.

    There is no "CommitmentTypeIndication" element in JWS. This is an error in the FHIR specification and a tracker ([FHIR-36158]) has been logged. As documented in the CDex Profiles, `Signature.type` shall contain the value "1.2.840.10065.1.12.1.5" (Verification Signature).
    {:.stu-note}

4. Additional JWS rules for this guide:
   - **SHALL** support JWS compact serialization format for single signatures
     - Note that the complete JWS is in the form *Header.Payload.Signature* with period ('.') characters between the base64_url encoded parts.  This `Signature.data` value must be base64 encoded *again* as indicated above. Otherwise it will fail validation since the base64Binary regex: (\s*([0-9a-zA-Z\+\=]){4}\s*)+ does not include the period ('.') character.
   - **SHOULD** support [JWS JSON Serialization] format to represent multiple signatures with all parameter values identical except `"x5c"`.
     - The signer may have more than one certificate (for example, the signer participates in more than one trust community)
   - **SHALL** use [X.509 certificates] to verify the identity of the entity signing the Bundle or QuestionnaireResponse
    1. The KeyUsage should include 'DigitalSignature'
    2. The Issuer should be a trusted CA for the Consumer
    3. The Subject (or Subject Alternative Name (SAN)) should match the data Source
    4. The Validity Dates should be appropriate/long enough as determined by the business partners.
   - **SHALL** use the IETF JSON Canonicalization Scheme (JCS) (see [RFC 8785]) to generate the canonical form of the resource. JCS is a well-documented and standardized canonicalization algorithm, with multiple open-source implementations across several programming languages.
     - The `id`, `meta` and `signature` elements on the root Bundle resource **SHALL** be removed before canonicalization. In other words, everything in a Bundle is signed *except* for these elements.
     - <span class="bg-success" markdown="1">For signatures representing the entire QuestionnaireResponse, the `id`, `meta` and the signature extension on the root QuestionnaireResponse resource **SHALL** be removed before canonicalization. In other words, everything in a QuestionnaireResponse is signed *except* for these elements.</span><!-- new-content -->
     - <span class="bg-success" markdown="1">For signatures representing an item in the QuestionnaireResponse, the `id`, and the signature extension on the item resource **SHALL** be removed before canonicalization. In other words, everything in the `QuestionnaireResponse.item` is signed *except* for these elements.</span><!-- new-content -->
    <!--     1. The canonicalization algorithms defined in the FHIR specification *do not work* for the enveloped signatures that are being used in this guide.  -->

##### Sender/Signer Steps

1. Prepare JWS Header
    1.  **SHALL** have `"alg": "RS256"` (preferred) or some other JSON Web Algorithms (JWA) (see [RFC 7518])
    2.  **SHALL** have `"kty": "RS"`
    3.  **SHALL** have `"x5c"` (X.509 certificate chain) equal to an array of one or more base64-encoded (not base64url-encoded) DER representations of the public certificate or certificate chain (see [RFC 7517]).
The public key is listed in the first certificate in the `"x5c"` specified by the "Modulus" and "Exponent" parameters of the entry.
1. Prepare JWS Payload
    1. Prepare a valid FHIR Bundle or <span class="bg-success" markdown="1">QuestionnaireResponse or QuestionnaireResponse.item</span><!-- new-content -->
    2. Canonicalize the Bundle <span class="bg-success" markdown="1">or QuestionnaireResponse or QuestionnaireResponse.item</span><!-- new-content -->
    3. base64_url encode the payload
2. Create the JWS signature using the supported algorithm.
3. Remove the payload element from the JWS.
4. base64 encode the JWS
5. Add the Signature element to the Bundle <span class="bg-success" markdown="1">or the [CDex Questionnaire Signature Extension] to the QuestionnaireResponse or QuestionnaireResponse.item</span><!-- new-content --> and populate the mandatory Signature datatype elements and actual signature content:
   -  `Signature.type`  - Fixed to code =  "1.2.840.10065.1.12.1.5" [(Verification Signature)](http://hl7.org/fhir/valueset-signature-type.html)
   -  `Signature.when`  - System timestamp when signature created
   -  `Signature.who`  -  Reference or identifier of the organization or practitioner who signed it
   -  `Signature.data`  - base64 encoded JWS
6. Send data to the consumer:
   1. For direct queries, the search set Bundle is returned directly as the payload.
   2. For Task-based requests and Attachments, the document Bundle or <span class="bg-success" markdown="1">QuestionnaireResponse</span><!-- new-content --> is used

##### Receiver/Validation Steps

The following steps outline the process for verifying the Signature.

1. Retrieve and store the Bundle or <span class="bg-success" markdown="1">QuestionnaireResponse</span><!-- new-content -->:
   1. For direct queries, the search set Bundle is this payload response.
   2. For Task-based requests the completed `Task.output`  is either:
      -  a contained FHIR document and must first be 'decontained'
      -   a reference to a FHIR document and must be fetched from the referenced endpoint.
   3. For Attachments a FHIR Document Bundle or <span class="bg-success" markdown="1">QuestionnaireResponse</span><!-- new-content --> is submitted in the operation payload.
1. Remove the `Bundle.signature` element from the Bundle resource <span class="bg-success" markdown="1">or the signature extension(s) from the QuestionnaireResponse or QuestionnaireResponse.item.</span><!-- new-content -->
2. Canonicalize the resource.
3. Transform the canonicalized json to a base64-url format.
4. Get the base64 encoded JWS  from the `signature.data`  element
5. Base64 decode the encoded JWS
6. Insert the base64 encoded Bundle, <span class="bg-success" markdown="1">QuestionnaireResponse or QuestionnaireResponse.item</span><!-- new-content --> into the JWS payload element.
7. Obtain the public key from the first certificate in the JWS header `"x5c"` key
    - base64 decode the key value
    - Use the "Subject Public Key Info"
8. Verify Issuer, Validity Dates, Subject, and KeyUsage of the certificate,
9. Validate the JWS using the public key or the X.509 Certificate

##### Step-by-Step Examples

Although [*self-signed* certificates] are used for these examples, they are not recommended for production systems.
{:.bg-warning}

In these examples, a detached JWS signature is created using a signer's private key and self-signed certificate.  The `Bundle.signature` element is added to the Bundle with the base64 encoded JWS Signature as the `signature.data` property value.

- [Signed SearchSet Bundle Example]

FHIR search-set bundle signatures occur when performing direct queries where signatures are required on the returned results.   In this case, the digital signature represents a system-level attestation by the sending organization that they are the source of the information.

- [Signed Document Bundle Example]

FHIR document bundle signatures occur when performing Task-based requests or Attachment transactions where signatures are required and the returned results are individual FHIR resources (in other words, not CCDA, CCDA on FHIR, or other binary formats referenced by DocumentReference).  In this case, the digital signature represents a practitioner attesting that the information is true and accurate <span class="bg-success" markdown="1">to the best of their knowledge</span><!-- new-content -->.

---

[^first]: MLN Fact Sheet: Complying with Medicare Signature Requirements MLN Fact Sheet <https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Signature_Requirements_Fact_Sheet_ICN905364.pdf>
[^second]: CMS signature requirements outlined in the Medicare Program Integrity Manual (CMS Pub.100-08), Chapter 3, Section 3.3.2.4. <https://www.cms.gov/Regulations-and-Guidance/Guidance/Manuals/Downloads/pim83c03.pdf#page=44>
[^third]: "15 U.S. Code § 7006 - Definitions", LII / Legal Information Institute". Law.cornell.edu. Retrieved 2021-10-06. <https://www.law.cornell.edu/uscode/text/15/7006#5>
[^fourth]: [RFC 7515] Jones, M., et. al., "JSON Web Signature (JWS)", RFC 7515, ISSN: 2070-1721, May 2015, <https://tools.ietf.org/html/rfc7515>


{% include link-list.md %}
