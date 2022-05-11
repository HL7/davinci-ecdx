
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
{% include cdex-unsolicited-attachment-example1-body.json %}
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: nginx/1.14.0 (Ubuntu)
Date: Fri, 23 Oct 2020 04:54:56 GMT
Content-Type: application/fhir+json;charset=utf-8
...(other headers)
~~~
