### Introduction

For Direct Query, the Data Consumer directly queries the Data Source for specific data using the standard FHIR RESTful search. Refer to the base FHIR specification and the Da Vinci HRex Implementation Guide for more information and guidance on this interaction. For accessing the set of health data classes and data elements defined by the [ONC United States Core Data for Interoperability (USCDI)], refer to the [US Core 3.1.1], [US Core 6.1.0], or [US Core 7.0.0] Implementation guides.


### Benefits

- "Out of the Box" FHIR transaction
- Widely implemented
- Simplest workflow
- Authorization/Authentication protocols established
- No human intervention is needed

### Sequence Diagram

The sequence diagram in Figure 6 below outlines a successful interaction between the Data Consumer and Data Source to query and retrieve the requested data using a direct query:

{% include img.html img="search-sequencediagram.svg" caption="Figure 6" %}




### Discovery of Patient FHIR IDs

In addition to using a patient business identifier such as an MRN or Member ID, the FHIR Patient.id is often a prerequisite to performing FHIR RESTful Direct Queries and other transactions described in this guide. However, the requester is not required to know the FHIR Patient.id before the exchange. With sufficient demographic information or identifiers, any of the following FHIR transactions can be used to discover the FHIR Patient.id:

1. Call the patient [`$match`] operation to ask an MPI to match a patient.*
   - CDex Data Source servers **SHOULD** support the patient match operation and declare it in their CapabilityStatement.

2. Search the Patient using a Direct Query.
   - For example:
   
      `Get /Patient?identifier=[member_id]&birthdate=[date]&name=[name]&gender=[gender]`

   - CDex Data Source servers **SHALL** support resolving logical identifiers for the Patient resource.
    
3. Use the [Task Based Approach] to request the Patient resource.

<div class="bg-info" markdown="1">
*The [Interoperable Digital Identity and Patient Matching] guide extends the patient [`$match`] operation for cross-organizational use by highlighting best practices in matching attributes and their verification before responding to a patient match request or interpreting match results. It also serves as a set of best practices for patient matching in similar FHIR transactions like Direct Query or Task based approach. Implementers are encouraged to review the following sections:

- [Patient Matching]
- [Guidance on Identity Assurance]
</div><!-- bg-info"-->



### Direct Query Transaction Scenarios

The following example transactions show scenarios of using direct query to get clinical data from a Data Source.

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

Payer A Seeks Insured Person/Patient B's glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C.

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the FHIR id of the Patient resource for Patient B
- Payer A knows the appropriate LOINC codes for searching for HbA1c test results (e.g., 4548-5 *Hemoglobin A1c/Hemoglobin.total in Blood*)

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
- Provider C supports the standard FHIR search parameters, `_search` and `_count` (if this is not the case, then the Payer can search using the date parameter and select the most recent Progress notes from the query results.)

Getting the latest Progress note is typically a two-step process:

1. Query DocumentReference, which references the actual notes file
2. Fetch the notes file

Following the US Core Clinical Notes Guidance section, the Payer searches for the Progress note C-CDA documents using the combination of the patient and type search parameters. 
In addition, the combination of `_sort` and `_count` parameters limits the response to only the most recent data. For example, with `_sort=-period` (sort by the `date` parameter in descending order) and `_count=1`, the query returns the most current matching resource.

`GET [base]/DocumentReference?patient=[FHIR id]&type=[type-code]&_sort=-period&_count=1`

The `DocumentReference.content.attachment.url` element references the actual CCDA document, and the Payer fetches it using a RESTful GET.

`GET [base]/[url]`

{% include examplebutton_default.html example="direct-query3-scenario" b_title = "Click Here To See Example Direct Query for Patient's Latest Progress note" %}

### Provenance

To the extent that the Data Source keeps a record of the provenance of the data, the FHIR Provenance Resource can be requested as documented on US Core's [Basic Provenance] page. When returning provenance, they should use the [HRex Provenance Profile]. The following example illustrates this transaction.

#### Example of Direct Query Response Including Provenance

This example is the same as Scenario 1 above, except it includes the corresponding Provenance records.

`GET [base]/Condition?patient=[FHIR id]&clinical-status=active,recurrance,remission&_revinclude=Provenance:target`

{% include examplebutton_default.html example="direct-query1p-scenario" b_title = "Click Here To See Example Direct Query for Patient's Active Conditions and Provenance records" %}

---

### Signatures

{% include signature-support.md %}

Some data consumers may require that the data they receive be signed. When signatures are required, the following general rules apply:

{% include system-signature.md %}
- The `Bundle.signature` element on the FHIR search set Bundle is used to exchange the signature.

{% include signature-disclaimer.md %}
#### The Data Consumer/Requester Requirements

- The Data Consumer/Requester *pre-negotiates* with the Data Source/Responder whether electronic or digital signatures are required. If signatures are required, *all* search query response data will be signed by the sending organization.
- The Data Consumer/Requester follows the documentation on the [Signatures] page for validating signatures.
  - If the signatures fail verification, the Data Consumer/Requester notifies the Data Source that the signature is invalid or absent. Currently, there is no standard way to communicate this, and it needs to be done "out of band".

#### Data Source/Responder Requirements

- If signatures are required, the Data Source/Responder returns a *signed FHIR search set Bundle* using the `Bundle.signature` element for the signature signed by the organization responding to the query.
- The Data Source/Responder follows the documentation on the [Signatures] page for producing signatures.
- As discussed in the [What is Signed] section, a signed search bundle could also have individually signed entries. Therefore, if the Data Consumer incorrectly assumed there would be a signature (wet, electronic, or digital) on an individual returned object within the search set Bundle (e.g., CCDA, PDF, Image, CDA on FHIR ), they can re-request it using a Task-based request and specify that it be signed (see [Signatures for Task Based Requests]).

<div markdown="1" class="bg-warning" id="read-warning">

When signatures are required, the Data Consumer must use a [FHIR RESTful search] instead of [FHIR RESTful read]. There is no CDex support for signatures on a FHIR RESTful read because it fetches a single instance of a resource instead of a Bundle. If the Data Consumer attempts to fetch a resource with a read and a signature is required, the Data Source/Responder **SHALL** return an HTTP `400 Bad Request` *and* an OperationOutcome describing the business rule error. The following HTTP response and OperationOutcome illustrate this.

 ~~~
 HTTP/1.1 400 Bad Request
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

</div><!-- bg-warning -->

#### Example of *Signed* Direct Query Response

This example is the same as Scenario 1 above, except it includes a digital signature. See the [Signatures] page for a detailed explanation of how the signature was created and verified.

**Preconditions and Assumptions:**
- In addition to the Scenario 1 assumptions above, Payer A pre-negotiated with Provider B that direct query responses require digital signatures.

`GET [base]/Condition?patient=[FHIR id]&clinical-status=active,recurrance,remission`

{% include examplebutton_default.html example="direct-query1s-scenario" b_title = "Click Here To See Example Signed Direct Query Response" %}

{% include link-list.md %}
