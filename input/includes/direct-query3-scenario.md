
**Step 1 - Search for DocumentReference**

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
{% include_relative Bundle-cdex-searchbundle-scenario3-example.json %}
~~~

**Step 2 - Fetch Document**

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

<embed  type="application/pdf" frameborder="1" width="640" height="480" src="data:application/pdf;base64,{{site.data.cdex-task-example7.contained[0].entry[0].resource.content[0].attachment.data}}"/>
