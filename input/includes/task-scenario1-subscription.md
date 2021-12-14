
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

###### Step 2 - Subscribe to Task

**Request**
~~~
Post [base]/Subscription
~~~

{% include request-headers.md %}

**Request Body**

~~~
{% include task-scenario1-subscription-requested.json %}
~~~

~~~
HTTP/1.1 200 OK
Server: CDEX Example Server
Location: http://example.org/FHIR/Subscription/cdex-example1-query-subscription/_history/1
...(other headers)
~~~

**Response Body**

~~~
{% include task-scenario1-subscription-active.json %}
~~~

###### Step 3 - Receive Notification

**Post From EHR**
~~~
Post http://example.org/FHIR/Payer/cdex-task-watch
~~~
{% include request-headers.md %}

** No Request Body**

{% include response-headers.md %}

###### Step 4 - Fetch Task

**Request**
~~~
GET [base]Task/cdex-example1-query-completed
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{% include_relative Task-cdex-example1-query-completed.json %}
~~~

###### Step 5 - Fetch Active Conditions

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

###### Step 6 - Delete subscription

**Request**
~~~
DELETE [base]Subscription/task-scenario1-subscription-active
~~~

{% include request-headers.md %}

**Response Headers**

~~~
HTTP/1.1 204 No Content
Connection: keep-alive
Content-Type: text/plain; charset=ISO-8859-1
...(other headers)
~~~
