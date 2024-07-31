{% capture X %}<span style="color:red; font-size:1.5em">&#10008;</span>{% endcapture %}
{% capture OK %}<span style="color:green; font-size:1.5em">&#10004;</span>{% endcapture %}



### Introduction

CDex attachments are intended to be compatible with the X12n transactions and designed to work for both solicited and unsolicited claims and prior authorization. Refer to the CDex [CapabilityStatements] resources for conformance expectations for the various actors and roles. The tables below show:
- The CDex Attachments interaction for each role and the conformance resource and terminology that makes it unique to help clarify the different use cases. 
- The optional and required capabilities for CDex Attachments transactions.
- The optional and required `$submit-attachment` Parameters

Systems may choose some or all of these capabilities and implement any combination of unsolicited or solicited attachments for prior authorization, claims, or both. Therefore, in contrast to the expectations in the CDex CapabilityStatements, they should define what they support in their local capability statement in one or more of the following ways:

1. (Preferred) Formally derived implementable profile from [CDex Task Attachment Request Profile]
2. Document their systems' capabilities for requesting attachments in `CapabilityStatement.rest.resource.documentation` for the Task resource.
3. (Preferred) Formal [OperationDefinition] derived from [`$submit-attachment`]
4. Document their systems' capabilities for submitting attachments in `CapabilityStatement.rest.documentation`

### Provider Conformance

#### Provider in Role of Data Source Server

Data Source Server|Unsolicited Claims|Solicited Claims|Unsolicited Prior Authorization|Solicited Prior Authorization
|:---:|:---:|:---:|:---:|:---:|
CDex Task Attachment Request Profile |{{X}}|{{OK}}|{{X}}|{{OK}}
 Task.reasonCode Terminology|-|`claim`|-|`preauthorization`
{:.grid}

#### Provider in Role of Data Source Client

Data Source Client|Unsolicited Claims|Solicited Claims|Unsolicited Prior Authorization|Solicited Prior Authorization
|:---:|:---:|:---:|:---:|:---:|
Submit Attachment Operation|{{OK}}|{{OK}}|{{OK}}|{{OK}}
 AttachTo parameter Terminology|`claim`|`claim`|`preauthorization`|`preauthorization`
{:.grid}

### Payer Conformance

#### Payer Data Consumer Server Role

Data Consumer Client|Unsolicited Claims|Solicited Claims|Unsolicited Prior Authorization|Solicited Prior Authorization
|:---:|:---:|:---:|:---:|:---:|
Submit Attachment Operation|{{OK}}|{{OK}}|{{OK}}|{{OK}}
 AttachTo parameter Terminology|`claim`|`claim`|`preauthorization`|`preauthorization`
{:.grid}

#### Payer Data Consumer Client Role

Data Consumer Server|Unsolicited Claims|Solicited Claims|Unsolicited Prior Authorization|Solicited Prior Authorization
|:---:|:---:|:---:|:---:|:---:|
CDex Task Attachment Request Profile |{{X}}|{{OK}}|{{X}}|{{OK}}
 Task.reasonCode Terminology|-|`claim`|-|`preauthorization`
{:.grid}

{{OK}}: Conformance resource used in the transaction  
{{X}}: Conformance resource not used in the transaction

### Capabilities for Requesting Attachments

|Capability|Must Support*|Optional|
|:---:|:---:|:---:|
|Requesting Attachments Using Attachment Codes|{{OK}}||
|Requesting Attachments Using Questionnaire||{{OK}}|
|Signatures|{{OK}}||
|Representing The Purpose Of Use (POU) For The Requested Data||{{OK}}|
|Ability to submit attachments data in multiple submissions||{{OK}}|
{:.grid}

\* See the next section

### CDex Must Support Definition

{% include must-support.md %}

### $submit-attachment Parameters for Sending Attachments

|Parameter|Required|Optional|
|:---:|:---:|:---:|
|TrackingId|{{OK}}||
|AttachTo|{{OK}}(see above)|
|PayerId||{{OK}}|
|OrganizationId|{{OK}}||
|ProviderId|{{OK}}||
|MemberId|{{OK}}||
|ServiceDate|{{OK}}(claims)|{{OK}}(prior authorization)|
|Attachment.LineItem||{{OK}}|
|Attachment.Code||{{OK}}(It SHOULD be present when submitting unsolicited attachments)|
|Attachment.Content|{{OK}}(DocumentReference, QuestionnaireResponse if support Requesting Attachments Using Questionnaire|{{OK}}(Servers SHOULD support other FHIR types)|
|Attachment.Final||{{OK}}|
{:.grid}

{% include link-list.md %}
