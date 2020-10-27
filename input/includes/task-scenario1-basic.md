
##### Example 1:

In this example:

1. No formal authorization (order) is needed
1. The Payer POSTS a Task to the Provider endpoint requesting Patient B's Active Conditions.  For the actual request, the FHIR RESTful query syntax is used.
2. The Payer polls the Task resource until the `Task.status` indicates it is completed or rejected.
3. The Payer fetches Patient B's Active Conditions referenced by `Task.output` as *external* resources.

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

###### Step 2 - Repeatedly Poll until Task.status is updated to "completed"

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

###### Step 3 - Fetch Active Conditions

**Request**
~~~
POST [base]Condition/858
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include condition-858.json %}
~~~
