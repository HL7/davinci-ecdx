
For Direct Query, the Payer directly queries the EHR for specific data using the standard FHIR RESTful search. *This is the preferred option*. Guidance for exchanging data with FHIR search is fully described in the base FHIR specification and the Da Vinci HRex Implementation Guide.  Refer to the [US Core] Implementation guide for accessing the set of health data classes and data elements defined by the [ONC United States Core Data for Interoperability (USCDI)].

### Benefits

- "Out of the Box" FHIR transaction
- Widely implemented
- Simplest workflow
- Authorization/Authentication protocols established
- No human intervention needed

### Sequence Diagram

The sequence diagram in Figure 5 below outlines a successful interaction between the Payer and EHR to query and retrieve the requested data using a direct query:

{% include img.html img="search-sequencediagram.svg" caption="Figure 5" %}

### Discovery of Patient FHIR IDs

The patient's [FHIR id] is a prerequisite to performing both a FHIR RESTful Direct Query and Task-based query. See [this section](task-based-approach.html#patient-fhir-ids) for how to discover the patient's FHIR_id.
{:.new-content}

#### Example Direct Query Transaction Scenarios:

The following example transactions show scenarios of using direct query to get clinical data from an EHR.

#### Scenario 1

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C <span class="bg-success"> to support a claim submission.</span>

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the *logical id* of the resource for Patient B
- Payer A knows the appropriate codes for searching for active conditions

Following guidance in US Core searches for all active conditions using the combination of the patient and clinical-status search parameters:

`GET [base]/Condition?patient=[reference]&clinical-status=active,recurrance,remission`

{% include examplebutton_default.html example="direct-query1-scenario" b_title = "Click Here To See Example Direct Query for Patient's Active Conditions" %}

---

#### Scenario 2

Payer A Seeks Insured Person/Patient B's glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the *logical id* of the resource for Patient B
- Payer A knows the appropriate LOINC codes for searching for HbA1c test results (e.g.: 4548-5 *Hemoglobin A1c/Hemoglobin.total in Blood*)

Following guidance in US Core searches for all HbA1c test results by a date range using using the combination of the patient and code and date search parameters:

`GET [base]/Observation?patient=[reference]&code=[code]&date=gt[date]`

{% include examplebutton_default.html example="direct-query2-scenario" b_title = "Click Here To See Example Direct Query for Patient's HbA1c Results after 2020-01-01" %}

---

#### Scenario 3

Payer A Seeks Insured Person/Patient B's latest history and physical exam notes from Provider C <span class="bg-success>to support a claim submission</span>.

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the *logical id* of the resource for Patient B
- Payer A knows the appropriate LOINC codes for searching for History and Physical CCDA document (34117-2 *History & Physical Note*)
- Provider C supports the standard FHIR search parameters, `_search` and `_count` (if this is not the case then the Payer can search using the date parameter and select the most recent history and physical exam notes for the query results.)

Getting the latest History and Physical is typically a two step process:

1. Query DocumentReference which references the actual notes file
2. Fetch the notes file

Following the US Core Clinical Notes Guidance section, Payer searches for History and Physical CCDA document using the combination of the patient and type search parameters.  In addition, the combination of `_sort` and `_count` is used to return only the latest resource that meets a particular criteria. With `_sort=-period` (sort by the `date` parameter in descending order) and `_count=1` the last matching resource will be returned.

`GET [base]/DocumentReference?patient=[id]&type=[type-code]&_sort=-period&_count=1`

The actual CCDA document is referenced in `DocumentReference.content.attachment.url` and can be fetched using a RESTful GET.

`GET [DocumentReference.content.attachment.url]`

{% include examplebutton_default.html example="direct-query3-scenario" b_title = "Click Here To See Example Direct Query for Patient's Latest History and Physical" %}

<div markdown="1" class="new-content">

### Provenance

To the extent that the Provider keeps a record of the provenance for the source of the data, the FHIR Provenance Resource can be requested as documented in US Core [Basic Provenance] page. When returning provenance the [HRexProvenance Profile] should be used. An example illustrating this transaction is shown below.

#### Example of Direct Query Response Including Provenance

This example is the same as Scenario 1 above except that it also includes the corresponding Provenance records.

`GET [base]/Condition?patient=[reference]&clinical-status=active,recurrance,remission&_revinclude=Provenance:target`

{% include examplebutton_default.html example="direct-query1p-scenario" b_title = "Click Here To See Example Direct Query for Patient's Active Conditions and Provenance records" %}

### Signatures

Some data consumers may require that the data they receive are signed. When performing direct queries when signatures are required on the returned results, the following general rules apply:

- The signature **SHALL** represent a *system-level* attestation by the sending organization that they are the source of the information.
- The `Bundle.signature` element on the FHIR searchset Bundle **SHALL** be used to exchange the signature.

#### The Data Consumer/Requester Requirements

When a electronic or digital signature is required for a FHIR RESTful Queries, the Data Consumer/Requester **SHALL**:

- *Pre-negotiate* the signature requirement with the organization representing the Data Source/Responder.
   - If the signature requirement is pre-negotiated, it **SHALL** be assumed that *all* search query response will be signed.
   - Conversely, it **SHOULD** be assumed that no search query response will be signed unless there exists a pre-negotiated agreement
   - Unlike Task based queries, the actual FHIR queries won't indicate that a signature is required.
   - Based on the agreement, *Electronic* or *digital* signatures **MAY** be used  
- Follow the documentation in the [Signatures] page for validating signatures.

#### Data Source/Responder

When a electronic or digital signature is required for a FHIR RESTful Queries, the Data Source/Responder **SHALL**:
- Return a *signed FHIR searchset Bundle* using the `Bundle.signature` element for the the signature.
- Be signed by the organization that is responding the the query.
- Follow the documentation in the [Signatures] page for producing signatures.

<div markdown="1" class="bg-info">

- As discussed in the [What is Signed] section, a signed search bundle could have a entries within it that are individually signed as well. If the Consumer/Requester assumed there would be a signature (wet,electronic, or digital) on an individual returned object within the searchset Bundle (e.g CCDA, PDF, Image, CDA on FHIR ) and it is not present.  They **MAY**  re-request the signed object using Task based request (see [Signatures for Task Based Requests]).

</div>

<div markdown="1" class="bg-warning">

Because the signature is represented by `Bundle.signature`, this precludes using [FHIR RESTful read](http://build.fhir.org/http.html#read) transactions which returns a single instances of a resource.  Therefore, the following rules apply for read transactions:
- If signatures are required, the Consumer/Requester **SHALL NOT** use read transaction to fetch data.
- If signatures are required the Data Source/Responder **SHALL** return a http `400 Bad Request` *and* an OperationOutcome describing the business rule error for any read transactions as shown in the following example:

~~~
HTTP/1.1 400 Not Found
[other headers]
{
  "resourceType": "OperationOutcome",
  "id": "cdex-signed-read-response",
  "issue": [
{
  "severity": "error",
  "code": "business-rule",
  "details": {
    "text": "signed FHIR RESTful read response is not supported."
  },
  "diagnostics": "Resubmit the request as a FHIR RESTful search'"
}
  ]
}
~~~

</div>


#### Example of *Signed* Direct Query Response

The following example shows [Scenario 1](#example-transactions) response with a signature attached. See [Signatures] page for complete worked example on how the signature was created.

{%raw%}{%gist Healthedata1/ef1d8be9cf47253d66354b02a74db802 %}{%endraw%}

</div>

{% include link-list.md %}
