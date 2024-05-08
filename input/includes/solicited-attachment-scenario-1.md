


#### Step 1 - POST Task to Provider endpoint


**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include_relative Task-cdex-task-inline-example19.json %}

~~~

**Response Headers**

~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example19/_history/1

...(other headers)

~~~


#### Step 2 - HIT/EHR Gathers Requested Information

{% include img-small.html img='gather-data-icon.svg' %}

#### Step 2 - POST $submit-attachment Operation to Payer endpoint

**Request**


~~~

POST [base]/$submit-attachment

~~~


**Request Headers**


{% include request-headers.md %}


**Request Body**


~~~

{% include_relative Parameters-cdex-parameters-example3.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Payer Server

Content-Type: application/fhir+json;charset=utf-8

...(other headers)

~~~


#####  Rendered Documents


<embed  type="application/pdf" frameborder="1" width="640" height="480" src="data:application/pdf;base64,{{site.data.cdex-parameters-example3.parameter[7].part.[2].resource.content[0].attachment.data}}"/>