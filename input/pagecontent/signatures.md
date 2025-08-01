
### About Signatures

{% include signature-support.md %}

Data Consumers such as Payers may require signatures from a Data Source to attest to the information being exchanged. For example, for a Centers for Medicare and Medicaid Services (CMS) worker to adequately review a Provider's claim, the submitted information needs to be signed.[^first][^second]  In direct query transactions without human intervention, Data Consumers may require signatures from Data Sources attesting that they supplied the information. To comply with these signature requirements, this page documents how to create and verify FHIR Digital Signatures when using CDex Transactions. 
 
### The Signer

As illustrated in the table below, the signatory depends on the transaction. For synchronous or automated transactions, it is a system-level signature; for asynchronous transactions involving a human, it is a provider signature. 

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

The data returned in CDEX is not limited to FHIR resources but may also include C-CDA documents, PDFs, text files, and other formats. <span class="bg-success" markdown="1">Depending on the data type and format returned, the signature may be in the actual payload or a [FHIR Signature].</span><!-- new-content --> The following table summarizes what artifacts are signed:

|Data Type Returned|Location of Signature|
|---|---|
|Non-FHIR data formats attached to or referenced by DocumentReference (e.g., CCDA)|Referenced or attached data|
|FHIR Documents (e.g., CCDA on FHIR, Task-based request\*, Unsolicited Attachment\*)|Document Bundle|
|FHIR Search Bundle (e.g., a query response)|Search Bundle|
|FHIR QuestionnaireResponse (e.g., a query response) |QuestionnaireResponse |
|Combination of above  (e.g., FHIR Search Bundle, FHIR Documents, or binary files referenced by DocumentReference)|Combination of Above|
{:.grid}

\* A *signed [FHIR Document]* is sent for task-based requests and some attachments transactions when the artifact would otherwise, if unsigned, be individual FHIR resources.

The corresponding sections on signatures for [Direct Query], [Task Based Approach], [Sending attachments], [Requesting Attachments Using Attachment Codes], and [Requesting Attachments Using Questionnaires] document how to indicate the signature requirement and how to respond with signed transactions. The sections below define the requirements for using *FHIR Signatures* to sign a Bundle or QuestionnaireResponse with electronic or digital signatures. Refer to the appropriate specifications for guidance on signing other documents, such as CDA or CCDA on FHIR Documents.

<div class="bg-success" markdown="1">

### CDex Signatures

In previous versions of this implementation guide, the term "enveloping" was used incorrectly to describe CDex Signatures
{:.stu-note}

Signatures in CDex are represented as an element in the signed Bundle or QuestionnaireResponse resource. For FHIR Documents and FHIR Search Bundles, the signature populates the [`Bundle.signature`] element. The signature applies to the entire Bundle, ensuring that all contained resources are authenticated as a single unit.  For QuestionnaireResponse, the signature populates the FHIR standard [signatureRequired] extension at the QuestionnaireResponse resource or `QuestionnareiResponse.item` level.\*

\* When using a FHIR Questionnaire to request data, the [DTR Standard Questionnaire] Profile is used to profile the Questionnaire. Both [CDex Task Attachment Request Profile] and the [DTR Standard Questionnaire] profile have the overlapping capability to indicate that a signature is required. Signers must meet both the Task *and* Questionnaire signature expectations. The Task's signature input parameter represents the need for a verification signature for the QuestionnaireResponse. The [DTR Standard Questionnaire] profile supports many reasons for signatures, including verification signatures.
{:.bg-warning}

</div><!-- new-content -->
#### CDex Digital Signature Profiles

This guide defines three profiles for using signatures:

1. [CDex Digital Signature Profile] 
2. [CDex Signature Bundle Profile]
3. [CDex SDC QuestionnaireResponse Profile]

##### CDex Digital Signature Datatype Profile

{{ site.data.resources.['StructureDefinition/cdex-signature']['description'] }}

See the [CDex Digital Signature Profile] formal definition for further details.

##### CDex Signature Bundle Profile

<span class="bg-success" markdown="1">{{ site.data.resources.['StructureDefinition/cdex-signature-bundle']['description'] }}</span><!-- new-content -->

See the [CDex Signature Bundle Profile] formal definition for further details.


