
<!-- ---
tags: CDEX
title: Generating and Verifying *Signed* Resources
--- -->

This page provides specific guidance and rules to exchange *signed* data using FHIR and non FHIR signatures.
{:.new-content}

### Generating and Verifying *Signed* Resources

There is a legal liability associated with the data exchanged. Medical legal issue around administrative transactions means there is a
big difference is how you look at clinical vs contractual vs legal uses of data. Some data consumers may require that the data they receive are signed. For example, the CMS Attachments Rules require a digital signature to verify the authors of the data <span markdown="1" class="bg-danger"> ==MORE SPECIFIC CITATIONS NEEDED!==</span> [Signature_Requirements_Fact_Sheet](https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/Downloads/Signature_Requirements_Fact_Sheet_ICN905364.pdf)). Signatures attest that the data has been reviewed and the information is accurate and know it to be true.


In addition legal claims of fraud, waste and abuse requires extensive review of logs.  Therefore accurate and complete logs of what was data was exchanged must also be kept.
{:.bg-warning}

### What is Signed?

The data returned in CDEX is not limited to FHIR resources, but may also include C-CDA documents, pdfs, text files and other types of data. Depending on the data type returned, the signature may be in the actual payload or the `Bundle.signature` element.  The following table summarizes what artifacts are signed:

|Data Type Returned|Location of Signature|
|---|---|
|Non-FHIR data formats attached to or referenced by DocumentReference (e.g., CCDA)|Referenced or attached data|
|FHIR Documents (e.g., CCDA on FHIR, Task-based request*, Unsolicited Attachment*)|Document Bundle|
|FHIR Search Bundle (e.g., a query response)|Search Bundle|
|Combination of above  (e.g., FHIR Search Bundle, FHIR Documents, and/or binary files referenced by DocumentReference)|Combination of Above|
{:.grid}

\* A *signed FHIR Document* is sent for task based requests and attachments transactions when the artifact would otherwise, if unsigned, be individual FHIR resources.

