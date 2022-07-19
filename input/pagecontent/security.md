### Da Vinci HRex Security and Privacy Requirements

This implementation guide inherits all of the mandatory requirements and recommendations defined in the [HRex Security and Privacy] specification.   Implementers **SHALL** read and adhere to the language found there. This includes the following topics:

- Da Vinci Guiding Principles
- Statutes, Regulations
- Clinical Safety Guidelines
- FHIR Security and Implementation Guidance
- Security/Privacy Related Technologies Including Explicit Consent and Security - Labels
- Exchange Security
- Additionally Protected Information
- Security Contexts for Da Vinci IGs

### Supplemental Guidance

#### General Considerations

{% include draft_content_note.md  content="section" %}

1. User scopes **SHALL** be used as defined in [SMART App Launch] to restrict access to the relevant patients for a given Data Consumer.  Organizational user access scopes are typically pre-negotiated and documented via business agreements. These agreements shall be translated into the appropriate SMART App Launch scopes.

1. Audit mechanisms need to be in place so that exchange mechanisms *with or without human intervention* can be subject to review/oversight.

#### Purpose of Use

{% include draft_content_note.md  content="section" %}

The purposes for which data may be used by or on behalf of an organization is known as the Purpose of Use (POU). It is important part of data sharing agreement between Data Consumers and Data Sources because privacy policies and consent directives dictate the response to data requests.  Typically, a single POU is assigned for a client applications when the app is registered and broadly defined POU types such as those listed in the [NHIN Purpose Of Use Code System].  For example, a Payer’s POU is typically “OPERATIONS” and a Provider’s is “TREATMENT”.  Therefore, it is implicit when the Data Consumer makes a direct query or an “automatically fulfilled” Task to the Data Source using that app.

For CDex Task based queries, the POU for the requested data **MAY** also be communicated between the Data Consumer and Data Source for each Task using codes from the [CDex Purpose of Use Value Set] in the POU `Task.input` element. The intent of this element is to define a potentially new way to exchange data with dynamically defined POUs.


#### Sensitive and Confidential Data

If a data consuming system requests sensitive information, then the data source must decide whether the requester is authorized to access some/all of this information.  In the US, if the level of confidentiality protection required for some/all of the information requested by a data consuming system is more stringent than the "default" confidentiality protection provided for HIPAA PHI, then the data source needs to be able to make decisions about whether to provide the information at all or whether to filter the information.

There is work in progress in [FHIR Data Segmentation for Privacy] (ballot version) on standardizing how this information can be conveyed in FHIR. Once a suitable approach has been agreed upon and published, it will be referenced in a future version of this guide.  In the interim, implementers should consult with their compliance department to determine what requirements exist and how best to satisfy them, whether with in-band or out-of-band communications.

{% include link-list.md %}
