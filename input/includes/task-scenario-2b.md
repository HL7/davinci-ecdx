

##### Step 1 - POST Task to Provider endpoint


**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include cdex-task-example21.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Server

Location: http://example.org/FHIR/Task/cdex-task-example7/_history/1

...(other headers)

~~~


##### Step 2 - Poll Task


**Polling Request**

~~~

GET [base]Task/cdex-task-example8

~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~

{% include_relative Task-cdex-task-example8.json %}

~~~


##### Step 3 - Rendered Documents


<embed  type="application/xml" frameborder="1" width="640" height="480" src="data:application/xml;base64,{{site.data.cdex-task-example8.contained[0].entry[0].resource.content[0].attachment.data}}"/>

