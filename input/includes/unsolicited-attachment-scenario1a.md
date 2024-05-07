
**Request**

~~~
POST [base]/$submit-attachment
~~~

**Request Headers**

~~~
Accept: application/fhir+json
Content-Type: application/fhir+json
...(other headers)
~~~

**Request Body**

~~~
{% include_relative Parameters-cdex-parameters-example1.json %}
~~~

**Response Headers**

~~~
HTTP/1.1 200 OK
Server: nginx/1.14.0 (Ubuntu)
Date: Fri, 23 Oct 2020 04:54:56 GMT
Content-Type: application/fhir+json;charset=utf-8
...(other headers)
~~~

##### Rendered Documents

*This is the default view using a HTML5 browser. The content may not render correctly in HTML 4.0 and older browsers. Typically a CCDA stylesheet is used to make this data easier to read and arrange according to provider preferences*

<embed  type="text/html" frameborder="1" width="640" height="480" src="data:text/html;base64,{{site.data.cdex-parameters-example1.parameter[7].part.[4].resource.content[0].attachment.data}}"/>