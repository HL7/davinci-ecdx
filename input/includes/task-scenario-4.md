

###### Step 1 - POST Task to Provider endpoint


**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include_relative Task-cdex-task-inline-example1.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Server

Location: http://example.org/FHIR/Task/cdex-task-example2/_history/1

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

{% include_relative Subscription-cdex-task-inline-scenario1-subscription-requested.json %}

~~~


~~~

HTTP/1.1 200 OK

Server: CDEX Example Server

Location: http://example.org/FHIR/Subscription/cdex-example1-query-subscription/_history/1

...(other headers)

~~~


**Response Body**


~~~

{% include_relative Subscription-cdex-task-inline-scenario1-subscription-active.json %}

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

GET [base]Task/cdex-task-example2

~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~

{% include_relative Task-cdex-task-example2.json %}

~~~


###### Step 5 - Fetch Bundle


**Request**

~~~

GET [base]Bundle/cdex-searchbundle-scenario1-example

~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~

{% include_relative Bundle-cdex-searchbundle-scenario1-example.json %}

~~~