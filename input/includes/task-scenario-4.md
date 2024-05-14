
###### Step 1 - Subscribe to Task

The Payer subscribes to the Provider's Subscription endpoint to receive "id-only" notifications when submitted Tasks are completed. The subscription resource uses the canonical URL `http://hl7.org/fhir/us/davinci-cdex/ImplementationGuide/hl7.fhir.us.davinci-cdex` and the filter criteria `Task?status=completed,rejected`. The Provider accepts the Subscription and returns it in the response body with an "active" status. 

This operation is done once. To unsubscribe, the Payer deletes the Subscription from the server or nominates a fixed end date, and the server automatically deletes it at the specified time.


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


###### Step 2 - POST Task to Provider endpoint


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




###### Step 3 - Receive Notification

When the task status is "completed", it triggers a notification to the Payer. As defined in the [Subscription R5 Backport Implementation Guide], the notification is a *history Bundle*. The first entry of the bundle is a Parameters resource that communicates the subscription status information. In addition to the subscription status information, Task IDs are listed in the "focus" part parameter.


**Post From EHR**

~~~

Post http://example.org/FHIR/Payer/cdex-task-watch

~~~

{% include request-headers.md %}


**Request Body**

~~~
{% include_relative Bundle-cdex-task-inline-scenario1-subscription-notification.json %}
~~~

{% include response-headers.md %}


###### Step 4 - Fetch Task

Fetch the Task using the Task id returned in the subscription notification in step 3.

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


###### Step 5 - Fetch Task Output

Fetch the resources referenced in the `Task.output` from the Task returned in step 4.


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