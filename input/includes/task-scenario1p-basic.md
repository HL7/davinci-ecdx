
##### Step 1 - POST Task to Provider endpoint

**Request**
~~~
POST [base]/Task
~~~

{% include request-headers.md %}

**Request Body**

~~~
{% include cdex-example1p-query-request.json %}
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: CDEX Example Server
Location: http://example.org/FHIR/Task/cdex-example1-query-completed/_history/1
...(other headers)
~~~

##### Step 2 - Poll Task

**Polling Request**
~~~
GET Task/cdex-example1p-query-completed
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include_relative Task-cdex-example1p-query-completed.json %}
~~~

##### Step 3 - Fetch Bundle

**Request**
~~~
GET [base]Bundle/858p
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include bundle-858p.json %}
~~~
