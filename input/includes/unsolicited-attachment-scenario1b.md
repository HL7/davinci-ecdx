
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
HTTP/1.1 200 OK
Server: nginx/1.14.0 (Ubuntu)
Date: Fri, 23 Oct 2020 04:54:56 GMT
Content-Type: application/fhir+json;charset=utf-8
...(other headers)
~~~

**Response Body**

~~~
{% include cdex-unsolicited-attachment-example1b-operationoutcome.json %}
~~~

##### Rendered Documents

<embed  type="application/xml" frameborder="1" width="640" height="480" src="data:application/xml;base64,{{site.data.cdex-parameters-example1.parameter[7].part.[4].resource.content[0].attachment.data}}"/>