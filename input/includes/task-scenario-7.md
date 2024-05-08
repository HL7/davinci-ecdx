

##### Step 1 - POST Task to Provider endpoint


**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include_relative Task-cdex-task-inline-example17.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Server

Location: http://example.org/FHIR/Task/cdex-task-example18/_history/1

...(other headers)

~~~


##### Step 2 - Poll Task


**Polling Request**

~~~

GET Task/cdex-task-example18

~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~

{% include_relative Task-cdex-task-example18.json %}

~~~


##### Step 3 - Fetch Signed FHIR Document


**Request**

~~~

GET [base]Bundle/cdex-electronic-sig-example

~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~

{% include_relative Bundle-cdex-document-digital-sig-example.json %}

~~~


