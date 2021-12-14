##### Example 1s:

In this example:

1. {{ site.data.base-example-list[0] }}
1. {{ site.data.base-example-list[1] }}
1. {{ site.data.base-example-list[2] }}
1. {{ site.data.base-example-list[3] }}
1. {{ site.data.base-example-list[4] }}
1. {{ site.data.base-example-list[5] }}
1. {{ site.data.base-example-list[6] }}
1. **The Payer requires signatures on the returned data**

###### Step 1 - POST Task to Provider endpoint

**Request**
~~~
POST [base]/Task
~~~

{% include request-headers.md %}

**Request Body**

~~~
{%raw%}{%gist %}{%endraw%}
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: CDEX Example Server
Location: http://example.org/FHIR/Task/cdex-example1-query-completed/_history/1
...(other headers)
~~~

###### Step 2 - Poll Task

**Polling Request**
~~~
GET Task/cdex-example1-query-completed
~~~

{% include request-headers.md %}

{% include response-headers.md %}

**Response Body**

~~~
{%raw%}{%gist %}{%endraw%}
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
{%raw%}{%gist %}{%endraw%}
~~~
