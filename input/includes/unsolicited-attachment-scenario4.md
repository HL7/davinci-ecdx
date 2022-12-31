
**Request**

~~~
POST [base]/$submit-attachment
~~~

**Request Headers**

~~~
Accept: application/fhir+json
Content-Type: application/fhir+json
...(other headers)
~~~

**Request Body**

~~~
{% include cdex-parameters-example1.json %}
~~~

**Response Headers**

~~~
  HTTP/1.1 400 Bad Request
  [other headers]
~~~

**Response Body**

~~~
  {
    "resourceType": "OperationOutcome",
    "id": "1672516634680",
    "issue": [
  {
    "severity": "error",
    "code": "business-rule",
    "details": {
      "text": "This health care attachments transactions requires a digital signature"
    },
    "diagnostics": "Resubmit with valid digital signature"
  }
    ]
  }
~~~
