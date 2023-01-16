{% capture X %}<span style="color:red; font-size:1.5em">&#10008;</span>{% endcapture %}
{% capture OK %}<span style="color:green; font-size:1.5em">&#10004;</span>{% endcapture %}

This page is new content for Da Vinci CDex 2.0.0
{:.new-content}

### Introduction

CDex CDex Task-based transactions have many optional capabilities. Systems may choose some or all of these capabilities and implement any combination of them. Refer to the CDex [CapabilityStatements] resources for conformance expectations for the various actors and roles. In contrast to the CDex CapabilityStatements, Systems should define what they actually support in their local capability statement by one or more of the following ways:

1. (Preferred) Formally derived implementable profile from [CDex Task Data Request Profile]
2. Documenting their systems capabilities for requesting attachments in `CapabilityStatement.rest.resource.documentation` for the Task resource.
3. (Preferred) Formal OperationDefinition derived from [`$submit-attachment`]
4. Documenting their systems capabilities for submitting attachments in `CapabilityStatement.rest.documentation`

### Actors for [CDex Task Data Request Profile]

- Data Source in Role of Data Source Server
- Data Consumer in Role of Data Consumer Client

### Capabilities for Task-based  Requests

|Capability|Required|Optional|
|:---:|:---:|:---:|
|Requesting Attachments Using Attachment Codes|{{OK}}||
|Requesting Attachments Using FHIR RESTful Query Syntax|{{OK}}||
|Requesting Attachments Using Free Text||{{OK}}|
|Requesting Attachments Using Questionnaire||{{OK}}|
|Support of Contained Task Outputs||{{OK}}|
|Signatures|{{OK}}||
|Representing The Purpose Of Use (POU) For The Requested Data||{{OK}}|
|Support of Work Queues Tags||{{OK}}|
|Polling|{{OK}}||
|Subscriptions||{{OK}}|
|Support of Formal Authorizations|{{OK}}||
|Support of Provenance||{{OK}}|
{:.grid}


{% include link-list.md %}
