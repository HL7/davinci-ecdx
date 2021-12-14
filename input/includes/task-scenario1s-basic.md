
##### Example 1s:

In this example:

1. **The Payer requires signatures on the returned data**
1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[1] }}
1. {{ site.data.base-example-list[2] }}
1. {{ site.data.base-example-list[3] }}
1. {{ site.data.base-example-list[4] }}
1. {{ site.data.base-example-list[5] }}
1. The Payer fetches Patient B’s Active Conditions referenced by Task.output as a *FHIR Document*.

###### Step 1 - POST Task to Provider endpoint

**Request**
~~~
POST [base]/Task
~~~

{% include request-headers.md %}

**Request Body**

~~~
{% include cdex-example1s-query-request-withsig.json %}
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: CDEX Example Server
Location: http://example.org/FHIR/Task/cdex-example1s-query-completed/_history/1
...(other headers)
~~~

###### Step 2 - Poll Task

**Polling Request**
~~~
GET Task/cdex-example1-query-completed
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include_relative Task-cdex-example1s-query-completed.json %}
~~~

###### Step 3 - Fetch Signed FHIR Document

**Request**
~~~
GET [base]Bundle/cdex-electronic-sig-example
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include_relative Bundle-cdex-electronic-sig-example.json %}
~~~