The details for how to indicate the signature requirement and how to respond with signed transactions are documented in the corresponding sections on signatures for [FHIR RESTful queries](direct-query.html#signatures), [Task based requests](task-based-approach.html#signatures) and [Attachments](attachments.html#signatures).

Requirements for using *FHIR Signatures* to sign a Bundle with electronic or digital signatures are documented in the sections below.  For guidance on signing other types of documents such as CDA or CCDA on FHIR documents refer to their specifications.

### Electronic Signatures

>The term “electronic signature” means an electronic sound, symbol, or process, attached to or logically associated with a contract or other record and executed or adopted by a person with the intent to sign the record.[^first]

[^first]: "15 U.S. Code § 7006 - Definitions", LII / Legal Information Institute". Law.cornell.edu. Retrieved 2021-10-06. <https://www.law.cornell.edu/uscode/text/15/7006#5>

The [`Bundle.signature`](http://hl7.org/fhir/bundle-definitions.html#Bundle.signature) element is available to support the various forms of electronic signatures which include:
- a typed-out name
- a graphical image that represents a handwritten signature
- a digitized handwritten signature
- digital signature using encryption technology*

\* This guide provides specific guidance on how to implement digital signatures in the following sections. Specific guidance for other types of electronic signature is an implementation detail that is out of scope for this guide.
{:.bg-info}

#### Electronic Signature Rules For CDEX FHIR Bundles

1. FHIR Bundles are signed using an [enveloped  signature](http://www.w3.org/TR/xmldsig-core/#def-SignatureEnveloped)
    - **SHALL** use Bundle Resource as envelope
    - **SHALL** use `Bundle.signature`  for signature
1. The following mandatory Signature datatype elements and the signature content are populated in `Bundle.signature`:
   -  `Signature.type`  - Fixed to code =  "1.2.840.10065.1.12.1.5" [(Verification Signature)](http://hl7.org/fhir/valueset-signature-type.html)
   -  `Signature.when`  - System timestamp when signature created
   -  `Signature.who`  - Reference to the organization or practitioner who signed the Bundle
   -  `Signature.data`  - Actual signature content


#### Electronic Signature Example

In this Example, a `Bundle.signature` is added to the CDEX Task based [Example 4](task-based-approach.html#example-4). The electronic signature is a JPG Image that represents this handwritten signature:

<!-- ![](https://hackmd.io/_uploads/H1owYTqVK.jpg)

{%raw%}{%gist Healthedata1/db1e5b9cfe0232fb366973f89a426369 %}{%endraw%} -->

{% include img.html img="jh-signature.jpg" %}



{% include examplebutton.html example='Bundle-cdex-electronic-sig-example-json-html.xhtml' b_title= 'Electronic Signature Example' %}

~~~json
{"identifier": [
  {
    "use": "usual",
    "type": {
      "coding": [
        {
          "system": "http://terminology.hl7.org/CodeSystem/v2-0203",
          "code": "MR"
        }
      ]
    },
    "system": "urn:oid:1.2.36.146.595.217.0.1",
    "value": "12345",
    "period": {
      "start": "2001-05-06"
    },
    "assigner": {
      "display": "Acme Healthcare"
    }
  }
]
}
~~~

{% include examplebutton.html example='esigned-example.html' b_title= 'Electronic Signature Example' %}

### Digital Signatures

*Digital Signatures* are as type of *Electronic signature* that meet the following functional requirements:

1) authentication  - how the person that claims he is, is really that person
2) integrity - has not been altered
3) non-repudiation - if action later ( legal etc ) signer can not say it is not them.

Digital Signatures employ encryption technology and a digital certificate issued by a certification authority(CA).   The encryption ensure the integrity of the data has been attested by the signee. A certificate issued by a CA that the Data Consumer trusts ensures that the Data Consumer can trust that the signature is authentic and non-repudiable.

#### Digital Signature Rules For CDEX FHIR Bundles:

In addition to the electronic signature rules listed in the previous section, for digital signatures implementers:

1. **SHALL** use JSON Web Signature (JWS)[[see RFC 7515]](https://tools.ietf.org/html/rfc7515)
>JSON Web Signature (JWS) is a means of representing content secured with digital signatures or Hash-based Message Authentication Codes (HMACs) using JSON data structures. Cryptographic algorithms and identifiers used with this specification are enumerated in the separate JSON Web Algorithms (JWA). [^second]

[^second]: [RFC7515] Jones, M., et. al., "JSON Web Signature (JWS)", RFC 7515, ISSN: 2070-1721,
                May 2015,
<https://datatracker.ietf.org/doc/html/rfc7515>.

2. [JSON Signature rules](http://hl7.org/fhir/datatypes.html#JSON) specified in the FHIR specification. (reproduced below for reader convienience):

>When the signature is an JSON Digital Signature (contentType = application/jose), the following rules apply:
>- The Signature.data is base64 encoded JWS-Signature [RFC 7515: JSON Web Signature (JWS)](https://tools.ietf.org/html/rfc7515)
>- The signature is a [Detached](https://tools.ietf.org/html/rfc7515#appendix-F)  Signature (where the content that is signed is separate from the signature itself)
>- When FHIR Resources are signed, the signature is across the [Canonical JSON](http://hl7.org/fhir/json.html#canonical) form of the resource(s)
>- The Signature **SHOULD** use the hashing algorithm SHA256. Signature validation policy will apply to the signature and determine acceptability
>- The Signature **SHALL** include a "CommitmentTypeIndication" element for the Purpose(s) of Signature. The Purpose can be the action being attested to, or the role associated with the signature. The value shall come from ASTM E1762-95(2013). The `Signature.type` shall contain the same values as the CommitmentTypeIndication element.

3. Additional rules for this guide:
  - **SHALL** support only single signature using the use JWS compact serialization format
    :::info
    :thinking_face: The complete JWS is the Header.Payload.Signature with period ('.') characters between the base64_url encoded parts.  This `Signature.data` value need to be base64 encoded *again* as indicated above since the base64Binary regex: (\s*([0-9a-zA-Z\+\=]){4}\s*)+ will cause it to fail validation otherwise due to the period ('.') character.
    :::
    :::info
    If the issuer has more than one certificate for the same public key (e.g. participation in more than one trust community), then we need to use [JWS JSON Serialization](https://datatracker.ietf.org/doc/html/rfc7515#section-3.2) represent multiple signature with all parameter values identical except `"x5c"`. :unamused:
    :::
<!-- - **SHALL** embed the public key used to sign this JWS in *JSON Web Key* format using the `jwk` header claim
  - **MAY** also use others method to discover public key (see SMART cards?)-->
  - **SHALL** use [X.509 certificates](https://www.itu.int/rec/T-REC-X.509) to verify the identity of the entity signing the Bundle

    1. The KeyUsage should include 'DigitalSignature'
    1. The Issuer should be a trusted CA for the Consumer
    1. The Subject (:thinking_face: or Subject Alternative Name (SAN)) should match the data Source
    1. The Validity Dates should be appropriate/long enough for as determined by the business partners.

##### Sender/Signer Steps

1. Prepare JWS Header
    1.  **SHALL** have `"alg": "RS256"` (preferred) or some other JSON Web Algorithms (JWA) (see [RFC7518](https://tools.ietf.org/html/rfc7518))
    2.  **SHALL** have` "kty": "RS"`, and `"use": "sig"`
    3.  **SHALL** have `"x5c"` (X.509 certificate chain) equal to an array of one or more base64-encoded (not base64url-encoded) DER representations (:thinking_face: a.k.a. the PEM file?!?) of the public certificate or certificate chain (see [RFC7517](https://tools.ietf.org/html/rfc7517#section-4.7)).
The public key is listed in the first certificate in the `"x5c"` specified by the "Modulus" and "Exponent" parameters of the entry.
1. Prepare JWS Payload
    1. Prepare valid FHIR Bundle
    2. Following the method identified by [http://hl7.org/fhir/canonicalization/json](http://hl7.org/fhir/json.html#canonical), *canonicalize* the Bundle.
4. Create the JWS signature using the supported algorithm.
5. Remove the payload element from the JWS.
6. base64 encode JWS (:thinking_face: Base64-URL )
7. Add the Signature element to the Bundle and populate the mandatory Signature datatype elements and actual signature content:
   -  `Signature.type`  - Fixed to code =  "1.2.840.10065.1.12.1.5" [(Verification Signature)](http://hl7.org/fhir/valueset-signature-type.html)
   -  `Signature.when`  - System timestamp when signature created
   -  `Signature.who`  - Reference to the organization or practitioner who signed the Bundle
   -  `Signature.data`  - base64 encoded JWS
1. Send data to consumer:
   1. For direct queries, the searchset Bundle is returned directly as the payload.
   2. For Task based requests the output is document Bundle and is either:
      -  [contained](http://hl7.org/fhir/references.html#contained) by the returned Task
      -  referenced by Task

##### Receiver/Verifier Steps

The following steps outline the process for verifying the Signature on a Bundle.

1. Retrieve and store the Bundle:
   1. For direct queries, the searchset Bundle is this payload response.
   2. For Task based requests the completed `Task.output`  is either:
      -  a containe FHIR document and must first be 'decontained'
      -   a reference to a FHIR document  and must be fetched from the referenced endpoint.
1. Remove the `Bundle.signature` element from the Bundle resource.
5.  Following the method identified by [http://hl7.org/fhir/canonicalization/json](http://hl7.org/fhir/json.html#canonical), *canonicalize* the Bundle.
6. Transform canonicalize Bundle to a base64 format using the Base64-URL algorithm.
7. Get the base64 encoded JWS  from the `Bundle.signature.data`  element
8. Base64 decode the encoded JWS
9. Insert the base64 encoded Bundle into the JWS payload element.
10. Obtain public Key from the first certificate in JWS header `"x5c"` key
    - base64 decode the key value
    - Use the "Subject Public Key Info"
11. Verify Issuer, Validity Dates, Subject,and KeyUsage of certificate,
12. Verify Signature using the public key or the X.509 Certificate


##### Worked Examples

:::warning
[*self-signed* certificates](https://en.wikipedia.org/wiki/Self-signed_certificate) are used for the purpose of these examples and not recommended for production systems.
:::

In these example, a detached JWS signature is created using a signer's private key and self-signed certificate.  The `Bundle.signature` element is added to the Bundle with the base64 encoded JWS Signature as the `signature.data` property value.

###### [SearchSet Bundle Example](https://github.com/Healthedata1/CDEX-Signatures/blob/main/DaVinci_Digsig_Searchset_Bundle_Example.ipynb)

The Searchset level signatures occurs when performing direct queries where signatures are required on the returned results.   In this case the digital signature represents a system-level attestation by the sending organization that they are the source of the information.

###### [Document Bundle Example](https://github.com/Healthedata1/CDEX-Signatures/blob/main/DaVinci_Digsig_Document_Bundle_Example.ipynb)

The Document level signatures occurs when performing Task based requests where signatures are required and the returned results are individual fhir resources (in other words, not CCDA, CCDA on FHIR or other binary formats referenced by DocumentReference).  In this case the digital signature represents a practitioner attesting that the information is true and accurate.

{% include link-list.md %}
