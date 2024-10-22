### Da Vinci HRex Security and Privacy Requirements

This implementation guide inherits all of the mandatory requirements and recommendations defined in the [HRex Security and Privacy] specification.   Implementers **SHALL** read and adhere to the guidance for the following topics:

- Da Vinci's Guiding Principles
- Statutes, Regulations
- Clinical Safety Guidelines
- FHIR Security and Implementation Guidance
- Security/Privacy-Related Technologies, Including Explicit Consent and Security - Labels
- Exchange Security
- Additionally Protected Information
- Security Contexts for Da Vinci IGs

### Supplemental Guidance

#### General Considerations



1. User scopes **SHALL** be used as defined in [SMART App Launch] to restrict access to the relevant patients for a given Data Consumer. Organizational user access scopes are typically pre-negotiated and documented via business agreements. Data Sources shall translate these agreements into the appropriate SMART App Launch scopes.

1. Audit mechanisms need to be in place so that exchange mechanisms *with or without human intervention* can be subject to review/oversight.

#### Purpose of Use



The purpose for which data may be used by or on behalf of an organization is known as the Purpose of Use (POU). It is an integral part of the data-sharing agreement between Data Consumers and Data Sources because privacy policies and consent directives dictate data requests' responses. Typically, a single POU is assigned for a client application when the app is registered and broadly defined POU types such as those listed in the [NHIN Purpose Of Use Code System]. For example, a Payer's typical POU is "OPERATIONS," and a Provider's typical POU is "TREATMENT". Therefore, it is implicit when the Data Consumer makes a direct query or an "automatically fulfilled" Task to the Data Source using that app.

For CDex Task-based queries, the Data Consumer and Data Source **MAY** communicate the POU for the requested data for each Task using codes from the [CDex Purpose of Use Value Set] in the POU `Task.input` element. This element is intended to define a new way to exchange data with dynamically defined POUs.


#### Sensitive and Confidential Data

If a data-consuming system requests sensitive information, the data source must decide whether the requester is authorized to access some or all of this information. For example, suppose the level of confidentiality protection required for some or all of the information requested by a data-consuming system is more stringent than the "default" confidentiality protection provided for HIPAA PHI. In that case, the data source needs to be able to decide whether to provide the information at all or whether to filter the information.

The [FHIR Data Segmentation for Privacy] (ballot version) standardizes how guidance for applying security labels in FHIR. Once ONC or CMS adopts it or a suitable approach by regulation, a future version of this guide will reference it. In the interim, implementers should consult with their compliance department to determine requirements and how best to satisfy them, whether with in-band or out-of-band communications.

{% include link-list.md %}
