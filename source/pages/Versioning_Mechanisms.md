---
title: Versioning Mechanisms
layout: default
active: Versioning Mechanisms
---

[Previous Page](Base64_Encoded_Content.html)

## Document Succession
Document succession management is required to permit updates to previously created documents. 

### Document Succession in C-CDA
In C-CDA, the US Realm Header template provides for two elements (setID and version) that permits the document creator to specify the document set (e.g., the Progress Note) and the version of the Progress Note for the same patient for the same visit. 

The recipient of the document must recognize the setID and version in the Header and have processes in place to manage the versioning of the document. This version management may be accomplished by any of the following:
1. Maintain version control - keep both versions and use them appropriately (e.g., compare the
documents to identify changes).
2. Supersede the prior version - replace the prior version with the new version
3. Ignore the newer version based on specific policy (e.g., decision already made based on prior
submission)

### Document Succession in C-CDA on FHIR
For FHIR Documents,  the Composition Resource includes a RelatesTo field that functions the same way that ClinicalDocument/relatedDocument functions in C-CDA.  However, in FHIR you can do a restful reference to the document being replaced or appended.

## Data Succession
CDA was designed to exchange information where the "unit of exchange" was a document. For that reason, it does not address how to represent or facilitate versioning of individual elements of the data which may comprise the document. FHIR on the other hand supports mechanisms for versioning individual data resources. 

In FHIR there are 3 different type of versioning that may be relevant for a resource:

* The Record Version: changes each time the resource changes (usually managed by a server)
* The Business version: changes each time the content in the resources changes (managed by a human author or by business policy)
* The FHIR Version: the version of FHIR in which the resource is represented (controlled by the author of the resource)

See the FHIR documentation for more information about <a href="http://hl7.org/FHIR/resource.html#metadata">Resource versioning.</a>




[Next Page](Code_Systems_-_Value_Sets_-_Request_Codes_and_Response_Codes.html)