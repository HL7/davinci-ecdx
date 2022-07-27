
For Direct Query, the Data Consumer directly queries the Data Source for specific data using the standard FHIR RESTful search. Guidance for exchanging data with FHIR search is fully described in the base FHIR specification and the Da Vinci HRex Implementation Guide.  Refer to the [US Core] Implementation guide for accessing the set of health data classes and data elements defined by the [ONC United States Core Data for Interoperability (USCDI)].

### Benefits

- "Out of the Box" FHIR transaction
- Widely implemented
- Simplest workflow
- Authorization/Authentication protocols established
- No human intervention is needed

### Sequence Diagram

The sequence diagram in Figure 5 below outlines a successful interaction between the Data Consumer and Data Source to query and retrieve the requested data using a direct query:

{% include img.html img="search-sequencediagram.svg" caption="Figure 5" %}

### Discovery of Patient FHIR IDs

The patient's [FHIR id] is often a prerequisite to performing FHIR RESTful Direct Queries.  Note that using a patient business identifier such as an MRN or Member ID is not widely supported as FHIR references in HIT systems today.  Therefore, a patient lookup to determine the patient's FHIR id on the server is typically required. One option is to use the [Patient Match] operation where it has been implemented. Another option is to find the FHIR id using the FHIR RESTful API. These are the most direct approaches to obtaining the FHIR id:

1. FHIR RESTful search on the Patient resource using a combination of an identifier known by a Data Consumer. For example, a Payer may use a member_id and patient demographics.

   `Get /Patient?identifier=[member_id]&birthdate=[date]&name=[name]&gender=[gender]`

1. FHIR RESTful search on [Coverage] resource using a combination of the payor's FHIR id and identifier known by the Data Consumer.  For example, a Payer may use a member id or subscriber id. The patient's FHIR id is found in the `beneficiary` element (which references the patient).

   `GET /Coverage?payor=[FHIR id]&identifier=[member_id]`
   or
   `GET /Coverage?payor=[FHIR id]&subscriber-id=[subscriber_id]`

However, servers may or may not support identifier-based searches or searches based on member_id identifiers by HIT systems. In addition, the search semantics become more complex if effective dates of coverage are included in the search.

### Direct Query Transaction Scenarios

The following example transactions show scenarios of using direct query to get clinical data from a Data Source(HIT).

#### Scenario 1

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C to support a claims audit.

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful queries
- Payer A knows the FHIR id of the Patient resource for Patient B
- Payer A knows the appropriate codes for searching for active conditions

Following the guidance in US Core, a search for all active conditions uses the combination of the patient and clinical-status search parameters:

`GET [base]/Condition?patient=[FHIR id]&clinical-status=active,recurrance,remission`

{% include examplebutton_default.html example="direct-query1-scenario" b_title = "Click Here To See Example Direct Query for Patient's Active Conditions" %}

---

#### Scenario 2

Payer A Seeks Insured Person/Patient B's glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the FHIR id of the Patient resource for Patient B
- Payer A knows the appropriate LOINC codes for searching for HbA1c test results (e.g.: 4548-5 *Hemoglobin A1c/Hemoglobin.total in Blood*)

Following the guidance in US Core searches for all HbA1c test results by a date range using the combination of the patient and code and date search parameters:

`GET [base]/Observation?patient=[FHIR id]&code=[code]&date=gt[date]`

{% include examplebutton_default.html example="direct-query2-scenario" b_title = "Click Here To See Example Direct Query for Patient's HbA1c Results after 2020-01-01" %}

---

#### Scenario 3

Payer A Seeks Insured Person/Patient B's latest Progress notes from Provider C to support a claim submission.

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the FHIR id of the Patient resource for Patient B
- Payer A knows the appropriate LOINC codes for searching for Progress note CCDA documents (11506-3 *History & Physical Note*)
- Provider C supports the standard FHIR search parameters, `_search` and `_count` (if this is not the case, then the Payer can search using the date parameter and select the most recent Progress notes for the query results.)

Getting the latest Progress note is typically a two-step process:

