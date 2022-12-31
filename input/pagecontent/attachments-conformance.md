{% capture X %}<span style="color:red; font-size:1.5em">&#10008;</span>{% endcapture %}
{% capture OK %}<span style="color:green; font-size:1.5em">&#10004;</span>{% endcapture %}

This page is new content for Da Vinci CDex 2.0.0
{:.new-content}

CDex attachments are intended to be compatible with the X12n transactions and designed to work for both solicited and unsolicited claims and prior authorization. Refer to the CDex [CapabilityStatements] resources for conformance expectations for the various actors and roles. The tables below show the CDex Attachments interaction for each role and the conformance resource and terminology that makes it unique to help clarify the different use cases.  Note that systems may choose some or all of these capabilities and implement any combination of unsolicited or solicited attachments for prior authorization, claims, or both. In contrast to the CDex CapabilityStatements, they should define what they support in their local capability statement.

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

#### Payer in Role of Data Consumer Server

Data Consumer Client|Unsolicited Claims|Solicited Claims|Unsolicited Prior Authorization|Solicited Prior Authorization
|:---:|:---:|:---:|:---:|:---:|
Submit Attachment Operation|{{OK}}|{{OK}}|{{OK}}|{{OK}}
  AttachTo parameter Terminology|`claim`|`claim`|`preauthorization`|`preauthorization`
{:.grid}

#### Payer in Role of Data Consumer Client

Data Consumer Server|Unsolicited Claims|Solicited Claims|Unsolicited Prior Authorization|Solicited Prior Authorization
|:---:|:---:|:---:|:---:|:---:|
CDex Task Attachment Request Profile |{{X}}|{{OK}}|{{X}}|{{OK}}
   Task.reasonCode Terminology|-|`claim`|-|`preauthorization`
{:.grid}

{{OK}}: Conformance resource used in transaction  
{{X}}: Conformance resource not used in transaction

{% include link-list.md %}
