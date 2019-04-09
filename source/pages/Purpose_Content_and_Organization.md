---
title: Purpose Content and Organization
layout: default
active: Purpose Content and Organization
---

The implementation guide is organized into the following sections:

* **Introduction**: describes the HL7 FHIR standard, and explains the content covered in this implementation guide (IG) and how it is organized to help payers understand how to access and use the specification. It also identifies other supporting specifications that are utilized to address the use cases covered in this IG.
* **Use Case Scenarios**: describes specific information exchange scenarios that are covered by the CDex IG and demonstrates steps and information exchange mechanisms employed to accomplish the data exchange required for each use case. Each use case includes one or more variants to demonstrate different exchange interactions that may be used to accomplish the information sharing objective of the use case.  Each use case variant defines the technical roles (actors) played by systems involved in the information exchange, explains the steps involved with any preconditions or post conditions defined, and provides a sequence diagram illustration to show the flow of information in the exchange. Details about the content payloads are explained in the CDex Profiles and Extensions chapter. Details about the interaction mechanisms are defined in the Information Exchange Interactions chapter. Details about CDS-Hooks used to trigger activity are described in the CDS-Hooks chapter.
* * **CDex Profiles and Extensions**: introduces and provides links to the FHIR R4, STU3 and DSTU2 profiles, search parameters and other FHIR artifacts used in this implementation guide as well as in the Health Record exchange IG. It provides the technical conformance details for profiles that are defined within and used only by the CDex IG. 
* **Information Exchange Interactions**: describes how each information exchange interaction is implemented in FHIR. Readers will be directed to reference documentation in the HRex IG for  information about interactions fully defined in that guide. 
* **CDS-Hooks**: describes any CDS-Hook mechanisms used in the information exchange.
* **Credits**: identifies the individuals and organizations involved in developing this implementation guide