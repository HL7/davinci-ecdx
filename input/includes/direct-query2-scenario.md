
**Request**
~~~
GET [base]/Observation?patient=06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b&code=4548-4&date=gt2020-01-01
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
{% include_relative Bundle-cdex-searchbundle-scenario2-example.json %}
~~~
