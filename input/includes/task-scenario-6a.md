

##### Step 1 - POST Task to Provider endpoint


**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include cdex-task-example13.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Server

Location: http://example.org/FHIR/Task/cdex-task-example5/_history/1

...(other headers)

~~~


##### Step 2 - Poll Task


**Polling Request**

~~~

GET Task/cdex-task-example14

~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~

{% include_relative Task-cdex-task-example14.json %}

~~~


##### Step 3 - Fetch Active Conditions and Their Provenance


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


{% include link-list.md %}


