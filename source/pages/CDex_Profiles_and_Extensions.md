---
title: CDex Profiles and Extensions
layout: default
active: CDex Profiles and Extensions
---

## Profiles and Extensions Defined in CDex

### CDex CommunicationRequest Profile
The CDex CommunicationRequest profile constrains the FHIR CommunicationRequest resource. It describes information being requested, or optionally describes an actionable communication request to be fulfilled. This profile includes extensions on the payload element which enable a specific type of document or particular set of data to be provided. This profile is used to describe a request for information, or when actionable, it is used to request specific information.

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

### CommunicationRequest.Payload.typeCode extension
The CDex CommunicationRequest Payload TypeCode extension extends the FHIR CommunicationRequest resource. It adds an codeable concept element which is used to describe the type of document being requested in a CommunicationRequest. 

### CommunicationRequest.Payload.SearchString extension
The CDex CommunicationRequest Payload SearchString extension extends the FHIR CommunicationRequest resource. It adds a string element which is used to describe a data search (request) being requested in a CommunicationRequest. 

### Communication.Payload.typeCode extension
The CDex Communication Payload TypeCode extension extends the FHIR Communication resource. It adds an codeable concept element which is used to describe the type of document being requested in a Communication. 

### Communication.Payload.SearchString extension
The CDex Communication Payload SearchString extension extends the FHIR Communication resource. It adds a string element which is used to describe a data search (request) that was used to gather data supplied in a Communication. 
