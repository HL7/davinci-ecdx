
###### Step 1 - POST Task to Provider endpoint


**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include cdex-task-example1.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Server

Location: http://example.org/FHIR/Task/cdex-task-example2/_history/1

...(other headers)

~~~


###### Step 2 - Poll Task


**Polling Request**

~~~

GET Task/cdex-task-example2

~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~

{% include_relative Task-cdex-task-example2.json %}

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

