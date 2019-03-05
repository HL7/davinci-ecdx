---
title: Structured and Unstructured Documents
layout: default
active: Structured and Unstructured Documents
---

## Definitions of Structured Document and Unstructured Document
The terms "structured document" and "unstructured document" apply to both CDA documents and FHIR documents.

In CDA, a document with a header paired with a structuredBody element is referred to as a CDA structured document. A header paired with a nonXMLBody element is referred to as an CDA unstructured document. It is important to note that the header in either structured or unstructured document is always structured, and as such, provides valuable data for computer processing (parsing) to occur. 

In FHIR, an unstractured document is represented using the DocumentReference resource to hold the structured header information associated with the document.  An attachment element within the DocumentReference holds or points to the the document content which is stored as encoded data.

## Bundles, Compositions and DocumentReferences
In FHIR, a Bundle with type=Document is used to represent the actual content of a document. 

[ToDo Rick] 
When working with information organized as documents, FHIR implementations may include a DocumentReference resource for structured documents as well as unstructured documents. This practice enables the DocumentReference resource to serve as a document index and facilitates searching for all document location information available via a FHIR API.

## Structured Content
Each CDA Implementation Guide for Attachments describes the respective document types and
conformance requirements for each of the Structured Documents listed in Appendix C: CDA R2.1 and
Appendix D: CDP1 R1.1. Conformance criteria for each of those document types, their sections and any applicable entries are found in the appropriate section of the CDA Implementation Guides for Attachments.

## Unstructured Content
In addition to the clinical document types described in Appendix C: CDA R2.1 and Appendix D: CDP1 R1.1 for Structured Documents, there is an Unstructured Document (described specifically in the C-CDA R2.1) which is available to be used for exchange of ANY clinical document type.

Unstructured documents fill an important role where structured information is inappropriate, impractical, or otherwise unavailable.

Use of the unstructured document is intended to accommodate attachment types for which a structured
format hasnt been developed (e.g., new policies) or is not supported by the sender. Clinical document types that are supported as Structured Documents may also be sent in an unstructured format (e.g., History and Physical Scanned Image, Discharge Summary PDF).

[TODO - add link]
Refer to About Code Systems for appropriate Document Type Codes.

The following table reflects the value set of the file formats supported by unstuctured documents
in C-CDA.

### Supported File Formats in C-CDA Unsturctured Documents
Value Set: SupportedFileFormats 2.16.840.1.113883.11.20.7.1
A value set of the file formats supported by the Unstructured Document Template.
Code Code System Code System OID Print Name
application/msword Media Type 2.16.840.1.113883.5.79 MSWORD
application/pdf Media Type 2.16.840.1.113883.5.79 PDF
text/plain Media Type 2.16.840.1.113883.5.79 Plain Text
text/rtf Media Type 2.16.840.1.113883.5.79 RTF Text
text/html Media Type 2.16.840.1.113883.5.79 HTML Text
image/gif Media Type 2.16.840.1.113883.5.79 GIF Image
image/tiff Media Type 2.16.840.1.113883.5.79 TIF Image
image/jpeg Media Type 2.16.840.1.113883.5.79 JPEG Image
image/png Media Type 2.16.840.1.113883.5.79 PNG Image

### Supported File Formats in C-CDA Unsturctured Documents
[ToDo: add a table with the corresponding FHIR Value Set and concepts