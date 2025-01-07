### Version = 2.1.0
- Publication Date: 2025-1-15
- URL: <https://hl7.org/fhir/us/davinci-cdex/STU2.1>
- Based on FHIR version: 4.0.1

This STU Update of The Da Vinci Clinical Data Exchange (CDex) Implementation Guide is the fourth published version of this guide. The sponsoring HL7 International Payer/Provider Information Exchange Work Group members agreed to and voted on the resolution of the community review comments and edits to this guide.

#### What's new in Version 2.1.0 of CDex:

See the 2.1.0-snapshot version below

#### Changes:

These changes are the result of the community review of the 2.1.0-snapshot version

**Status: Summary (Jira Issue) Link to Change**

1. **Applied**: (Enhancement) Add guidance that should not bypass BR guides [FHIR-48404](https://jira.hl7.org/browse/FHIR-48404) [See Changes Here](solicited-unsolicited-attachments.html) and [See Changes Here](burden-reduction.html)
2. **Applied**: (Enhancement) Require adherence to Da Vinci Guiding Principles [FHIR-48406](https://jira.hl7.org/browse/FHIR-48406) [See Changes Here](index.html#about-this-guide)
3. **Applied**: (Enhancement) Update Figure [FHIR-48384](https://jira.hl7.org/browse/FHIR-48384) [See Changes Here](background.html#where-does-cdex-fit-in-the-da-vinci-project)
4. **Applied**: (Clarification) Remove conflicting guidance on Quality Measure and Risk Adjustment [FHIR-48841](https://jira.hl7.org/browse/FHIR-48841)

### Version = 2.1.0-snapshot
- Publication Date: 2024-09-11
- URL: <https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot>
- Based on FHIR version: 4.0.1

This Snapshot version of The Da Vinci Clinical Data Exchange (CDex) Implementation Guide is the proposed STU update of this guide and is published for community review prior to final publication of version 2.1.0. The members of the sponsoring HL7 International Payer/Provider Information Exchange Work Group agreed to and voted on the resolution of the community comments and edits to this guide.

#### What's new in Version 2.1.0-snapshot of CDex:

1. Support for [US Core 6.1.0](https://hl7.org/fhir/us/core/STU6.1/) and [US Core 7.0.0](https://hl7.org/fhir/us/core/STU7/).
2. Updated guidance on [Using CDex Attachments with DaVinci PAS](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/burden-reduction.html#using-cdex-attachments-with-davinci-pas) page to align with Da Vinci PAS v 2.0.1 Guide's, [Request for Additional Information](https://hl7.org/fhir/us/davinci-pas/STU2/additionalinfo.html) page.
3. A new section on [topic-based subscriptions](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/task-based-approach.html#subscription) based on the [Subscription R5 Backport Implementation Guide](http://hl7.org/fhir/uv/subscriptions-backport/STU1.1/index.html) implementation guide.
4. Updated guidance on [discovery of patient ids](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/direct-query.html#discovery-of-patient-fhir-ids) based on FAST's [Interoperable Digital Identity and Patient Matching](https://hl7.org/fhir/us/identity-matching/index.html) implementation guide.
5. Version 2.0.0 *Draft* content about using Questionnaires with the Task-based Approach and Attachments updated to *Trial Use*.
6. A  new [design section](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/background.html#architectural-approach) explains the IG’s choice of exchange architecture in terms of the [Approaches to Exchanging FHIR Data](https://hl7.org/fhir/exchanging.html) page.
7. [Task state diagram](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/task-based-approach.html#task-state-machine) for the CDex Task profiles.

#### Changes:

These changes are the result of the trackers listed below.

**Status: Summary (Jira Issue) Link to Change**

1. **Applied:** (Correction) Update diagram to "Provider submitted requested attachments to the *Payer*"  [FHIR-38604](https://jira.hl7.org/browse/FHIR-38604) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/solicited-unsolicited-attachments.html#solicited-attachments)
3. **Applied:** (Enhancement) Add profile for $submit-attachment Parameters resource [FHIR-41336](https://jira.hl7.org/browse/FHIR-41336) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/StructureDefinition-cdex-parameters-submit-attachment.html)
4. **Applied:** (Correction) Update `meta.tag.system` cardinality to 1..1 [FHIR-43618](https://jira.hl7.org/browse/FHIR-43618) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/StructureDefinition-cdex-task-data-request.html)
5.  **Applied:** (Clarification) Clarify when to use CDex vs PAS for attachments [FHIR-44870](https://jira.hl7.org/browse/FHIR-44870) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/burden-reduction.html)
6.  **Applied:** (Enhancement) Include PWK01 attachment codes [FHIR-44871](https://jira.hl7.org/browse/FHIR-44871) See Changes:
   - [CDex LOINC Attachment Codes Value Set](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/ValueSet-cdex-loinc-attachment-codes.html)
   - [CDex PWK01 Attachment Report Type Code Value Set](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/ValueSet-cdex-pwk01-attachment-report-type-code.html)
   - [CDex Task Attachment Request Profile](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/StructureDefinition-cdex-task-attachment-request.html)
   - [CDex Parameters Submit Attachment Profile](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/StructureDefinition-cdex-parameters-submit-attachment.html)
   - [Requesting Attachments Using Attachments Codes](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/requesting-attachments-code.html)
7.  **Applied:** (Enhancement) Correct X12 278 Data Element Mappings [FHIR-44875](https://jira.hl7.org/browse/FHIR-44875) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/requesting-attachments-code.html#data-elements-for-requesting-attachments)
8.  **Applied:** (Clarification) Change Task.input "payer-url" to "PayerURL" to align with PAS Task [FHIR-44883](https://jira.hl7.org/browse/FHIR-44883) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/StructureDefinition-cdex-task-attachment-request.html) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/Task-cdex-task-example19.html)
9.  **Applied:** (Clarification) Change Task.input "code" to "AttachmentsNeeded" to align with PAS Task [FHIR-44884](https://jira.hl7.org/browse/FHIR-44884) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/StructureDefinition-cdex-task-attachment-request.html) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/Task-cdex-task-example19.html)
10. **Applied:** (Clarification) Change Task.input "questionnaire" slice to "QuestionnaireContext" to align with PAS Task [FHIR-44885](https://jira.hl7.org/browse/FHIR-44885) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/StructureDefinition-cdex-task-attachment-request.html) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/Task-cdex-task-example22.html)
11. **Applied:** (Clarification) Fix X12 277RFAI-v6020 mapping for Line Items [FHIR-45298](https://jira.hl7.org/browse/FHIR-45298) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/requesting-attachments-code.html#data-elements-for-requesting-attachments)
12. **Applied:** (Correction) Add Business Status to Task [FHIR-45299](https://jira.hl7.org/browse/FHIR-45299) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/requesting-attachments-questionnaire.html)
13. **Applied:** (Correction) Remove self referencing instantiates in CapabilityStatements [FHIR-45322](https://jira.hl7.org/browse/FHIR-45322) See Changes:
   - [Data Consumer Client CapabilityStatement](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/CapabilityStatement-data-consumer-client.html)
   - [Data Consumer Server CapabilityStatement](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/CapabilityStatement-data-consumer-server.html)
   - [Data Source Client CapabilityStatement](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/CapabilityStatement-data-source-client.html)
   - [Data Source Server CapabilityStatement](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/CapabilityStatement-data-source-server.html)
14. **Applied:** (Enhancement) Update Version 2.0.0 Draft content to Trial Use [FHIR-45409](https://jira.hl7.org/browse/FHIR-45409)
15. **Applied:** (Enhancement) update to support topic based subscriptions [FHIR-45628](https://jira.hl7.org/browse/FHIR-45628) See Changes:
   - [Polling vs Subscriptions](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/task-based-approach.html#polling-vs-subscriptions)
   - [Data Consumer Client CapabilityStatement](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/CapabilityStatement-data-consumer-client.html)
   - [Data Source Server CapabilityStatement](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/CapabilityStatement-data-source-server.html)
   - [Inline Subscription Task Scenario1 Subscription Requested](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/Subscription-cdex-task-inline-scenario1-subscription-requested.html)
   - [Inline Subscription Task Scenario1 Subscription Active](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/Subscription-cdex-task-inline-scenario1-subscription-active.html)
   - [Inline Subscription Task Scenario1 Subscription Notification](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/Bundle-cdex-task-inline-scenario1-subscription-notification.html)
   - [CDex Capabilitystatement Inline Example](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/CapabilityStatement-cdex-capabilitystatement-inline-example.html)
16. **Applied:**(Enhancement) Add design section to background page [FHIR-45884](https://jira.hl7.org/browse/FHIR-45884) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/background.html#architectural-approach)
17. **Applied:**(Enhancement) Add Task State diagram to specification [FHIR-46004](https://jira.hl7.org/browse/FHIR-46004) See Changes:
   - [Task State Machine](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/task-based-approach.html#task-state-machine)
   - [Requesting Attachments Using Attachment Codes](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/requesting-attachments-code.html#requesting-attachments-using-fhir)
   - [Requesting Attachments Using Questionnaires](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/requesting-attachments-questionnaire.html#requesting-attachments-using-fhir)
18. **Applied:**(Enhancement) Change Task.input:QuestionnaireContext max from 1 to * [FHIR-46093](https://jira.hl7.org/browse/FHIR-46093) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/StructureDefinition-cdex-task-attachment-request-definitions.html#diff_Task.input:QuestionnaireContext) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/requesting-attachments-questionnaire.html)
19. **Applied:**(Enhancement) Add Task Based approach as an option for the discovery of a member’s FHIR_ID [FHIR-45982](https://jira.hl7.org/browse/FHIR-45982) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/direct-query.html#discovery-of-patient-fhir-ids)
20. **Applied:**(Enhancement) Remove FAST STU note and add guidance on using FAST's The Interoperable Digital Identity and Patient Matching guide [FHIR-45985](https://jira.hl7.org/browse/FHIR-45985) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/direct-query.html#discovery-of-patient-fhir-ids) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/task-based-approach.html#discovery-of-identifiers)
21. **Applied:**(Enhancement) Add "Support" menu item [FHIR-46349](https://jira.hl7.org/browse/FHIR-46349) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/index.html)
22. **Applied**: (Enhancement) Support both US-Core 3.1.1 and 6.1.0 [FHIR-46507](https://jira.hl7.org/browse/FHIR-46507)
23. **Applied**: (Enhancement) Add link to flowcharts images to downloads page [FHIR-46508](https://jira.hl7.org/browse/FHIR-46508) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/downloads.html#example-flow-chart-diagrams)
24. **Applied**: (Correction) Copy editing changes prior to comment period to ensure accuracy, clarity, and readability. [FHIR-46509](https://jira.hl7.org/browse/FHIR-46509) For example, See Changes: 
 - [How To Read This Guide](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/index.html#how-to-read-this-guide)
 - [Sensitive and Confidential Data](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/security.html#sensitive-and-confidential-data)
25. **Applied**: (Correction) Fix Typo and ordering in Task Data Request Profile [FHIR-46294](https://jira.hl7.org/browse/FHIR-46294) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/StructureDefinition-cdex-task-data-request.html)
26. **Applied**: (Correction) Add Task.authoredOn to list of mandatory elements in the CDex Task Data Request Profile description. [FHIR-46296](https://jira.hl7.org/browse/FHIR-46296) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/StructureDefinition-cdex-task-data-request.html)
27. **Applied**: (Correction) Change page statuses [FHIR-46563](https://jira.hl7.org/browse/FHIR-46563) For example [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/security.html)
28. **Applied**: (Enhancement) Add endpoint discovery guidance for *Unsolicited* Attachments [FHIR-46443](https://jira.hl7.org/browse/FHIR-46443) [See Changes Here](https://hl7.org/fhir/us/davinci-cdex/STU2.1-snapshot/sending-attachments.html#submit-attachment-operation)
29. **Applied**: (Enhancement) Support both US-Core 3.1.1 and 6.1.0 and 7.0.0 [FHIR-47303](https://jira.hl7.org/browse/FHIR-47303)

### Version = 2.0.0
- Publication Date: 2023-01-30
- URL: <http://hl7.org/fhir/us/davinci-cdex/STU2>
- Based on FHIR version: 4.0.1

This STU2 version of The Da Vinci Clinical Data Exchange (CDex) Implementation Guide is the third published version of this guide and is the result of the 2022 September HL7 balloting process. The resulting resolution of the community comments and edits to this guide has been agreed to and voted on by the members of the sponsoring HL7 International Patient Care and Payer/Provider Information Exchange Work Groups.

#### What's new in Version 2.0.0 of CDex:

1. New [Requesting Attachments Using Questionnaires](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-questionnaire.html) functionality. In prior versions, CDex supported requested attachments using the request model of LOINC attachment codes, and the provider typically submitted CCDA or PDF documents in response. In this version, CDex aligns with DTR functionality and provide the ability to request attachment using Questionnaire, CQL, and QuestionnaireResponse as supported by DTR when there is no transition into/out of X12 transactions in the interactions. In addition, this approach will enable specific requests for missing data and avoid unnecessary document formats, yet still provide the ability for signature attestation if required.
2. New Task-Based transactions functionality for [Using Questionnaire as Task Input](https://hl7.org/fhir/us/davinci-cdex/STU2/task-based-approach.html#using-questionnaire-as-task-input). In prior versions, CDex Task Based Approach supported requests using the request model of FHIR RESTful query syntax, codes, and free-text. As a result, the provider typically returned references to FHIR Bundles. Similar to the Attachments updates, this added functionality leverages DTR and enables specific requests for missing data, avoiding unnecessary use of Bundles.
3. Improved navigation:
   - Menu Bar drop-downs for all the pages to allow faster navigation to a specific topic
   - Re-organization of [FHIR Artifacts](https://hl7.org/fhir/us/davinci-cdex/STU2/artifacts.html) by transaction type. This version has several FHIR artifacts and dozens of examples grouped by Attachments, Task-Based Approach, and Signatures.
4. [Conforming to CDex Attachments](https://hl7.org/fhir/us/davinci-cdex/STU2/attachments-conformance.html) and [Conforming to CDex Task Based Approach](https://hl7.org/fhir/us/davinci-cdex/STU2/task-based-conformance.html), including interactions for each role and the conformance resource and terminology that makes them unique.
5. After receiving many comments on CDex POU support, the [CDex Purpose of Use Value Set](https://hl7.org/fhir/us/davinci-cdex/STU2/ValueSet-cdex-POU.html) now includes a hierarchy to the base "Treatment", "Payment", or "Health Care Operations" (TPO) concepts.
6. More examples, including examples of failed signature verifications, signed QuestionnaireResponse, and requesting Attachments for prior authorization using Questionnaire.

#### Changes:

These changes are the result of over 60 trackers listed below. They include the 2022 September HL7 balloting process and non-ballot issues.

##### September 2022 ballot and non-ballot comments and links to the updated content are below:

**Status: Summary (Jira Issue) Link to Change**

1. **Applied**: Correct $submit-attachment input parameter Typo. ([FHIR-37956](https://jira.hl7.org/browse/FHIR-37956)) and ([FHIR-38175](https://jira.hl7.org/browse/FHIR-38175)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/OperationDefinition-submit-attachment.html)
2. **Applied**: Correct claim flow diagram typo ([FHIR-38060](https://jira.hl7.org/browse/FHIR-38060)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/solicited-unsolicited-attachments.html#solicited-attachments)
4. **Applied**: Added missing service line item extension to CDex Task Attachment Request Profile ([FHIR-38070](https://jira.hl7.org/browse/FHIR-38070)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/StructureDefinition-cdex-task-attachment-request.html)
5. **Applied**: Document POU ValueSet Hierarchy to TPO ([FHIR-38142](https://jira.hl7.org/browse/FHIR-38142)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/ValueSet-cdex-POU.html)
6. **Applied**: DS4P should be evaluated before required ([FHIR-38144](https://jira.hl7.org/browse/FHIR-38144)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/security.html#sensitive-and-confidential-data)
7. **Applied**: Correct capitalization ([FHIR-38145](https://jira.hl7.org/browse/FHIR-38145)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/solicited-unsolicited-attachments.html)
9. **Applied**: Change 277 to: “277 Request for Additional Information (RFAI)” ([FHIR-38152](https://jira.hl7.org/browse/FHIR-38152)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#step-by-step-solicited-attachment-transaction)
10. **Applied**: Update sentence ([FHIR-38153](https://jira.hl7.org/browse/FHIR-38153)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html)
11. **Applied**: Correct Typo ([FHIR-38154](https://jira.hl7.org/browse/FHIR-38154)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#requesting-attachments-using-fhir)
12. **Applied**: Modify sentence ([FHIR-38155](https://jira.hl7.org/browse/FHIR-38155)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#step-by-step-solicited-attachment-transaction)
13. **Applied**: Change X12n 277 *message* to X12n 277 *RFAI transaction*. ([FHIR-38156](https://jira.hl7.org/browse/FHIR-38156)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#step-by-step-solicited-attachment-transaction)
14. **Applied**: Update Data Elements table ([FHIR-38172](https://jira.hl7.org/browse/FHIR-38172)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#data-elements-for-requesting-attachments) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#data-elements-for-requesting-attachments)
15. **Applied**: Update Data Elements table ([FHIR-38174](https://jira.hl7.org/browse/FHIR-38174)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#data-elements-for-requesting-attachments)
17. **Applied**:Change X12n 275 *message* to X12n 275 *transaction* ([FHIR-38177](https://jira.hl7.org/browse/FHIR-38177)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#step-by-step-solicited-attachment-transaction)
18. **Applied**:Change *all* documents to *submitted* documents ([FHIR-38178](https://jira.hl7.org/browse/FHIR-38178)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#step-by-step-solicited-attachment-transaction)
19. **Applied**: Remove HIPAA compliance language ([FHIR-38179](https://jira.hl7.org/browse/FHIR-38179)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#verifying-patient-identity)
20. **Applied**: Change *Claim* to *claim or prior authorization* ([FHIR-38184](https://jira.hl7.org/browse/FHIR-38184)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#verifying-patient-identity)
21. **Applied**: Normalize term “prior authorization” ([FHIR-38186](https://jira.hl7.org/browse/FHIR-38186)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html)
22. **Applied**: Update Grammar ([FHIR-38187](https://jira.hl7.org/browse/FHIR-38187)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#supply-the-requested-attachments-for-each-line-item-and-code)
23. **Applied**: Clarify that signature support is not required ([FHIR-38188](https://jira.hl7.org/browse/FHIR-38188)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/signatures.html) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/sending-attachments.html#signatures)
24. **Applied**: Clarify in operation that either an OrganizationId or ProviderId is required. Allow for both Ids to be sent in request.([FHIR-38189](https://jira.hl7.org/browse/FHIR-38189)) See Changes:[
   - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/OperationDefinition-submit-attachment.html) 
   - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/StructureDefinition-cdex-practitionerrole.html)
   - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/StructureDefinition-cdex-task-attachment-request.html) 
   - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#identifying-the-payer-provider-and-patient)
25. **Applied**: Change Task service date input parameter to min = 0 and required only for claims ([FHIR-38191](https://jira.hl7.org/browse/FHIR-38191)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/StructureDefinition-cdex-task-attachment-request.html) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#date-of-service-for-the-claim) 
26. **Applied**: Clarify conformance expectations ([FHIR-38192](https://jira.hl7.org/browse/FHIR-38192)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/attachments-conformance.html) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/task-based-conformance.html)
27. **Applied**: Clarify patient account number ([FHIR-38194](https://jira.hl7.org/browse/FHIR-38194)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#data-elements-for-requesting-attachments)
28. **Applied**: Task Infrastructure Elements ([FHIR-38195](https://jira.hl7.org/browse/FHIR-38195)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#task-status-intent-and-code-elements)
30. **Applied**: Separate solicited and unsolicited attachments workflows ([FHIR-38210](https://jira.hl7.org/browse/FHIR-38210)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/background.html#workflow-overview)
31. **Applied**: Make LOINC code display and text consistent ([FHIR-38233](https://jira.hl7.org/browse/FHIR-38233)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Parameters-cdex-parameters-example1.json.html)
32. **Applied**: Fix Typo in example ([FHIR-38236](https://jira.hl7.org/browse/FHIR-38236))w See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Parameters-cdex-parameters-example4.html)
33. **Applied**: Clarify Attachment Scope ([FHIR-38240](https://jira.hl7.org/browse/FHIR-38240)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/solicited-unsolicited-attachments.html)
34. **Applied**: Expand Attachments and Task based approach to support Questionnaires and DTR ([FHIR-38241](https://jira.hl7.org/browse/FHIR-38241)) See Changes:
    - Pages:
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/task-based-approach.html#using-questionnaire-as-task-input)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-questionnaire.html)
    - Conformance Artifacts:
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/StructureDefinition-cdex-task-attachment-request.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/ValueSet-cdex-attachment-task-code.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/StructureDefinition-cdex-task-data-request.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/ValueSet-cdex-data-request-task-code.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/CodeSystem-cdex-temp.html)
    - Examples:
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Task-cdex-task-example22.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Task-cdex-task-example23.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Task-cdex-task-example24.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Task-cdex-task-example25.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Task-cdex-task-example26.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Task-cdex-task-example27.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Task-cdex-task-example28.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Task-cdex-task-example29.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Task-cdex-task-example30.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Task-cdex-task-example31.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Parameters-cdex-parameters-example5.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Questionnaire-cdex-questionnaire-example1.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/Questionnaire-cdex-questionnaire-example2.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/QuestionnaireResponse-cdex-questionnaireresponse-example1.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/QuestionnaireResponse-cdex-questionnaireresponse-example2.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/QuestionnaireResponse-cdex-questionnaireresponse-example3.html)
      - [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/QuestionnaireResponse-cdex-questionnaireresponse-example4.html)
35. **Applied**: Clarify when human involvement needed ([FHIR-38242](https://jira.hl7.org/browse/FHIR-38242)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/task-based-approach.html#sequence-diagram)
36. **Applied**: Add link to PAS Guidance on pended results ([FHIR-38244](https://jira.hl7.org/browse/FHIR-38244)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/burden-reduction.html)
37. **Applied**: Add POU for Attachment Request as optional input parameter ([FHIR-38245](https://jira.hl7.org/browse/FHIR-38245)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/StructureDefinition-cdex-task-attachment-request.html) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#purpose-of-use-for-the-request) 
38. **Applied**: Correct operation name ([FHIR-38253](https://jira.hl7.org/browse/FHIR-38253)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#data-elements-for-requesting-attachments)
39. **Applied**: Change *only accepts* to *only accept*([FHIR-38255](https://jira.hl7.org/browse/FHIR-38255)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/OperationDefinition-submit-attachment.html)
40. **Applied**: Clarify use of cdex-temp code system ([FHIR-38259](https://jira.hl7.org/browse/FHIR-38259)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/ValueSet-cdex-POU.html) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/CodeSystem-cdex-temp.html)
41. **Applied**: Clarify use of data tagging ([FHIR-38286](https://jira.hl7.org/browse/FHIR-38286)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/security.html#sensitive-and-confidential-data)
42. **Applied**: Updated X12 element mappings and X12 required citations ([FHIR-38287](https://jira.hl7.org/browse/FHIR-38287)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#data-elements-for-requesting-attachments) and Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/sending-attachments.html#data-elements-for-sending-attachments)
43. **Applied**: Clarify how to find patient FHIR ID ([FHIR-38318](https://jira.hl7.org/browse/FHIR-38318)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/direct-query.html#discovery-of-patient-fhir-ids)
44. **Applied**: Clarify X12 Compatibility ([FHIR-38326](https://jira.hl7.org/browse/FHIR-38326)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/sending-attachments.html#sending-attachments)
45. **Applied**: Add Qualifier to Signed Document Bundle ([FHIR-38327](https://jira.hl7.org/browse/FHIR-38327)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/signatures.html#step-by-step-examples)
46. **Applied**: Remove words *transaction layer* ([FHIR-38328](https://jira.hl7.org/browse/FHIR-38328)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/sending-attachments.html#technical-workflow)
47. **Applied**: Word change *analogs* to *fields* ([FHIR-38330](https://jira.hl7.org/browse/FHIR-38330)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/sending-attachments.html#data-elements-for-sending-attachments)
48. **Applied**: Correct rendering of CCDA ([FHIR-38367](https://jira.hl7.org/browse/FHIR-38367)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/task-based-approach.html#surgical-notes-as-ccda-documents)
49. **Applied**: removed '*' from button bar ([FHIR-38368](https://jira.hl7.org/browse/FHIR-38368)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/task-based-approach.html#example-of-a-signed-task-based-transaction)
50. **Applied**: Change *follows* to *adheres to* ([FHIR-38576](https://jira.hl7.org/browse/FHIR-38576)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/index.html#about-this-guide)
51. **Applied**: Revise section 'what Do Payers Do with Clinical Information?' ([FHIR-38578](https://jira.hl7.org/browse/FHIR-38578)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/background.html)
52. **Applied**: Clarify when CDex is used instead of other guides ([FHIR-38585](https://jira.hl7.org/browse/FHIR-38585)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/background.html#where-does-cdex-fit-in-the-da-vinci-project)
53. **Applied**: Remove the HIE paragraph ([FHIR-38588](https://jira.hl7.org/browse/FHIR-38588)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/background.html#actors-and-roles)
54. **Applied**: Create failed signature example transaction ([FHIR-38596](https://jira.hl7.org/browse/FHIR-38596)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/sending-attachments.html#signatures)
55. **Applied**: Clarify benefits of POU element ([FHIR-38598](https://jira.hl7.org/browse/FHIR-38598)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/#)
56. **Applied**: change SHOULD to SHALL ([FHIR-38599](https://jira.hl7.org/browse/FHIR-38599)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/task-based-approach.html#task-reason)
57. **Applied**: Correct Preconditions and Assumptions ([FHIR-38600](https://jira.hl7.org/browse/FHIR-38600)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/task-based-approach.html#scenario-2)
58. **Applied**: Correct Preconditions and Assumptions ([FHIR-38601](https://jira.hl7.org/browse/FHIR-38601)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/task-based-approach.html#scenario-2)
59. **Applied**: Update polling frequency guidance([FHIR-38602](https://jira.hl7.org/browse/FHIR-38602)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/task-based-approach.html#polling)
60. **Applied**: Remove trading partner agreement statement ([FHIR-38603](https://jira.hl7.org/browse/FHIR-38603)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/solicited-unsolicited-attachments.html#unsolicited-attachments)
61. **Applied**: Clarify association comment and assign FMM levels to guide  ([FHIR-38605](https://jira.hl7.org/browse/FHIR-38605)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/background.html#steps-2)
62. **Applied**: Clarify Profile relationship to X12  ([FHIR-38612](https://jira.hl7.org/browse/FHIR-38612)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/requesting-attachments-code.html#cdex-attachment-request-profile)
63. **Applied**: Change $submit-attachment's Attachment input parameter to min=1. ([FHIR-38632](https://jira.hl7.org/browse/FHIR-38632)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/OperationDefinition-submit-attachment.html)
64. **Applied**: Change Tracking-id.system to Must Support; and $submit-attachment TrackingId to type Identifier. ([FHIR-39337](https://jira.hl7.org/browse/FHIR-39337)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/OperationDefinition-submit-attachment.html) and [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/StructureDefinition-cdex-task-attachment-request.html)
65. **Applied**: Update NPI codesystem  ([FHIR-39626](https://jira.hl7.org/browse/FHIR-39626)) See Changes [Here](https://hl7.org/fhir/us/davinci-cdex/STU2/ValueSet-cdex-identifier-types.html)

### Version = 2.0.0-ballot
- Publication Date: 2022-08-01
- URL: <http://hl7.org/fhir/us/davinci-cdex/2022Sep/>
- Based on FHIR version: 4.0.1

#### Changes:
Da Vinci CDEX 2022 September Ballot. This ballot is restricted to the *Draft* content in the STU 1.1.0 version of CDex. The draft content includes 1) requesting and sending attachments and 2) communicating the purpose of use in Task Based Queries.

### Version = 1.1.0
- Publication Date: 2022-08-01
- URL: <https://hl7.org/fhir/us/davinci-cdex/STU1.1/>
- Based on FHIR version: 4.0.1

This STU1.1 version of The Da Vinci Clinical Data Exchange (CDex) Implementation Guide is the second published version of this guide and is the result of the 2022 May HL7 balloting process. The resulting resolution of the community comments and edits to the guide has been agreed to and voted on by the members of the sponsoring HL7 International Patient Care and Payer/Provider Information Exchange Work Groups.

#### What’s new in Version 1.1.0 of CDex:

- <span class="bg-warning">This content is DRAFT and is open for review.</span> An [Attachments](https://hl7.org/fhir/us/davinci-cdex/STU1.1/attachments.html) section  documenting how to exchange attachments for claims or prior authorization.
    - A [Solicited and Unsolicited Attachments](https://hl7.org/fhir/us/davinci-cdex/STU1.1/solicited-unsolicited-attachments.html) page documents the differences and similarities between solicited and unsolicited attachments workflows and the CDex transactions that can be used for each.
    - A [Sending Attachments](https://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html) page that documents a FHIR-based approach for sending attachments for claims or prior authorization directly to a Payer.
    - A [Requesting Attachments](https://hl7.org/fhir/us/davinci-cdex/STU1.1/requesting-attachments.html) page to document a FHIR-based approach for requesting attachments for claims or prior authorization from a Provider.
    - A [Using CDex Attachments with DaVinci PAS](https://hl7.org/fhir/us/davinci-cdex/STU1.1/requesting-attachments.html) page that illustrates where in the PAS workflow the Payer could use CDEX to request attachments and the Provider could use CDEX to submit attachments.
- [Signatures](https://hl7.org/fhir/us/davinci-cdex/STU1.1/signatures.html) page sections for each transaction in CDex to provide specific guidance and rules to exchange *signed* data using FHIR and non-FHIR signatures. 
- A [Change Log](https://hl7.org/fhir/us/davinci-cdex/STU1.1/changes.html) page to document the changes across the versions of CDex
- More [examples](https://hl7.org/fhir/us/davinci-cdex/STU1.1/artifacts.html#6) and example scenarios
  
#### Changes:

These changes are the result of almost 60 trackers listed below. They include the 2022 May HL7 balloting process, non-ballot issue, and *Draft* new content to meet anticipated Attachments legislation and rules. 

##### May 2022 Ballot comments and links to the updated content are below::

**Status: Summary (Jira Issue) Link to Change**

1. **Applied:** Typo ([FHIR-36819](https://jira.hl7.org/browse/FHIR-36819))
2. **Applied:** Typo ([FHIR-36820](https://jira.hl7.org/browse/FHIR-36820))
3. **Applied:** Typo ([FHIR-36821](https://jira.hl7.org/browse/FHIR-36821))
6. **Applied:** Add guidance when Signatures fail verification ([FHIR-36842](https://jira.hl7.org/browse/FHIR-36842)) See Changes:   
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/direct-query.html#signatures)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#signatures)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html#signatures)
7. **Applied:** Add link to Example of Completed Task Request for Signed Data([FHIR-36844](https://jira.hl7.org/browse/FHIR-36844)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/Task-cdex-task-example18.html)
8. **Applied:** Clarification on who is signing([FHIR-36845](https://jira.hl7.org/browse/FHIR-36845)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/direct-query.html#signatures)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#signatures)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html#signatures)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/signatures.html)
9. **Applied:** Clarify system level signatures ([FHIR-36847](https://jira.hl7.org/browse/FHIR-36847)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/direct-query.html#signatures)
10. **Applied:** Add example FlowSheets for each Transaction ([FHIR-36854](https://jira.hl7.org/browse/FHIR-36854)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/downloads.html)
11. **Applied:** Typo ([FHIR-36917](https://jira.hl7.org/browse/FHIR-36917))
12. **Applied** Update Figure ([FHIR-36918](https://jira.hl7.org/browse/FHIR-36918)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/background.html#attachments-workflow)
13. **Applied** Clarify purpose for additional information ([FHIR-36919](https://jira.hl7.org/browse/FHIR-36919)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/attachments.html)
14. **Applied:** Typo ([FHIR-36921](https://jira.hl7.org/browse/FHIR-36921))
15. **Applied:** Typo ([FHIR-36922](https://jira.hl7.org/browse/FHIR-36922))
16. **Applied** Clarify Figure 4 and associated text in 2.6.2 ([FHIR-36985](https://jira.hl7.org/browse/FHIR-36985)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/background.html#attachments-workflow)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/solicited-unsolicited-attachments.html)
18. **Applied:** Add non-document based attachment scenario ([FHIR-36995](https://jira.hl7.org/browse/FHIR-36995)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html#scenario-2-laboratory-results-attachments)
19. **Applied:** Clarify association of data ([FHIR-36996](https://jira.hl7.org/browse/FHIR-36996)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/attachments.html)
20. **Applied:** Document using CDex Attachments with DaVinci PAS ([FHIR-36997](https://jira.hl7.org/browse/FHIR-36997)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/burden-reduction.html)
21. **Applied:** Replace EHR with Source HIT ([FHIR-36999](https://jira.hl7.org/browse/FHIR-36999)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/index.html#how-to-read-this-guide)
23. **Applied:** Remove "preferred" approach from direct query ([FHIR-37166](https://jira.hl7.org/browse/FHIR-37166)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/direct-query.html)
24. **Applied:** Clarify H&P in diagram is object or behavior ([FHIR-37225](https://jira.hl7.org/browse/FHIR-37225)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/background.html#attachments-workflow)
25. **Applied:** Clarify roles in attachments diagram([FHIR-37226](https://jira.hl7.org/browse/FHIR-37226)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/background.html#attachments-workflow)
26. **Applied:** Typo ([FHIR-37227](https://jira.hl7.org/browse/FHIR-37227))
27. **Applied:** Typo ([FHIR-37229](https://jira.hl7.org/browse/FHIR-37229))
28. **Applied:** Typo ([FHIR-37233](https://jira.hl7.org/browse/FHIR-37233))
29. **Applied:** Clarify Figure 7 step 4 text to match the description ([FHIR-37234](https://jira.hl7.org/browse/FHIR-37234)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html#technical-workflow)
30. **Applied:** Typo ([FHIR-37235](https://jira.hl7.org/browse/FHIR-37235))
31. **Applied:** Rewrite introduction to Signature ([FHIR-37243](https://jira.hl7.org/browse/FHIR-37243)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/signatures.html)
33. **Applied:** Add best practice guidance for signatures ([FHIR-37246](https://jira.hl7.org/browse/FHIR-37246)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#data-sourceresponder-requirements)
34. **Applied:** Remove "preferred" ([FHIR-37248](https://jira.hl7.org/browse/FHIR-37248))
35. **Applied:** Use term Data Consumer consistently and Define how terms used in guide([FHIR-37250](https://jira.hl7.org/browse/FHIR-37250)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/index.html#how-to-read-this-guide)
36. **Applied:** Re-write Signature sections([FHIR-37251](https://jira.hl7.org/browse/FHIR-37251)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/direct-query.html#signatures)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#signatures)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html#signatures)
42. **Applied:** Rewrite introduction to Signature ([FHIR-37253](https://jira.hl7.org/browse/FHIR-37253)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/signatures.html)
44. **Applied:** Update Polling Guidance ([FHIR-37260](https://jira.hl7.org/browse/FHIR-37260)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#polling-vs-subscriptions)

##### Non-Ballot Issues and links to the updated content are below::

**Status: Summary (Jira Issue) Link to Change**

1. **Applied:** Recommendation for exchanging purpose of use. ([FHIR-30824](https://jira.hl7.org/browse/FHIR-30824)) See Changes:
  - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html)
  - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#purpose-of-use)
  - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/security.html#general-considerations)
  - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/security.html#purpose-of-use)
3. **Applied** Make Task.reasonReference.identifer 0…1 MS ([FHIR-35151](https://jira.hl7.org/browse/FHIR-35151)) See Changes:
  - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/StructureDefinition-cdex-task-data-request.html)
  - [Various examples such as Here](https://hl7.org/fhir/us/davinci-cdex/STU1.1/Task-cdex-task-example1.html)
  - [Various example scenarios such as Here](https://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#step-1---post-task-to-provider-endpoint)
6. **Applied:** Create page for change log ([FHIR-36727](https://jira.hl7.org/browse/FHIR-36727)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/changes.html)
7. **Applied:** Change re-associate to associate ([FHIR-36733](https://jira.hl7.org/browse/FHIR-36733)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/attachments.html)
8.  **Applied:** Fix Typo([FHIR-36736](https://jira.hl7.org/browse/FHIR-36736)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/signed-searchset-bundle-example.html)
9.  **Applied:** Clarify the relation between CDEX and HRex ([FHIR-36741](https://jira.hl7.org/browse/FHIR-36741)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/index.html#about-this-guide)
10. **Applied:** Submit Attachment AttachTo text correction ([FHIR-36756](https://jira.hl7.org/browse/FHIR-36756)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/OperationDefinition-submit-attachment.html)
12. **Applied:** Clarify that signature element should reference an Organization or Practitioner as signer ([FHIR-36846](https://jira.hl7.org/browse/FHIR-36846)) See Changes:
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/StructureDefinition-cdex-signature-bundle.html)`
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/signatures.html#digital-signature-rules-for-cdex-fhir-bundles)
13. **Applied:** Fix grammar([FHIR-36848](https://jira.hl7.org/browse/FHIR-36848)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/direct-query.html#signatures)
14. **Applied:** Fix formatting Error to separate several entries([FHIR-36853](https://jira.hl7.org/browse/FHIR-36853)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/signatures.html#digital-signatures)
15. **Applied:** Fix capitalization([FHIR-36896](https://jira.hl7.org/browse/FHIR-36896)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/attachments.html)
16. **Applied:** Adds links to operation consistently ([FHIR-36897](https://jira.hl7.org/browse/FHIR-36897)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/attachments.html)
17. **Applied:** Rewrite digital signature functional requirements: ([FHIR-36905](https://jira.hl7.org/browse/FHIR-36905)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/signatures.html#digital-signatures)
18. **Applied:** Add conformance Verbs to Submit Attachment operation page ([FHIR-36906](https://jira.hl7.org/browse/FHIR-36906)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/OperationDefinition-submit-attachment.html)
19. **Applied:** Missing examples  ([FHIR-37245](https://jira.hl7.org/browse/FHIR-37245)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/Bundle-cdex-document-digital-sig-example.html)
20. **Applied:** Rewrite background on section on Payers([FHIR-37252](https://jira.hl7.org/browse/FHIR-37252)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/background.html#what-do-payers-do-with-clinical-information)
21. **Applied:** Clarify support for XML with signatures ([FHIR-37264](https://jira.hl7.org/browse/FHIR-37264)) See Changes:
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/signatures.html#digital-signature-rules-for-cdex-fhir-bundles)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/CapabilityStatement-data-consumer-client.html#behavior)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/CapabilityStatement-data-consumer-server.html#behavior)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/CapabilityStatement-data-source-client.html#behavior)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/CapabilityStatement-data-source-server.html#behavior)
22. **Applied:** Add clarification on how to handle reads when signatures are needed ([FHIR-37265](https://jira.hl7.org/browse/FHIR-37265)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/direct-query.html#signatures)
23. **Applied:** Update $submit-attachments diagram to show 200 w/ OperationOutcome ([FHIR-37271](https://jira.hl7.org/browse/FHIR-37271)) See Changes:
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html#technical-workflow)
    - [Here]sending-attachments.html#scenario-1b-ccda-document-attachments-submitted-prior-to-claim)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/OperationDefinition-submit-attachment.html)
24. **Applied:** Add PayerId to $submit-attachments ([FHIR-37331](https://jira.hl7.org/browse/FHIR-37331)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/OperationDefinition-submit-attachment.html)
25. **Applied:** Clarify that claim's attachment submitter is same as claim submitter ([FHIR-37332](https://jira.hl7.org/browse/FHIR-37332)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html#data-elements-for-sending-attachments)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/requesting-attachments.html#identifying-the-payer-provider-and-patient)
29. **Applied:** Add "Request Attachments" content as Draft ([FHIR-37563](https://jira.hl7.org/browse/FHIR-37563)) See Changes:
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/background.html#attachments-workflow)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/solicited-unsolicited-attachments.html)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/requesting-attachments.html)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/burden-reduction.html)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/ValueSet-cdex-claim-use.html)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/OperationDefinition-submit-attachment.html)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/StructureDefinition-cdex-patient-demographics.html)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/StructureDefinition-cdex-task-attachment-request.html)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/Task-cdex-task-example19.html)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/Task-cdex-task-example20.html)
30. **Applied:** Add CCDA example and Correct PDF example ([FHIR-37655](https://jira.hl7.org/browse/FHIR-37655)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#scenario-2)
31. **Applied:** Rewrite section on Discovery of FHIR IDs ([FHIR-37652] (https://jira.hl7.org/browse/FHIR-37652)) See Changes:  
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#discovery-of-providers-payer-and-patient-ids)
    - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/direct-query.html#discovery-of-patient-fhir-ids) 
32. **Applied:** Document how implementers locate the proper identifier ([FHIR-37651](https://jira.hl7.org/browse/FHIR-37651)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/OperationDefinition-submit-attachment.html)
33. **Applied:** Clarify how to fetch data if can not perform a direct query. ([FHIR-37649](https://jira.hl7.org/browse/FHIR-37649)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#fetching-the-data)

---

### Version = 1.1.0-ballot
- Publication Date: 2022-03-25
- Based on FHIR version : 4.0.1

#### Changes:
 Da Vinci CDEX 2022 May Ballot. This ballot is restricted to the *Draft content* in the STU 1.0 version of CDex.  The draft content includes handling of Attachments and Digital Signatures.

---

### Version = 1.0.0
- Publication Date: 2022-03-25
- URL: <https://hl7.org/fhir/us/davinci-cdex/STU1/>
- Based on FHIR version : 4.0.1


#### Changes:
 This STU1 version of Da Vinci Clinical Data Exchange (CDex) Implementation Guide is the first published version of this guide and is the result of the June 2019 and January 2021 HL7 balloting process. The resulting resolution of the community comments and edits to the guide has been agreed to and voted on by the members of the sponsoring HL7 International Patient Care Work Group.

January 2021 Ballot comments and links to the updated content are below::

**Status: Summary (Jira Issue) Link to Change**

1. **Applied**: CDex documents require signature, but do not explain how used ([FHIR-26855](https://jira.hl7.org/browse/FHIR-26855)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/signatures.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/direct-query.html#signatures)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html#signatures
)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/attachments.html#signatures)
2. **Applied**: Add reference to C-CDA on FHIR ([FHIR-28158](https://jira.hl7.org/browse/FHIR-28158)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html#home)
3. **Applied**: Provide another example of a use case not covered by another Da Vinci IG ([FHIR-30146](https://jira.hl7.org/browse/FHIR-30146)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html##where-does-cdex-fit-in-the-da-vinci-project)
4. **Applied**: Fix link and expectations to CapabilityStatements ([FHIR-30147](https://jira.hl7.org/browse/FHIR-30147)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/CapabilityStatement-data-source-server.html#resource-details)
5. **Applied**: Failed task or task without result? ([FHIR-30148](https://jira.hl7.org/browse/FHIR-30148)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/CapabilityStatement-data-source-server.html#task)
6. **Applied**: add item to list of benefits ([FHIR-30440](https://jira.hl7.org/browse/FHIR-30440)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html#home)
7. **Applied**: Update section on What Payers Do with Clinical Information ([FHIR-30442](https://jira.hl7.org/browse/FHIR-30442)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#what-do-payers-do-with-clinical-information)
8. **Applied**: Update text in sequence diagrams ([FHIR-30445](https://jira.hl7.org/browse/FHIR-30445)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#steps)
9. **Applied**: Update Scenarios to include to support claim submission - Attachments. ([FHIR-30446](https://jira.hl7.org/browse/FHIR-30446)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#example-scenarios)
10. **Applied**: Update definition of clinical data and added guidance on data provenance([FHIR-30489](https://jira.hl7.org/browse/FHIR-30489)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/direct-query.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html#provenance)
11. **Applied**: Referennce clinical safety section in HREX ([FHIR-30490](https://jira.hl7.org/browse/FHIR-30490)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/security.html#da-vinci-hrex-security-and-privacy-requirements)
12. **Applied**: Delete use of word "complete" ([FHIR-30494](https://jira.hl7.org/browse/FHIR-30494)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#what-do-payers-do-with-clinical-information)
13. **Applied**: Explicitly reference the Da Vinci Guiding Principles in new Privacy and Security section. ([FHIR-30498](https://jira.hl7.org/browse/FHIR-30498)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/security.html)
14. **Applied**: Update Figure 1 ([FHIR-30500](https://jira.hl7.org/browse/FHIR-30500)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#where-does-cdex-fit-in-the-da-vinci-project)
15. **Applied**: Typo. ([FHIR-30812](https://jira.hl7.org/browse/FHIR-30812)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html#home)
16. **Applied**: Remove word complete. ([FHIR-30813](https://jira.hl7.org/browse/FHIR-30813)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#example-scenarios)
17. **Applied**: Corrects and clarifies direct provider to provider scenario. ([FHIR-30814](https://jira.hl7.org/browse/FHIR-30814)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#example-scenarios)
18. **Applied**: Updates to Provider to Provider use case([FHIR-30815](https://jira.hl7.org/browse/FHIR-30815)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/specification.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#provider-to-provider-data-exchange)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/exchanging-clinical-data.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#provider-to-provider)
19. **Applied**: Please clarify whether any human involvement is required, and an example, as well as define the term fulfillment as it relates to attestation. ([FHIR-30816](https://jira.hl7.org/browse/FHIR-30816)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/signatures.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/direct-query.html#signatures)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html#signatures
)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/attachments.html#signatures)
20. **Applied**: Rephrase. ([FHIR-30817](https://jira.hl7.org/browse/FHIR-30817)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/direct-query.html)
21. **Applied**: Clarify how subscripition mitigates risks ([FHIR-30819](https://jira.hl7.org/browse/FHIR-30819)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
22. **Applied**: Add section on termination of access to request([FHIR-30820](https://jira.hl7.org/browse/FHIR-30820)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html#how-long-is-the-data-availablehow-long-is-the-data-available)
23. **Applied**: Update how a clients set of requests is terminated([FHIR-30821](https://jira.hl7.org/browse/FHIR-30821)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html#fetching-the-datafetching-the-data)
24. **Applied**: Formalize the current scenarios ([FHIR-30826](https://jira.hl7.org/browse/FHIR-30826)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html)
25. **Applied**: replace /Patient/$everything with /Group/$export in the bulk example ([FHIR-30827](https://jira.hl7.org/browse/FHIR-30827)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/exchanging-clinical-data.html)
26. **Applied**: Remove empty pages ([FHIR-30828](https://jira.hl7.org/browse/FHIR-30828))
27. **Applied**: Clarified formal authorization use case ([FHIR-30829](https://jira.hl7.org/browse/FHIR-30829)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
28. **Applied**: Data Consumer Server SHOULD support Claim. ([FHIR-30830](https://jira.hl7.org/browse/FHIR-30830)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/CapabilityStatement-data-source-server.html#claim)
29. **Applied**: Modify CapabilityStatement Rest summary table ([FHIR-30831](https://jira.hl7.org/browse/FHIR-30831)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/CapabilityStatement-data-consumer-server.html#resource--details)
30. **Applied**: Add hyperlinks. ([FHIR-30834](https://jira.hl7.org/browse/FHIR-30834)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/specification.html)
31. **Applied**: Add benefit of transition towards direct queries to Task benefits. ([FHIR-30835](https://jira.hl7.org/browse/FHIR-30835)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html
32. **Appied**: Update section on Authoization requirements ([FHIR-30836](https://jira.hl7.org/browse/FHIR-30836)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html
33. **Applied**: Typo ([FHIR-30840](https://jira.hl7.org/browse/FHIR-30840)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html#home)
34. **Applied**: Typo ([FHIR-30841](https://jira.hl7.org/browse/FHIR-30841)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html#home)
35. **Applied**: Typo ([FHIR-30842](https://jira.hl7.org/browse/FHIR-30842)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html#home)
36. **Applied**: Updated anticipated benefits of standard ([FHIR-30843](https://jira.hl7.org/browse/FHIR-30843)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html#home)
37. **Applied**: Typo ([FHIR-30844](https://jira.hl7.org/browse/FHIR-30844)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#what-do-payers-do-with-clinical-information)
38. **Applied**: Correct Grammar ([FHIR-30845](https://jira.hl7.org/browse/FHIR-30845)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#what-do-payers-do-with-clinical-information)
39. **Applied**: Correct Grammar ([FHIR-30846](https://jira.hl7.org/browse/FHIR-30846)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#what-do-payers-do-with-clinical-information)
40. **Applied**: Remove unsubstantiated claims. ([FHIR-30847](https://jira.hl7.org/browse/FHIR-30847)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#what-do-payers-do-with-clinical-information)
41. **Applied**: Remove HEDIS score claim. ([FHIR-30849](https://jira.hl7.org/browse/FHIR-30849)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#what-do-payers-do-with-clinical-information)
42. **Applied**: Relocate paragraph. ([FHIR-30850](https://jira.hl7.org/browse/FHIR-30850)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#actors-and-roles)
43. **Applied**: Remove paragraph and refer to HREX security page. ([FHIR-30851](https://jira.hl7.org/browse/FHIR-30851)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/security.html)
44. **Applied**: Typo ([FHIR-30852](https://jira.hl7.org/browse/FHIR-30852)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#where-does-cdex-fit-in-the-da-vinci-project)
45. **Applied**: Reword statement. ([FHIR-30853](https://jira.hl7.org/browse/FHIR-30853)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#where-does-cdex-fit-in-the-da-vinci-project)
46. **Applied**: Typo ([FHIR-30854](https://jira.hl7.org/browse/FHIR-30854)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#example-scenarios)
47. **Applied**: Typo ([FHIR-30855](https://jira.hl7.org/browse/FHIR-30855)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#example-scenarios)
48. **Applied**: Typo ([FHIR-30856](https://jira.hl7.org/browse/FHIR-30856)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#steps)
49. **Applied**: Typo ([FHIR-30857](https://jira.hl7.org/browse/FHIR-30857)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#steps)
50. **Applied**: Updated STU-note on when authorization needed? ([FHIR-30863](https://jira.hl7.org/browse/FHIR-30863)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html#formal-authorization
51. **Applied**: Remove "?" or correct the section name if it is in question ([FHIR-30864](https://jira.hl7.org/browse/FHIR-30864)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
52. **Applied**: Typo ([FHIR-30865](https://jira.hl7.org/browse/FHIR-30865)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
53. **Applied**: Updated Purpose of Use section for Direct Query. ([FHIR-30867](https://jira.hl7.org/browse/FHIR-30867)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/direct-query.html)
54. **Applied**: Updated Sensitivity and Confidentiality protection guidance. ([FHIR-30868](https://jira.hl7.org/browse/FHIR-30868)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/security.html#sensitive-and-confidential-data)
55. **Applied**: Updated Sensitivity and Confidentiality protection guidance. ([FHIR-30869](https://jira.hl7.org/browse/FHIR-30869)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/security.html#sensitive-and-confidential-data)
56. **Applied**: clarify when attribution is not present or non-repudiable ([FHIR-30870](https://jira.hl7.org/browse/FHIR-30870)) various changes
57. **Applied**: Fix sequential numbering of figures  ([FHIR-30935](https://jira.hl7.org/browse/FHIR-30935)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/specification.html)
58. **Applied**: correct last example bullet ([FHIR-31050](https://jira.hl7.org/browse/FHIR-31050)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#provider-to-provider-data-exchange)
59. **Applied**: Remove reference to HREX CommunicationRequest plus Task transaction ([FHIR-31516](https://jira.hl7.org/browse/FHIR-31516)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
60. **Applied**: Clarify human involvement in Task transaction ([FHIR-31886](https://jira.hl7.org/browse/FHIR-31886) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
61. **Applied**: Create privacy and security page ([FHIR-31885](https://jira.hl7.org/browse/FHIR-31885) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/security.html)
62. **Applied**: Clarify when HIEs are data sources ([FHIR-31884](https://jira.hl7.org/browse/FHIR-31884))[See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#actors-and-roles)
63. **Applied**: Add supplemental security guidance on audit ([FHIR-31888](https://jira.hl7.org/browse/FHIR-31888))[See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/security.html#general-considerations)
64. **Applied**: Add supplemental security guidance on scopes([FHIR-31887](https://jira.hl7.org/browse/FHIR-31887))[See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/security.html#general-considerations)
65. **Applied**: Clarify human involvement needed([FHIR-31886](https://jira.hl7.org/browse/FHIR-31886))[See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
66. **Applied**: Provide guidance on finding organization and provider identifiers([FHIR-32841](https://jira.hl7.org/browse/FHIR-32841))[See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
67. **Applied**: Update how to represent Purpose of Use and reason in Task Based Query ([FHIR-31996](https://jira.hl7.org/browse/FHIR-31996))[See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
68. **Applied**: Clarify the relationship between this guide and others([FHIR-32116](https://jira.hl7.org/browse/FHIR-32116))[See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#where-does-cdex-fit-in-the-da-vinci-project)
69. **Applied**: Added guidance on matching patients([FHIR-32840](https://jira.hl7.org/browse/FHIR-32840))[See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html#discovery-of-fhir-ids)
70. **Applied**: Update to the USCDI link ([FHIR-33265](https://jira.hl7.org/browse/FHIR-33265)
71. **Applied**: Add guidance how to provide some work queue tags([FHIR-31890](https://jira.hl7.org/browse/FHIR-31890) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html#work-queues)
72. **Applied**: Add push mechanism to support Attachments for Claims and Prior Auth([FHIR-33129](https://jira.hl7.org/browse/FHIR-33129) See Changes:
  - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#attachments-workflow)
  - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/attachments.html)
  - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/OperationDefinition-submit-attachment.html)
73. **Applied**: Add figure to clarify relationship between cdex and hrex([FHIR-34559](https://jira.hl7.org/browse/FHIR-34559) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html#about-this-guide)

---

### Version = 0.2.0
- Publication Date: 2020-10-23
- URL: <http://hl7.org/fhir/us/davinci-cdex/2021Jan>
- Based on FHIR version : 4.0.1


#### Changes:
 Based on the 2019-06-20 ballot feedback, this IG has been completely re-written for this ballot. The refactoring has been sufficiently large that it is not practical/useful to enumerate a list of changes between this ballot version (0.2.0) and the 2019-06-20 ballot version (0.1.0).

---

### Version = 0.1.0
- Publication Date: 2019-06-18
- URL: <http://hl7.org/fhir/us/davinci-cdex/2019Jun>
- Based on FHIR version : 4.0.0


#### Changes:
 June 2019 Ballot for Da Vinci CDex

---

{% include link-list.md %}
