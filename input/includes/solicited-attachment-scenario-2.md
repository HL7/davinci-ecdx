


#### Step 1 - POST Task to Provider endpoint


**Request**

~~~

POST [base]/Task

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include_relative Task-cdex-task-inline-example22.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example22/_history/1

...(other headers)

~~~

#### Step 2 - Provider Invokes DTR To Complete Questionnaire

If the Provider Launches DTR as a SMART on FHIR Application in SMART’s EHR launch flow, proceed to step 3
If the Provider launches a DTR within an EHR native application, skip to step 7

#### Step 3 - DTR App Fetches Task

**Request**

~~~

GET [base]/Task/cdex-task-example22

~~~

**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example22/_history/1

...(other headers)

~~~

**Response Body**


~~~

{% include_relative Task-cdex-task-example22.json %}

~~~

#### Step 4 - DTR App Inspects Task for Questionnaire Canonical URL and fetches the "Questionnaire"


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

{% include_relative Questionnaire-cdex-questionnaire-example1.json %}

~~~

#### Step 5 - DTR App Fills QuestionnaireResponse

{% include img-small.html img='fill-form-icon.svg' %}


#### Step 6 - DTR App POSTs QuestionnaireResponse to Provider FHIR Server

**Request**

~~~

POST [base]/QuestionnaireResponse

~~~


{% include request-headers.md %}


**Request Body**


~~~

{% include_relative QuestionnaireResponse-cdex-questionnaireresponse-example1.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/QuestionnaireResponse/cdex-questionnaireresponse-inline-example1/_history/1

...(other headers)

~~~

#### Step 7 -  The DTR SMART App or EHR native application Updates Task.output to Reference QuestionnaireResponse

**Request**

~~~

PUT [base]/Task/cdex-task-example-22

~~~


{% include request-headers.md %}


**Request Body**

~~~

{% include cdex-task-inline-example22-updated.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Provider Server

Location: http://example.org/FHIR/Task/cdex-task-example22/_history/2

...(other headers)

~~~

#### Step 8 - EHR Updates Task Status To "completed" When Questionnaire Response Status Is "completed" (Not Shown).

#### Step 9 - EHR POSTs `$submit-attachment` Operation to Payer endpoint



**Request**


~~~

POST [base]/$submit-attachment

~~~


**Request Headers**


{% include request-headers.md %}


**Request Body**


~~~

{% include_relative Parameters-cdex-parameters-example5.json %}

~~~


**Response Headers**


~~~

HTTP/1.1 200 OK

Server: CDEX Example Payer Server

Content-Type: application/fhir+json;charset=utf-8

...(other headers)

~~~


####  [Rendered QuestionnaireResponse](http://hl7.org/fhir/us/davinci-cdex/STU2/QuestionnaireResponse-cdex-questionnaireresponse-example1.html)