##### CDex SDC Questionnaire Response Profile

<span class="bg-success" markdown="1">{{ site.data.resources.['StructureDefinition/cdex-sdc-questionnaireresponse']['description'] }}</span><!-- new-content -->

See the [CDex SDC QuestionnaireResponse Profile] formal definition for further details.

### Electronic Signatures

>The term "electronic signature" means an electronic sound, symbol, or process attached to or logically associated with a contract or other record and executed or adopted by a person with the intent to sign the record.[^third]

The various forms of electronic signatures include:
- a typed-out name
- a graphical image that represents a handwritten signature
- a digitized handwritten signature
- digital signature using encryption technology

This guide specifies how to implement digital signatures in the following sections. Specific guidance for other electronic signatures is an implementation detail that is out of scope for this guide.

#### Electronic Signature Examples

In this example, a `Bundle.signature` is added to a FHIR Document. The electronic signature is a JPG Image that represents this handwritten signature:

{% include img.html img="jh-signature.jpg" %}

{% include examplebutton_default.html example="electronic-sig-example.md" b_title = "Click Here To See Electronic Signature Example" %}

Several examples demonstrating the implementation and application of CDex Signatures are also provided on the [FHIR artifacts page](artifacts.html#signature-examples)

### Digital Signatures

*Digital Signatures* are a type of *Electronic signature* that meet the following functional requirements:

1. authentication  - They verify the identity of a person.
2. integrity -  They ensure the signed document has not been altered.
3. non-repudiation - The signer can not dispute their authorship (For example, if there is subsequent legal activity related to the signed document).

Digital Signatures employ encryption technology and a digital certificate issued by a certification authority (CA). The encryption ensures the signee has attested to the integrity of the data. A certificate issued by a CA that the Data Consumer trusts, ensures that the Data Consumer can trust that the signature is authentic and non-repudiable.

<div class="bg-success" markdown="1">

#### Digital Signature Rules and Guidance For CDEX Bundle and QuestionnaireResponse 

1.  **SHALL** use the [CDex Digital Signature Profile] with the [CDex Signature Bundle Profile] for digitally signed Bundles and with the [CDex SDC QuestionnaireResponse Profile] for for digitally signed QuestionnaireResponse.  This Signature DataType profile enforces the various elements of digital signatures documented in this section.
 
1. Implementers **SHALL** follow the following FHIR R6 [JSON Signature rules](https://hl7.org/fhir/6.0.0-ballot3/datatypes.html#JSON)
   - The Signature.data is base64 encoded JWS-Signature [[RFC 7515]: JSON Web Signature (JWS)]
     - The JWS mime type `application/jose` **SHALL** be indicated in the `Signature.sigFormat` element.
     - > JSON Web Signature (JWS) is a means of representing content secured with digital signatures or Hash-based Message Authentication Codes (HMACs) using JSON data structures. Cryptographic algorithms and identifiers used with this specification are enumerated in the separate JSON Web Algorithms (JWA). [^fourth]
   - The signature is a [Detached] Signature (where the content that is signed is removed from the JWS)
     - In other words, the `Bundle.signature` or the QuestionnaireResponse [signatureRequired] extension is removed before signing.

   - When FHIR Resources are signed, the signature is across the [Canonical JSON](https://hl7.org/fhir/6.0.0-ballot3/json.html#canonical) form of the resource(s)
 
      -  CDEX is pre-adopting the changes to FHIR R6 json canonicalization guidance and  **SHALL** use the IETF JSON Canonicalization Scheme (JCS) (see [RFC 8785]) to generate the canonical form of the resource.  JCS is a well-documented standardized canonicalization algorithm with multiple open-source implementations across several programming languages.
         - This canonicalization method is identified by the URI `application/fhir+json;canonicalization=http://hl7.org/fhir/canonicalization/json#document` and **SHALL** be indicated in the `Signature.targetFormat` element.

            <div class="bg-info" markdown="1">

            Implementers that support both XML and JSON wire formats **MAY** support cross format signatures by:

            - Validating the JSON Web Signatures in the JSON format.
            - Canonicalizing the XHTML`text.div` narrative element following the [FHIR R6 XML Canonicalization rules](https://hl7.org/fhir/6.0.0-ballot3/xml.html#canonical) prior to the JSON canonicalization of the resource.
            - identifying This canonicalization method by the URI `application/fhir+json;canonicalization=http://hl7.org/fhir/canonicalization/json+xml#document` and **SHALL** indicate it in the `Signature.targetFormat` element.
            </div><!-- new-info -->
    
      - `Bundle.id`, and `Bundle.meta`  **SHALL** be removed before canonicalization. In other words, everything in a Bundle is signed *except* for these elements.
     - For signatures representing the entire QuestionnaireResponse, `QuestionnaireResponse.id`, and `QuestionnaireResponse.meta` elements **SHALL** be removed before canonicalization. In other words, everything in a QuestionnaireResponse is signed *except* for these elements. 
     - For signatures representing an item in the QuestionnaireResponse, the `QuestionnaireResponse.item.id` **SHALL** be removed before canonicalization. In other words, everything in the `QuestionnaireResponse.item` is signed *except* for these elements. 

  
   - The signature **SHALL** include a `"srCms"` signer commitments" header element for the Purpose(s) of the Signature (see [JAdES-B-T](https://www.etsi.org/deliver/etsi_ts/119100_119199/11918201/01.01.01_60/ts_11918201v010101p.pdf), page 17). The Purpose can be the action being attested to, or the role associated with the signature. The value shall come from ASTM E1762-95(2013).
     -  The `"srCms"` header **SHALL** contain an `"id": "urn:oid:1.2.840.10065.1.12.1.5"` (Verification Signature)
     -  The `Signature.type.code` elements **SHALL** contain the same values as the `"srCms"` header ids.
2. The signature Header: 
    1. **SHALL** include an `"alg"` parameter for the JSON Web Algorithms (JWA) (see [RFC 7518]). `"alg": "RS256"` is preferred.
    2. **SHALL** include a `"kty"` parameter corresponding to the cryptographic algorithm family in `"alg"` ( e.g., `"kty": "RSA"` for `"alg": "RS256"` )
    3. **SHALL** have `"x5c"` (X.509 certificate chain) equal to an array of one or more base64-encoded (not base64url-encoded) DER representations of the public certificate or certificate chain (see [RFC 7517]).
The public key is listed in the first certificate in the `"x5c"` specified by the entry's "Modulus" and "Exponent" parameters.
    1. **SHALL** include a `"sigT"` header parameter with a timestamp of the signature.
    2. **SHALL** include a `"srCms"` signer commitments as defined above.
1.  **SHOULD** use the hashing algorithm SHA256. The signature validation policy will apply to the signature and determine the acceptability
2. **SHALL** support JWS compact serialization format for single signatures
    - Note that the complete JWS is in the form *Header.Payload.Signature* with a period `.` character between the base64_url encoded parts. This `Signature.data` value must be base64 encoded *again* as indicated above. Otherwise, it will fail validation since the base64Binary regex: (\s*([0-9a-zA-Z\+\=]){4}\s*)+ does not include the period `.` character.
3. **SHOULD** support [JWS JSON Serialization] format to represent multiple signatures with identical parameter values except `"x5c"`.
    - The signer may have more than one certificate (for example, the signer participates in more than one trust community)
4. The certificate **SHALL** include a Subject Alternative Name (SAN) which **SHALL** match the `Signature.who.identifier`
5.  To verify the identity of the entity signing the Bundle or QuestionnaireResponse:
       - The certificate Issuer **SHOULD** be a trusted CA for the Consumer
       - The certificate KeyUsage **SHOULD** include 'DigitalSignature'
       - The certificate Validity Dates **SHOULD** be appropriate/long enough as determined by the business partners
       - One of the certificate Subject Alternative Name (SAN)) **SHALL** match `Signature.who.identifier` to verify the identity of the entity signing 
       - The `"srCms"` Signer Commitments header ids **SHALL** match the `Signature.type.code` elements.
       - The `"Sigt"` header timestamp  **SHALL** match `Signature.when`

##### Sender/Signer Steps

The following steps outline the process for creating the Signature.

1. Prepare JWS Header as defined above.
2. Prepare JWS Payload
    1. Prepare a valid FHIR Bundle or QuestionnaireResponse or QuestionnaireResponse.item 
    2. Remove the `id` and `meta` elements.
    3. Canonicalize the Bundle or QuestionnaireResponse or QuestionnaireResponse.item 
    4. base64_url encode the payload
3. Create the JWS signature using the supported algorithm.
4. Remove the payload element from the JWS.
5. base64 encode the JWS
6. Add the Signature element to the Bundle or the signature extension in the QuestionnaireResponse or QuestionnaireResponse.item and populate the elements and as documented above and profiled in the [CDex Digital Signature Profile]
7. Send data to the consumer:
   1. The search set Bundle is returned directly as the payload for direct queries.
   2. For Task-based requests and Attachments, the document Bundle or QuestionnaireResponse is used

##### Receiver/Validation Steps

The following steps outline the process for verifying the Signature.

1. Retrieve and store the Bundle or QuestionnaireResponse :
   1. The search set Bundle is the response for a direct query.
   2. For Task-based requests, the completed `Task.output` is either:
      -  a contained FHIR Document that must be extracted from the containing Task resource.
      -  a reference to a FHIR Document that must be fetched from the referenced endpoint.
   3. A FHIR Document Bundle or QuestionnaireResponse is submitted as part of the operation payload for Attachments.
2. Remove the `id`, `meta` and `.signature` element from the Bundle resource or the signature extension(s) from the QuestionnaireResponse or QuestionnaireResponse.item. 
3. Canonicalize the resource.
4. Transform the canonicalized JSON to a base64-url format.
5. Get the base64 encoded JWS  from the `signature.data`  element
6. Base64 decode the encoded JWS
7. Insert the base64 encoded Bundle, QuestionnaireResponse, or QuestionnaireResponse.item into the JWS payload element.
8. Obtain the public key from the first certificate in the JWS header `"x5c"` key
    - base64 decode the key value
    - Use the "Subject Public Key Info"
9. Verify Issuer, Validity Dates, Subject, and KeyUsage of the certificate,
10. Validate the JWS using the public key or the X.509 Certificate


#### Digital Signature Examples

Several examples demonstrating the implementation and application of CDex Signatures are provided on the [FHIR artifacts page](artifacts.html#signature-examples)

</div><!-- new-content -->

##### Step-by-Step Examples  <span class="bg-success" markdown="1">

Although [*self-signed* certificates] are used for these examples, they are not recommended for production systems.
{:.bg-warning}

In these examples, a detached JWS signature is created using a signer's private key and self-signed certificate. Then, the `Bundle.signature` element is added to the Bundle with the base64 encoded JWS Signature as the `signature.data` property value. Finally, the signature is verified.

- [Worked Example: Signed SearchSet Bundle] : FHIR search-set bundle signatures occur when performing direct queries where signatures are required on the returned results.   In this case, the digital signature represents a system-level attestation by the sending organization that they are the source of the information.

-  [Worked Example: Signed Document Bundle] : FHIR Document bundle signatures occur when performing Task-based requests or Attachment transactions where signatures are required. The returned results are individual FHIR resources (in other words, not C-CDA, C-CDA on FHIR, or other binary formats referenced by DocumentReference). In this case, the digital signature represents a practitioner attesting that the information is true and accurate to the best of their knowledge.

---

[^first]: MLN Fact Sheet: Complying with Medicare Signature Requirements MLN Fact Sheet <https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Signature_Requirements_Fact_Sheet_ICN905364.pdf>
[^second]: CMS signature requirements outlined in the Medicare Program Integrity Manual (CMS Pub.100-08), Chapter 3, Section 3.3.2.4. <https://www.cms.gov/Regulations-and-Guidance/Guidance/Manuals/Downloads/pim83c03.pdf#page=44>
[^third]: "15 U.S. Code § 7006 - Definitions", LII / Legal Information Institute". Law.cornell.edu. Retrieved 2021-10-06. <https://www.law.cornell.edu/uscode/text/15/7006#5>
[^fourth]: [RFC 7515] Jones, M., et al., "JSON Web Signature (JWS)", RFC 7515, ISSN: 2070-1721, May 2015, <https://tools.ietf.org/html/rfc7515>


{% include link-list.md %}
