---
title: Examples
layout: default
active: Examples
---

[Previous Page](Credits.html)

## Pull (Get) Examples
The examples below show RESTful queries that utilize a standard FHIR API that conforms to the CDex Implementation Guide to exchange clinical information. The examples show queries for specific data elements or specific types of data. They also show queries that utilize the FHIR DocumentReference resource to find a patient's available documents and then retrieve just the documents or document that is needed.

### Pull (Get) for Data Queries
The following example shows a query for all Condition resources associated with the Patient resource where Patient.id=cdex-example-patient on the FHIR server "example.org/fhir". 

`http://example.org/fhir/Condition?patient=cdex-example-patient`

### Pull (Get) for Document Queries
The following example shows a query for all DocumentReference resources where DocumentReference.type contains the LOINC code "34117-2" on the FHIR server "example.org/fhir". 

`http://example.org/fhir/DocumentReference?type=http://loinc.org|34117-2`

## Request (Solicited Communication) Examples
The examples below show the exchange of an actionable CommunicationRequest coming from a Payer's system to an EHR system to request clinical information for the purpose of care management, and the Communication that is returned from the EHR system to the Payer, based on the request. The examples show queries for specific data elements or specific types of data. They also show a request for a specific type of document. 

The solicited communication requesting data uses a transaction bundle. The transaction bundle encompasses multiple resources needed to express the request.Resources carrying information about the requester organization and that organization's information processing endpoint are included in the transaction bundle using a conditional create mechanism. The conditional create ensures these resources will be created on the receiving system if they do not yet exist.  This enables the returning communication to be sent to this specified destination. The CommunicationRequest resource is an actionable request for information. The receiving organization is expressed as a contained resource because it doesn't need to be created on the receiving system. The identifier identifies the request uniquely. The category indicates this is a data request. The subject is expressed as a conditional reference which builds in query parameters to find the correct patient on the receiving system. If the subject of the request is not found, the transaction will fail. The requester points to the conditionally created organization and its conditionally created endpoint.  This is the organization that will receive the requested information when it is returned. The recipient points to the contained resource expressing the organization being asked for information and the endpoint where the request was made. The sender points to the organization that is sending the request. This organization also should be included in the transaction bundle with a conditional create so that it will be created at the receiving system if it does not yet exist on the receiving system. In this example the sending organization also is the requester.     

After the receiving system processes the communication request, it returns information to the requester organization at the indicated endpoint. The Communication references the CommunicationRequest that this response is based on. The system receiving the communication is assumed to have captured the id of the CommunicationRequest when it was originally created on the recipient's system. The category indicates it is a solicited communication. The subject references the Patient resource which is included in the transaction bundle with a conditional create. If for some reason the sending system has additional or different information for the patient (for example, a newer or different address, or a medical record number the payer may want to use to make future communication requests easier to resolve) the conditional create ensures the receiving system gets that information. The receiving system is responsible for de-duplicating or updating their own patient information for this person. 

### Request (Solicited Communication) for Data

The payload(s) of the request show the use of the cdex-payload-query-string extension to express the data query the payer is requesting to have returned. The payload.valueString.value holds the query expression and the payload.contentString.value holds the human readable version of that query. 

<a href="CommunicationRequest-cdex-example-resource-request.html">cdex-example-resource-request</a>

The payload(s) of the communication indicates the query that was performed and includes the data being returned. The payload.contentAttachment.contentType.value indicates the format for the returned data. The CDex Implementation Guide permits the system processing the communication request to determine what information it will return in the solicited communication.
 
<a href="CommunicationRequest-cdex-example-resource-request.html">cdex-example-resource-request</a>

### Request (Solicited Communication) for Documents
The payload(s) of the request show the use of the cdex-payload-type-code extension to express the type of document the payer is requesting to have returned. The payload.valueCodeableConcept holds the LOINC code that describes the type of documentation. This can be a specific document type or a general document type.  When a general document type is requested, any more specific document of that same general type may be returned.  The payload.contentString.value holds human readable information indicating the type of document. 

<a href="CommunicationRequest-cdex-example-resource-request-response.html">cdex-example-resource-request-response</a>

The payload(s) of the communication indicates the type of document being returned and includes the document. The payload.contentAttachment.contentType.value indicates the format for the returned data. Again, the CDex Implementation Guide permits the system processing the communication request to determine what type of information it will return in the solicited communication. Even if the request indicates the type of document that is requested, the system may return a different type of document if the requested type is not available, or if the organization determines that a different type of document should be returned. It is the responsibility of the sending system to send the right format for the document, given the endpoint processing preferences of the receiving system.

<a href="Communication-cdex-example-solicited-attachment.html">cdex-example-solicited-attachment</a>

## Push (Unsolicited Communication) Examples
At any point in time, one system can push a communication to another system, including in the payload information that needs to be shared. The unsolicited communication may carry data or documents, The primary different between an unsolicited communication and a solicited communication is that the unsolicited communication is not based on a prior CommunicationRequestion. It is the responsibility of the sending system to send the right format for the document, given the endpoint processing preferences of the receiving system.

### Unsolicited Communication with Data Attachment

<a href="Communication-cdex-example-unsolicited-resource.html">cdex-example-unsolicited-resource</a>

### Unsolicited Communication with Document Attachment

<a href="Communication-cdex-example-unsolicited-attachment.html">cdex-example-unsolicited-attachment</a>

[Next Page](Value_Sets.html)