### Direct Query

For Direct Query, the Payer directly queries the EHR for specific data using the standard FHIR RESTful search. *This is the preferred option*. Guidance for exchanging data with FHIR search is fully described in the base FHIR specification and the Da Vinci HRex Implementation Guide.  Refer to the [US Core] Implementation guide for accessing the set of health data classes and data elements defined by the [ONC United States Core Data for Interoperability (USCDI)].

#### Benefits

- "Out of the Box" FHIR transaction
- Widely implemented
- Simplest workflow
- Authorization/Authentication protocols established
- No human intervention needed

#### Sequence Diagram

The sequence diagram in Figure 2 below outlines a successful interaction between the Payer and EHR to query and retrieve the requested data using a direct query:

{% include img.html img="search-sequencediagram.svg" caption="Figure 3" %}

#### Example Transactions:

The following example transactions show scenarios of using direct query to get clinical data from an EHR.

##### Scenario 1

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C <span class="bg-success"> to support a claim submission.</span>

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the *logical id* of the resource for Patient B
- Payer A knows the appropriate codes for searching for active conditions

Following guidance in US Core searches for all active conditions using the combination of the patient and clinical-status search parameters:

`GET [base]/Condition?patient=[reference]&clinical-status=active,recurrance,remission`

{% include examplebutton_default.html example="direct-query1-scenario" b_title = "Click Here To See Example Direct Query for Patient's Active Conditions" %}

---

##### Scenario 2

Payer A Seeks Insured Person/Patient B's glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.

**Preconditions and Assumptions:**

- Payer A is authorized and has the appropriate scopes to access the health records of Patient B from Provider C using FHIR RESTful Queries
- Payer A knows the *logical id* of the resource for Patient B
- Payer A knows the appropriate LOINC codes for searching for HbA1c test results (e.g.: 4548-5 *Hemoglobin A1c/Hemoglobin.total in Blood*)

Following guidance in US Core searches for all HbA1c test results by a date range using using the combination of the patient and code and date search parameters:

`GET [base]/Observation?patient=[reference]&code=[code]&date=gt[date]`

{% include examplebutton_default.html example="direct-query2-scenario" b_title = "Click Here To See Example Direct Query for Patient's HbA1c Results after 2020-01-01" %}

---

##### Scenario 3

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

{% include link-list.md %}
