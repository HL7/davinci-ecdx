
**Request**
~~~
GET [base]/Condition?patient=06e1f0dd-5fbe-4480-9bb4-6b54ec02d31b&clinical-status=active,recurrance,remission
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
Date: Fri, 23 Oct 2020 04:54:56 GMT
Content-Type: application/fhir+json;charset=utf-8
...(other headers)
~~~

**Response Body**

~~~
{% include_relative Bundle-cdex-searchbundle-scenario1-example.json %}
~~~