1. Query DocumentReference which references the actual notes file
2. Fetch the notes file

Following the US Core Clinical Notes Guidance section, Payer searches for Progress note CCDA documents using the combination of the patient and type search parameters.  In addition, the combination of `_sort` and `_count` is used to return only the latest resource that meets particular criteria. With `_sort=-period` (sort by the `date` parameter in descending order) and `_count=1` the last matching resource will be returned.

`GET [base]/DocumentReference?patient=[FHIR id]&type=[type-code]&_sort=-period&_count=1`

The actual CCDA document is referenced in `DocumentReference.content.attachment.url` and can be fetched using a RESTful GET.

`GET [base]/[url]`

{% include examplebutton_default.html example="direct-query3-scenario" b_title = "Click Here To See Example Direct Query for Patient's Latest Progress note" %}

### Provenance

To the extent that the Provider keeps a record of the provenance for the source of the data, the FHIR Provenance Resource can be requested as documented on US Core's [Basic Provenance] page. When returning provenance the [HRex Provenance Profile] should be used. An example illustrating this transaction is shown below.

#### Example of Direct Query Response Including Provenance

This example is the same as Scenario 1 above except that it also includes the corresponding Provenance records.

`GET [base]/Condition?patient=[FHIR id]&clinical-status=active,recurrance,remission&_revinclude=Provenance:target`

{% include examplebutton_default.html example="direct-query1p-scenario" b_title = "Click Here To See Example Direct Query for Patient's Active Conditions and Provenance records" %}

---

### Signatures

Some data consumers may require that the data they receive are signed.  When signatures are required on the returned results, the following general rules apply:

{% include system-signature.md %}
- The `Bundle.signature` element on the FHIR search set Bundle is used to exchange the signature.

{% include signature-disclaimer.md %}

#### The Data Consumer/Requester Requirements

- The Data Consumer/Requester *pre-negotiates* with the organization representing the Data Source/Responder whether electronic or digital signatures are required for FHIR RESTful query response data. If the signatures are required *all* search query response data will be signed by the sending organization.
- The Data Consumer/Requester follows the documentation on the [Signatures] page for validating signatures.
  - If the signatures fail verification, the Data Consumer/Requester notifies the Data Source that the signature is bad or absent. Currently, there is no standard way to communicate this, and it needs to be done “out of band”.

#### Data Source/Responder Requirements

- When an electronic or digital signature is required for a FHIR RESTful queries, the Data Source/Responder returns a *signed FHIR search set Bundle* using the `Bundle.signature` element for the signature signed by the organization that is responding to the query.
- The Data Source/Responder follows the documentation on the [Signatures] page for producing signatures.
- As discussed in the [What is Signed] section, a signed search bundle could have entries within it that are individually signed as well. If the Consumer/Requester assumed there would be a signature (wet, electronic, or digital) on an individual returned object within the search set Bundle (e.g CCDA, PDF, Image, CDA on FHIR ) and it is not present, they can re-request the signed object using Task-based request (see [Signatures for Task Based Requests]).

<div markdown="1" class="bg-warning" id="read-warning">

When signatures are required, the Data Consumer must use a [FHIR RESTful search] instead of [FHIR RESTful read]. There is no CDex support for signatures on a FHIR RESTful read because it fetches a single instance of a resource instead of a Bundle.  If a read is attempted and a signature is required, the Data Source/Responder **SHALL** return an HTTP `400 Bad Request` *and* an OperationOutcome describing the business rule error for any read transactions as shown in the following example:

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

This example is the same as Scenario 1 above except that it also includes a digital signature. See the [Signatures] page for a complete worked example of how the signature was created and verified.

**Preconditions and Assumptions:**
- In addition to the Scenario 1 assumptions above, Payer A pre-negotiated with Provider B that digital signatures are required for direct query responses.

`GET [base]/Condition?patient=[FHIR id]&clinical-status=active,recurrance,remission`

{% include examplebutton_default.html example="direct-query1s-scenario" b_title = "Click Here To See Example *Signed* Direct Query Response" %}

{% include link-list.md %}
