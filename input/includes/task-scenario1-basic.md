
##### Example 1:

In this example:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[1] }}
1. {{ site.data.base-example-list[2] }}
1. {{ site.data.base-example-list[3] }}
1. {{ site.data.base-example-list[4] }}
1. {{ site.data.base-example-list[5] }}
1. {{ site.data.base-example-list[6] }}
1. {{ site.data.base-example-list[7] }}

1. No formal authorization (order) is needed
3. The POU is to Support claim submission
4. The work queue hint is claim processing
5. The reason for the request is the referenced claim
6. The Payer POSTS a Task to the Provider endpoint requesting Patient B's Active Conditions.  For the actual request, the FHIR RESTful query syntax is used.
7. The Payer polls the Task resource until the `Task.status` indicates it is completed, rejected, or failed.
8. The Payer fetches Patient B's Active Conditions referenced by `Task.output` as *external* resources.

###### Step 1 - POST Task to Provider endpoint

**Request**
~~~
POST [base]/Task
~~~

{% include request-headers.md %}

**Request Body**

~~~
{% include cdex-example1-query-request.json %}
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: CDEX Example Server
Location: http://example.org/FHIR/Task/cdex-example1-query-completed/_history/1
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
{% include_relative Task-cdex-example1-query-completed.json %}
~~~

###### Step 3 - Fetch Bundle

**Request**
~~~
GET [base]Bundle/858
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include bundle-858.json %}
~~~
