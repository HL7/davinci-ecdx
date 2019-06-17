---
title: Profiles and Extensions
layout: default
active: Profiles and Extensions
---

[Previous Page](CDex_Track_Referrals_and_Orders.html)

## Profiles Defined in CDex and Profiles Used by Reference

The CDex implementation guide defines only a few new FHIR profiles and extensions that are specific to this guide.  The CDex specific Profiles include:
* CDex CommunicationRequest - describes information being requested, or optionally describes an actionable communication request to be fulfilled.
* CDex Communication - describes information being provided
* CDex SearchSet Bundle - contains a set of data resources
* CDex Document Bundle - contains a persisted structured document
* CDex Composition (Rick todo) - represents a structured document
* CDex Task (Lloyd todo) - describes a fullfill task used to ask a system to fulfill a communication request.

The CDex specific extensions include:
* CDex Payload Type Code - describes a type of document being requested or communicated
* CDex Payload Search String - describes a data query to be fulfilled or that was fulfilled

The majority of the content profiles, extensions, and information exchange mechanisms used by the CDex implementation guide are incorporated by reference from the broader HRex implementation guide and from other FHIR implementation guides including:
* HRex Implementation Guide - defines profiles and extensions used across the CDex and PDex (Provider Data Exchange) use cases. 
For a more detailed description of the <a href="https://build.fhir.org/ig/HL7/davinci-ehrx/HRex_Interactions.html">profiles used by reference</a>, consult the HRex implementation guide.
* US Core R4 and STU3, Argonaut DSTU2 - define data payload profiles for FHIR R4, FHIR STU3, and FHIR DSTU2
* C-CDA on FHIR for R4 and STU3 - defines structured document payloads for FHIR R4 and FHIR STU3

[Next Page](CDex_Profiles_and_Extensions.html)