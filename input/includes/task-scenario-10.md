


#### Step 1 - POST Task to Provider endpoint


**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include cdex-task-example26.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example26/_history/1

...(other headers)

~~~

#### Step 2 - Provider Invokes DTR To Complete Questionnaire

If the Provider Launches DTR as a SMART on FHIR Application in SMART’s EHR launch flow, proceed to step 3
If the Provider launches a DTR within an EHR native application, skip to step 7

#### Step 3 - DTR App Fetches Task

**Request**

~~~

GET [base]/Task/cdex-task-example26

~~~

**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example26/_history/1

...(other headers)

~~~

**Response Body**


~~~

{% include cdex-task-example26-currentid.json %}

~~~

#### Step 4 - DTR App Inspects Task for Questionnaire URL and fetches the "Questionnaire Package"


**Request**

~~~

GET http://example.org/FHIR/Questionnare/cdex-questionnaire-example1

~~~

**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Questionnare/cdex-questionnaire-example1

...(other headers)

~~~

**Response Body**


~~~

{% include cdex-questionnaire-example1.json %}

~~~


{% include request-headers.md %}

#### Step 5 - DTR App Fills QuestionnaireResponse

{% include img-small.html img='fill-form-icon.svg' %}


#### Step 6 - DTR App POSTs QuestionnaireResponse to Provider FHIR Server

**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include cdex-questionnaireresponse-example1.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-questionnaireresponse-example1/_history/1

...(other headers)

~~~

#### Step 7 -  The DTR SMART App or EHR native application Updates Task.output to Reference QuestionnaireResponse and Task.status Updated to "completed"

**Request**

~~~

PUT [base]/Task/cdex-task-example-26

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include cdex-task-example27-updateid.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example26/_history/2

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

{% include cdex-task-example27-updateid.json %}

~~~


###### Step 3 - Fetch QuestionnaireResponse


**Request**

~~~

GET [base]QuestinnaireResponse/cdex-questionnaireresponse-example1
~~~


{% include request-headers.md %}


{% include response-headers.md %}


**Response Body**


~~~

{% include cdex-questionnaireresponse-example1.json %}

~~~

####  [Rendered QuestionnaireResponse](http://hl7.org/fhir/us/davinci-cdex/STU2/QuestionnaireResponse-cdex-questionnaireresponse-example1.html)
