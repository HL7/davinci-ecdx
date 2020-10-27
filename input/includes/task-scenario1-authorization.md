
##### Example 5:

Note: Formal authorization is optional - and won't be typical
{:.bg-info}

In this example:

1. The Payer creates a CommunicationRequest formally authorizing information to be gathered on Patient B.
1. The Payer POSTS a Task to the Provider endpoint, the CommunicationRequest is referenced in `Task.basedOn`
1. The Provider fetches and inspects the CommunicationRequest to review the authorization.  
1. The Payer polls the Task resource until the `Task.status` indicates it is completed or rejected.
1. The Payer fetches Patient B's Active Conditions referenced by `Task.output` as *external* resources.

###### Step 1 - Create CommunicationRequest (on Payer system)

~~~
{% include cdex-example1-authorization.json %}
~~~

###### Step 2 - POST Task to Provider endpoint

**Request**
~~~
POST [base]/Task
~~~

{% include request-headers.md %}

**Request Body**

~~~
{% include cdex-example1-authorized-request.json %}
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: CDEX Example Server
Location: http://example.org/FHIR/Task/cdex-example1-query-completed/_history/1
...(other headers)
~~~

###### Step 3 - (Optional) Provider Fetches CommunicationRequest

**Request from Provider**
~~~
POST [base]CommunicationRequest/cdex-example1-authorization
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include cdex-example1-authorization.json %}
~~~

###### Step 4 - Repeatedly Poll until Task.status is updated to "completed"

**Polling Request**
~~~
GET Task/cdex-example1-query-completed
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include_relative Task-cdex-example1-authorized-completed.json %}
~~~

###### Step 5 - Fetch Active Conditions

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
