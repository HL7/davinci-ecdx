
##### Example:

In this example:

1. No formal authorization (order) is needed
1. The Payer POSTS a Task to the Provider endpoint requesting Patient B's Active Conditions.  For the actual request, the FHIR RESTful query syntax is used.
2. The Payer polls the Task resource until the `Task.status` indicates it is completed, rejected, or failed.
3. The Patient B's Documents referenced by Task.output are *contained* resources and the actual documents are base64 pdf files in the `DocumentReference.content.attachment.data` elements. By polling the Task, the Payer already has the data when the Task is completed and there is no need to perform an additional RESTful GET to fetch them. A Document from the resource is rendered below.

###### Step 1 - POST Task to Provider endpoint

**Request**
~~~
POST [base]/Task
~~~

{% include request-headers.md %}

**Request Body**

~~~
{% include cdex-example3-query-request.json %}
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: CDEX Example Server
Location: http://example.org/FHIR/Task/cdex-example3-query-completed/_history/1
...(other headers)
~~~

###### Step 2 - Poll Task

**Polling Request**
~~~
GET [base]Task/cdex-example3-query-completed
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include_relative Task-cdex-example3-query-completed.json %}
~~~

###### Step 3 - Rendered Documents

<embed  type="application/pdf" frameborder="1" width="640" height="480" src="data:application/pdf;base64,{{site.data.cdex-example3-query-completed.contained[0].entry[0].resource.content[0].attachment.data}}"/>
