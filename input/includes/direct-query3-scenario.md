<!--
#### Scenario

Payer A Seeks Insured Person/Patient B's latest history and physical exam notes from Provider C to improve care coordination.

##### Preconditions and Assumptions:

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
-->
##### Example:

###### Step 1 - Search for DocumentReference

**Request**
~~~
GET [base]/DocumentReference?patient=06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b&type=34117-2&_sort=-period&_count=1`
~~~

**Request Headers**

~~~
Accept: application/fhir+json
Content-Type: application/fhir+json
...(other headers)
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: nginx/1.14.0 (Ubuntu)
Date: Fri, 23 Oct 2020 18:22:45 GMT
Content-Type: application/fhir+json;charset=utf-8
...(other headers)
~~~

**Response Body**

~~~
{
  "resourceType": "Bundle",
  "id": "041a1b5c-87b7-482c-8c80-637965d2d4bb",
  "meta": {
    "lastUpdated": "2020-10-23T20:29:25.663+00:00"
  },
  "type": "searchset",
  "total": 1,
  "link": [ {
    "relation": "self",
    "url": "http://hapi.fhir.org/baseR4/DocumentReference?_count=1&_sort=-period&patient=06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b&type=34117-2"
  } ],
  "entry": [ {
    "fullUrl": "http://hapi.fhir.org/baseR4/DocumentReference/cdex-HP-example1",
    "resource": {
      "resourceType": "DocumentReference",
      "id": "cdex-HP-example1",
      "meta": {
        "versionId": "1",
        "lastUpdated": "2020-10-23T20:27:18.976+00:00",
        "source": "#XOrE2IwfLwl5C1RV",
        "profile": [ "http://hl7.org/fhir/us/core/StructureDefinition/us-core-documentreference" ]
      },
      "identifier": [ {
        "system": "urn:ietf:rfc:3986",
        "value": "urn:oid:2.16.840.1.113883.19.5.99999.2"
      } ],
      "status": "current",
      "type": {
        "coding": [ {
          "system": "http://loinc.org",
          "code": "34117-2",
          "display": "History & Physical Note"
        } ],
        "text": "History & Physical Note"
      },
      "category": [ {
        "coding": [ {
          "system": "http://hl7.org/fhir/us/core/CodeSystem/us-core-documentreference-category",
          "code": "clinical-note",
          "display": "Clinical Note"
        } ],
        "text": "Clinical Note"
      } ],
      "subject": {
        "reference": "Patient/06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b",
        "display": "Elden718 Halvorson124"
      },
      "date": "2020-10-23T10:21:08-07:00",
      "author": [ {
        "reference": "Practitioner/0000016f-57cb-cdac-0000-00000000014a",
        "display": "Janeth814 Jakubowski832, MD"
      } ],
      "description": "Pulmonology clinic acute visit",
      "content": [ {
        "attachment": {
          "contentType": "text/plain",
          "url": "/Binary/cdex-example-hpnote",
          "title": "Uri where the data can be found: [base]/Binary/1-note"
        },
        "format": {
          "system": "urn:oid:1.3.6.1.4.1.19376.1.2.3",
          "code": "urn:hl7-org:sdwg:ccda-structuredBody:2.1",
          "display": "Documents following C-CDA constraints using a structured body"
        }
      } ],
      "context": {
        "period": {
          "start": "2020-10-23T10:21:06-07:00",
          "end": "2020-10-23T10:21:08-07:00"
        }
      }
    },
    "search": {
      "mode": "match"
    }
  } ]
}
~~~

###### Step 2 - Fetch Document

**Request**
~~~
GET [base]/Binary/cdex-example-hpnote`
~~~

**Request Headers**

~~~
...(other headers)
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: nginx/1.14.0 (Ubuntu)
Date: Fri, 23 Oct 2020 22:02:15 GMT
Content-Type: application/pdf
...(other headers)
~~~

**Response Body = PDF**

<!--
<embed src="cdex-example-hpnote.pdf" type="application/pdf" frameborder = "1"/>
-->

<embed  type="application/pdf" frameborder="1" width="640" height="480" src="data:application/pdf;base64,{{site.data.cdex-example3-query-completed.contained[0].entry[0].resource.content[0].attachment.data}}"/>
