
###### Step 1 - POST Task to Provider endpoint


**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~
{% include_relative Task-cdex-task-inline-example4.json %}
~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Server

Location: http://example.org/FHIR/Task/cdex-task-example5/_history/1

...(other headers)

~~~


###### Step 2 - Poll Task


**Polling Request**

~~~

GET Task/cdex-task-example5

~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~
{% include_relative Task-cdex-task-example5.json %}
~~~


###### Step 3 - Fetch Active Conditions


**Request**

~~~

GET [base]Condition/858

~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~
{% include_relative Condition-cdex-condition-inline-example-858.json %}
~~~


