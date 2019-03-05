---
title: Versioning Mechanisms
layout: default
active: Versioning Mechanisms
---

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
[ToDo]

## Data Succession
CDA was designed to exchange information where the "unit of exchange" was a document. For that reason, it does not address how to represent of facilitate versioning of individual elements of the data which may comprise the document. FHIR on the other hand supports mechanisms for versioning individual data resources. 


