---
title: CDex Profiles and Extensions
layout: default
active: CDex Profiles and Extensions
---

[Previous Page](Profiles_and_Extensions.html)

## Profiles and Extensions Defined in CDex

### CDex CommunicationRequest Profile
The CDex CommunicationRequest profile constrains the FHIR CommunicationRequest resource. It describes information being requested, or optionally describes an actionable communication request to be fulfilled. This profile includes extensions on the payload element which enable a specific type of document or particular set of data to be provided. This profile is used to describe a request for information, or when actionable, it is used to request specific information. The CommunicationResource is marked as actionable in the Resource meta tag http://build.fhir.org/resource-definitions.html#Meta.tag using the 'actionable' code.

When sharing a CommunicationRequest between disparate systems referenced resources should be represented as contained resources since access to resources on the sender's systems cannot be assumed. The system receiving the CommunicationRequest will need to be able to process information in the contained resource to understand, for example, the subject and the requestor of the CommunicationRequest. 

This profile does not specify what behavior is expected of a system acting as the Communication Request Recipient.  Developers of systems that will play the role of a Communication Request Recipient will need to consider how to handle situations where for example the subject of the CommunicationRequest matches more than one patient on their system, as well as the case when the subject of the CommunicationRequest does not match any patients on their system.

### CDex Communication Profile
The CDex Communication profile constrains the FHIR Communication resource. It describes information being provided. The communication may be based on a previous request for information (solicited communication) or it may be unsolicited (unsolicited communication). This profile includes extensions on the payload element which enable the communication to identify the specific type of document or particular set of data included. This profile is used to supply information in a solicited or unsolicited fashion. Note that there is no requirement that the information supplied in response to a communication request exactly match the requested document type or data query requested.

### CDex SearchSet Bundle Profile
The CDex SearchSet Bundle profile constrains the FHIR Bundle resource. The profile establishes a bundle that can be used to contain a set of data resources provided in a Communication.

### CDex Document Bundle Profile
The CDex Document Bundle profile constrains the FHIR Bundle resource. The profile establishes a bundle that can be used to contain the set of resources associated with a persisted structured document. It is used to provided a structured FHIR document in a communication.

### CDex Composition Profile
The CDex Composition profile constrains the FHIR Composition resource. The profile requires the Composition Resource to include at least one authenticator. The profile is used to represents a structured document that includes attested information.

### CDex Task Profile
The CDex Task profile constrains the FHIR Task resource. The profiles defines task called "fulfill" used to ask a system to fulfill a communication request. It is used when systems support a task-based workflow to orchestrate communication requests.  The task progresses through a set of status defined by FHIR and associated with specified business status defined for the task.  Currently, the profile does not constrain the associated business status states.

### CDex Payload Clinical Note Type extension
The CDex Payload Clinical Note Type extension extends the FHIR CommunicationRequest and Communication resource. It adds an codeable concept element which is used to describe the type of document being requested in a CommunicationRequest or Communication. 

### CDex Payload Query String extension
The CDex Payload Query String extension extends the FHIR CommunicationRequest and Communication resource. It adds a string element which is used to describe a data search (request) being requested in a CommunicationRequest or Communication. 




[Next Page](HRex_Profiles.html)