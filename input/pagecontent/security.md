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

1. User scopes **SHALL** be used as defined in [SMART App Launch] to restrict access to the relevant patients for a given Data Consumer.

1. Audit mechanisms need to be in place so that exchange mechanisms *with or without human intervention* can be subject to review/oversight.

#### Purpose of Use

In some cases, it may be important to transmit the purpose of use when soliciting data.  Specifically, when the purpose of use differs from the 'default' purpose of use for that data consuming system (generally 'payment and operations' for payers and 'treatment' for providers), the data source needs to be able to make decisions about whether to provide the information at all or whether/how to filter the information.

For the Task based approach, representing purpose of use is documented [here](task-based-approach.html#purpose-of-use).  However, when using standard RESTful queries, such information cannot be conveyed directly. There is work in progress in [FHIR SMART v2 (Granular Controls)] and the [FHIR Data Segmentation for Privacy] (ballot version) on standardizing how this information can be conveyed using OAuth.  Once a suitable approach has been agreed upon and published, it will be referenced in a future version of this guide.  In the interim, implementers should consult with their compliance department to determine what requirements exist and how best to satisfy them, whether with in-band or out-of-band communications.



#### Sensitive and Confidential Data

If a data consuming system requests sensitive information, then the data source must decide whether the requester is authorized to access some/all of this information.  In the US, if the level of confidentiality protection required for some/all of the information requested by a data consuming system is more stringent than the "default" confidentiality protection provided for HIPAA PHI, then the data source needs to be able to make decisions about whether to provide the information at all or whether to filter the information.

There is work in progress in [FHIR Data Segmentation for Privacy] (ballot version) on standardizing how this information can be conveyed in FHIR. Once a suitable approach has been agreed upon and published, it will be referenced in a future version of this guide.  In the interim, implementers should consult with their compliance department to determine what requirements exist and how best to satisfy them, whether with in-band or out-of-band communications.

{% include link-list.md %}
