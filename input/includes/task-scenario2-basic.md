
##### Example:

In this example:

1. No formal authorization (order) is needed
1. The Payer POSTS a Task to the Provider endpoint requesting Patient B's recent HbA1c test results.  For the actual request, the FHIR RESTful query syntax is used.
1. The Payer polls the Task resource until the `Task.status` indicates it is completed or rejected.
1. **In this example there is no matching data**.

###### Step 1 - POST Task to Provider endpoint

**Request**
~~~
POST [base]/Task
~~~

{% include request-headers.md %}

**Request Body**

~~~
{% include cdex-example2-query-request.json %}
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: CDEX Example Server
Location: http://example.org/FHIR/Task/cdex-example2-query-completed/_history/1
...(other headers)
~~~

###### Step 2 - Repeatedly Poll until Task.status is updated to "completed"

**Polling Request**
~~~
GET Task/cdex-example2-query-failed
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include_relative Task-cdex-example2-query-completed.json %}
~~~
