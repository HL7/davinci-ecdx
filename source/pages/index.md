---
title: Implementation Guide HomePage
layout: default
active: home
---

<!-- { :.no_toc } -->

<!-- TOC  the css styling for this is \pages\assets\css\project.css under 'markdown-toc'-->

* Do not remove this line (it will not be displayed)
{:toc}

<!-- end TOC -->

### Description

The  CDex implementation guide defines combinations of exchange methods (push, pull, etc. ), specific payloads (Documents, Bundles, and Individual Resources), search criteria, conformance, provenance, and other relevant requirements to support the exchange of clinical information between provider and other providers and/or payers. The goal is to identify, document and constrain  specific exchange patterns so that providers and payers can reliably exchange information for patient care (including coordination of care), risk adjustment, quality reporting, identifying that requested services are necessary and appropriate (e.g. should be covered by the payer) and other uses that may be documented as part of this effort. Clinical data payloads will include C-CDA, C-CDA on FHIR, compositions, bundles, and discrete resources conforming to the US Core specification. 

Ultimately this IG is expected to support multiple versions of FHIR (DSTU2/Argonaught, STU3, and R4), but the current version of this IG only supports for FHIR R4. 

The implementation guide is organized into the following major sections:

* **[Introduction](Introduction.html)**: describes the HL7 FHIR standard, and explains the content covered in this implementation guide (IG) and how it is organized to help payers understand how to access and use the specification. It also identifies other supporting specifications that are utilized to address the use cases covered in this IG.
* **[Use Cases, Personas and Patient Story](Use_Cases,_Personas_and_Patient_Story.html)**: describes specific information exchange scenarios that are covered by the CDex IG and demonstrates steps and information exchange mechanisms employed to accomplish the data exchange required for each use case. Each use case includes one or more variants to demonstrate different exchange interactions that may be used to accomplish the information sharing objective of the use case.  Each use case variant defines the technical roles (actors) played by systems involved in the information exchange, explains the steps involved with any preconditions or post conditions defined, and provides a sequence diagram illustration to show the flow of information in the exchange. 
* **[CDex Profiles and Extensions](CDex_Profiles_and_Extensions.html)**: introduces and provides links to the supported profiles, search parameters and other FHIR artifacts used in this implementation guide as well as in the [Health Record Exchange IG](http://hl7.org/fhir/us/davinci-hrex/). It provides the technical conformance details for profiles that are defined within and used only by the CDex IG. 
* **[Information Exchange Interactions and Specifications](Information_Exchange_Interactions_and_Specifications.html)**: describes how each information exchange interaction is implemented in FHIR. Readers will be directed to reference documentation in the HRex IG for  information about interactions fully defined in that guide. 
* **[Credits](Credits.html)**: identifies the individuals and organizations involved in developing this implementation guide





### Authors

<table>
<thead>
<tr>
<th>Name</th>
<th>Email</th>
</tr>
</thead>
<tbody>
<tr>
<td>Lisa Nelson</td>
<td><a href="mailto:lnelson@maxmd.com">lnelson@maxmd.com</a></td>
</tr>
<tr>
<td>Rick Geimer</td>
<td><a href="mailto:rick.geimer@lantanagroup.com">rick.geimer@lantanagroup.com</a></td>
</tr>
</tbody>
</table>


