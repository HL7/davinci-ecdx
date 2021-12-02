
##### Example 2P:

In this example:

1. No formal authorization (order) is needed
1. The Payer POSTS a Task to the Provider endpoint requesting Patient B's Active Conditions and all associated Provenance.  For the actual request, *natural language free text* is used.
2. The Payer polls the Task resource until the `Task.status` indicates it is completed, rejected, or failed.
3. The Payer fetches Patient B's Active Conditions referenced by `Task.output` as *external* resources.

###### Step 1 - POST Task to Provider endpoint

**Request**
~~~
POST [base]/Task
~~~

{% include request-headers.md %}

**Request Body**

~~~
{% include cdex-example1p-free-text-request.json %}
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: CDEX Example Server
Location: http://example.org/FHIR/Task/cdex-example1-free-text-completed/_history/1
...(other headers)
~~~

###### Step 2 - Poll Task

**Polling Request**
~~~
GET Task/cdex-example1-free-text-completed
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include_relative Task-cdex-example1p-free-text-completed.json %}
~~~

###### Step 3 - Fetch Active Conditions and Their Provenance

(Note this step could be done using a single [batch] interaction as well)

**Request**
~~~
GET [base]Condition/858
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include condition-858.json %}
~~~

**Request**
~~~
GET [base]Provenance/858
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include provenance-858.json %}
~~~


{% include 'link-list.md' %}
