#### Scenario

Payer A Seeks Insured Person/Patient B's Active Conditions from Provider C to confirm medical necessity.

##### Preconditions and Assumptions:
- The Appropriateness of the request needs to be determined or access to the data is limited
- No formal authorization (order) is needed

In this situation, there is human involvement needed to approve the release of the data:

Following the guidance in this guide and HRex, Getting Active Conditions from Provider is typically a two or three step process:

1. The Payer POSTS a Task to the Provider endpoint requesting Patient B's Active Conditions.  This can be done using agreed upon codes or with natural language text.  (In the example below, text is used.)
2. The Payer then subsequently polls the Task resource until the `Task.status` indicates it is completed or rejected.
3. When the task is complete, the Payer fetches the data of interest which is referenced by `Task.output`.  It can either refer to a 'contained' search set Bundle - because the Bundle isn't something that would have any independent existence or to external resources which are subsequently fetched by the Payer use a RESTful GET.

##### Example:

###### Step 1 - POST Task to Provider endpoint

**Request**
~~~
POST [base]/Task
~~~

**Request Headers**

~~~
Accept: application/fhir+json
Content-Type: application/fhir+json
...(other headers)
~~~

**Request Body**

~~~

~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: nginx/1.14.0 (Ubuntu)
Date: Fri, 23 Oct 2020 04:54:56 GMT
Content-Type: application/fhir+json;charset=utf-8
...(other headers)
~~~

**Response Body**

~~~

~~~

###### Step 2 - Poll for Updates to Task

**Request**
~~~
POST [base]/Task
~~~

**Request Headers**

~~~
Accept: application/fhir+json
Content-Type: application/fhir+json
...(other headers)
~~~

**Request Body**

~~~

~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: nginx/1.14.0 (Ubuntu)
Date: Fri, 23 Oct 2020 04:54:56 GMT
Content-Type: application/fhir+json;charset=utf-8
...(other headers)
~~~

**Response Body**

~~~

~~~

###### Step 3 - Fetch Active Conditions (if not contained in the Task)

**Request**
~~~
POST [base]/Task
~~~

**Request Headers**

~~~
Accept: application/fhir+json
Content-Type: application/fhir+json
...(other headers)
~~~

**Request Body**

~~~

~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: nginx/1.14.0 (Ubuntu)
Date: Fri, 23 Oct 2020 04:54:56 GMT
Content-Type: application/fhir+json;charset=utf-8
...(other headers)
~~~

**Response Body**

~~~

~~~
