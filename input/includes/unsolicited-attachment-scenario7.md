
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
{% include_relative Parameters-cdex-parameters-example2.json %}
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
    "id": "submit-attachment-1672516533834,
    "issue": [
  {
    "severity": "error",
    "code": "business-rule",
    "details": {
      "text": "The signature cannot be verified because the certificate is expired"
    },
    "diagnostics": "Resubmit with valid digital signature"
  }
    ]
  }
~~~
