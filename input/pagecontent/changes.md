### Version = 2.0.0
- Publication Date: 2023-01-30
- URL: <http://hl7.org/fhir/us/davinci-cdex/STU2>
- Based on FHIR version: 4.0.1

This STU2 version of The Da Vinci Clinical Data Exchange (CDex) Implementation Guide is the third published version of this guide and is the result of the 2022 September HL7 balloting process. The resulting resolution of the community comments and edits to this guide has been agreed to and voted on by the members of the sponsoring HL7 International Patient Care and Payer/Provider Information Exchange Work Groups.

#### What's new in Version 2.0.0 of CDex:

1. New [Requesting Attachments Using Questionnaires] functionality. In prior versions, CDex supported requested attachments using the request model of LOINC attachment codes, and the provider typically submitted CCDA or PDF documents in response. In this version, CDex aligns with DTR functionality and provide the ability to request attachment using Questionnaire, CQL, and QuestionnaireResponse as supported by DTR when there is no transition into/out of X12 transactions in the interactions. In addition, this approach will enable specific requests for missing data and avoid unnecessary document formats, yet still provide the ability for signature attestation if required.
2. New Task-Based transactions functionality for [Using Questionnaire as Task Input]. In prior versions, CDex Task Based Approach supported requests using the request model of FHIR RESTful query syntax, codes, and free-text. As a result, the provider typically returned references to FHIR Bundles. Similar to the Attachments updates, this added functionality leverages DTR and enables specific requests for missing data, avoiding unnecessary use of Bundles.
3. Improved navigation:
   - Menu Bar drop-downs for all the pages to allow faster navigation to a specific topic
   - Re-organization of [FHIR Artifacts] by transaction type. This version has several FHIR artifacts and dozens of examples grouped by Attachments, Task-Based Approach, and Signatures.
4. [Conforming to CDex Attachments] and [Conforming to CDex Task Based Approach], including interactions for each role and the conformance resource and terminology that makes them unique.
5. After receiving many comments on CDex POU support, the [CDex Purpose of Use Value Set] now includes a hierarchy to the base "Treatment", "Payment", or "Health Care Operations" (TPO) concepts.
6. More examples, including examples of failed signature verifications, signed QuestionnaireResponse, and requesting Attachments for prior authorization using Questionnaire.

#### Changes:

These changes are the result of over 60 trackers listed below. They include the 2022 September HL7 balloting process and non-ballot issues.

##### September 2022 ballot and non-ballot comments and links to the updated content are below:

**Status: Summary (Jira Issue) Link to Change**

1. **Applied**: Correct $submit-attachment input parameter Typo. ([FHIR-37956](https://jira.hl7.org/browse/FHIR-37956)) and ([FHIR-38175](https://jira.hl7.org/browse/FHIR-38175)) See Changes [Here](OperationDefinition-submit-attachment.html)
2. **Applied**: Correct claim flow diagram typo ([FHIR-38060](https://jira.hl7.org/browse/FHIR-38060)) See Changes [Here](solicited-unsolicited-attachments.html#solicited-attachments)
4. **Applied**: Added missing service line item extension to CDex Task Attachment Request Profile ([FHIR-38070](https://jira.hl7.org/browse/FHIR-38070)) See Changes [Here](StructureDefinition-cdex-task-attachment-request.html)
5. **Applied**: Document POU ValueSet Hierarchy to TPO ([FHIR-38142](https://jira.hl7.org/browse/FHIR-38142)) See Changes [Here](ValueSet-cdex-POU.html)
6. **Applied**: DS4P should be evaluated before required ([FHIR-38144](https://jira.hl7.org/browse/FHIR-38144)) See Changes [Here](security.html#sensitive-and-confidential-data)
7. **Applied**: Correct capitalization ([FHIR-38145](https://jira.hl7.org/browse/FHIR-38145)) See Changes [Here](solicited-unsolicited-attachments.html)
9. **Applied**: Change 277 to: “277 Request for Additional Information (RFAI)” ([FHIR-38152](https://jira.hl7.org/browse/FHIR-38152)) See Changes [Here](requesting-attachments-code.html#step-by-step-solicited-attachment-transaction)
10. **Applied**: Update sentence ([FHIR-38153](https://jira.hl7.org/browse/FHIR-38153)) See Changes [Here](requesting-attachments-code.html)
11. **Applied**: Correct Typo ([FHIR-38154](https://jira.hl7.org/browse/FHIR-38154)) See Changes [Here](requesting-attachments-code.html#requesting-attachments-using-fhir)
12. **Applied**: Modify sentence ([FHIR-38155](https://jira.hl7.org/browse/FHIR-38155)) See Changes [Here](requesting-attachments-code.html#step-by-step-solicited-attachment-transaction)
13. **Applied**: Change X12n 277 *message* to X12n 277 *RFAI transaction*. ([FHIR-38156](https://jira.hl7.org/browse/FHIR-38156)) See Changes [Here](requesting-attachments-code.html#step-by-step-solicited-attachment-transaction)
14. **Applied**: Update Data Elements table ([FHIR-38172](https://jira.hl7.org/browse/FHIR-38172)) See Changes [Here](requesting-attachments-code.html#data-elements-for-requesting-attachments) and [Here](requesting-attachments-code.html#data-elements-for-requesting-attachments)
15. **Applied**: Update Data Elements table ([FHIR-38174](https://jira.hl7.org/browse/FHIR-38174)) See Changes [Here](requesting-attachments-code.html#data-elements-for-requesting-attachments)
17. **Applied**:Change X12n 275 *message* to X12n 275 *transaction* ([FHIR-38177](https://jira.hl7.org/browse/FHIR-38177)) See Changes [Here](requesting-attachments-code.html#step-by-step-solicited-attachment-transaction)
18. **Applied**:Change *all* documents to *submitted* documents ([FHIR-38178](https://jira.hl7.org/browse/FHIR-38178)) See Changes [Here](requesting-attachments-code.html#step-by-step-solicited-attachment-transaction)
19. **Applied**: Remove HIPAA compliance language ([FHIR-38179](https://jira.hl7.org/browse/FHIR-38179)) See Changes [Here](requesting-attachments-code.html#verifying-patient-identity)
20. **Applied**: Change *Claim* to *claim or prior authorization* ([FHIR-38184](https://jira.hl7.org/browse/FHIR-38184)) See Changes [Here](requesting-attachments-code.html#verifying-patient-identity)
21. **Applied**: Normalize term “prior authorization” ([FHIR-38186](https://jira.hl7.org/browse/FHIR-38186)) See Changes [Here](requesting-attachments-code.html)
22. **Applied**: Update Grammar ([FHIR-38187](https://jira.hl7.org/browse/FHIR-38187)) See Changes [Here](requesting-attachments-code.html#supply-the-requested-attachments-for-each-line-item-and-code)
23. **Applied**: Clarify that signature support is not required ([FHIR-38188](https://jira.hl7.org/browse/FHIR-38188)) See Changes [Here](signatures.html) and [Here](sending-attachments.html#signatures)
24. **Applied**: Clarify in operation that either an OrganizationId or ProviderId is required. Allow for both Ids to be sent in request.([FHIR-38189](https://jira.hl7.org/browse/FHIR-38189)) See Changes:[
   - [Here](OperationDefinition-submit-attachment.html) 
   - [Here](StructureDefinition-cdex-practitionerrole.html)
   - [Here](StructureDefinition-cdex-task-attachment-request.html) 
   - [Here](requesting-attachments-code.html#identifying-the-payer-provider-and-patient)
25. **Applied**: Change Task service date input parameter to min = 0 and required only for claims ([FHIR-38191](https://jira.hl7.org/browse/FHIR-38191)) See Changes [Here](StructureDefinition-cdex-task-attachment-request.html) and [Here](requesting-attachments-code.html#date-of-service-for-the-claim) 
26. **Applied**: Clarify conformance expectations ([FHIR-38192](https://jira.hl7.org/browse/FHIR-38192)) See Changes [Here](attachments-conformance.html) and [Here](task-based-conformance.html)
27. **Applied**: Clarify patient account number ([FHIR-38194](https://jira.hl7.org/browse/FHIR-38194)) See Changes [Here](requesting-attachments-code.html#data-elements-for-requesting-attachments)
28. **Applied**: Task Infrastructure Elements ([FHIR-38195](https://jira.hl7.org/browse/FHIR-38195)) See Changes [Here](requesting-attachments-code.html#task-status-intent-and-code-elements)
30. **Applied**: Separate solicited and unsolicited attachments workflows ([FHIR-38210](https://jira.hl7.org/browse/FHIR-38210)) See Changes [Here](background.html#workflow-overview)
31. **Applied**: Make LOINC code display and text consistent ([FHIR-38233](https://jira.hl7.org/browse/FHIR-38233)) See Changes [Here](Parameters-cdex-parameters-example1.json.html)
32. **Applied**: Fix Typo in example ([FHIR-38236](https://jira.hl7.org/browse/FHIR-38236))w See Changes [Here](Parameters-cdex-parameters-example4.html)
33. **Applied**: Clarify Attachment Scope ([FHIR-38240](https://jira.hl7.org/browse/FHIR-38240)) See Changes [Here](solicited-unsolicited-attachments.html)
34. **Applied**: Expand Attachments and Task based approach to support Questionnaires and DTR ([FHIR-38241](https://jira.hl7.org/browse/FHIR-38241)) See Changes:
    - Pages:
      - [Here](task-based-approach.html#using-questionnaire-as-task-input)
      - [Here](requesting-attachments-questionnaire.html)
    - Conformance Artifacts:
      - [Here](StructureDefinition-cdex-task-attachment-request.html)
      - [Here](ValueSet-cdex-attachment-task-code.html)
      - [Here](StructureDefinition-cdex-task-data-request.html)
      - [Here](ValueSet-cdex-data-request-task-code.html)
      - [Here](CodeSystem-cdex-temp.html)
    - Examples:
      - [Here](Task-cdex-task-example22.html)
      - [Here](Task-cdex-task-example23.html)
      - [Here](Task-cdex-task-example24.html)
      - [Here](Task-cdex-task-example25.html)
      - [Here](Task-cdex-task-example26.html)
      - [Here](Task-cdex-task-example27.html)
      - [Here](Task-cdex-task-example28.html)
      - [Here](Task-cdex-task-example29.html)
      - [Here](Task-cdex-task-example30.html)
      - [Here](Task-cdex-task-example31.html)
      - [Here](Parameters-cdex-parameters-example5.html)
      - [Here](Questionnaire-cdex-questionnaire-example1.html)
      - [Here](Questionnaire-cdex-questionnaire-example2.html)
      - [Here](QuestionnaireResponse-cdex-questionnaireresponse-example1.html)
      - [Here](QuestionnaireResponse-cdex-questionnaireresponse-example2.html)
      - [Here](QuestionnaireResponse-cdex-questionnaireresponse-example3.html)
      - [Here](QuestionnaireResponse-cdex-questionnaireresponse-example4.html)
35. **Applied**: Clarify when human involvement needed ([FHIR-38242](https://jira.hl7.org/browse/FHIR-38242)) See Changes [Here](task-based-approach.html#sequence-diagram)
36. **Applied**: Add link to PAS Guidance on pended results ([FHIR-38244](https://jira.hl7.org/browse/FHIR-38244)) See Changes [Here](burden-reduction.html)
37. **Applied**: Add POU for Attachment Request as optional input parameter ([FHIR-38245](https://jira.hl7.org/browse/FHIR-38245)) See Changes [Here](StructureDefinition-cdex-task-attachment-request.html) and [Here](requesting-attachments-code.html#purpose-of-use-for-the-request) 
38. **Applied**: Correct operation name ([FHIR-38253](https://jira.hl7.org/browse/FHIR-38253)) See Changes [Here](requesting-attachments-code.html#data-elements-for-requesting-attachments)
39. **Applied**: Change *only accepts* to *only accept*([FHIR-38255](https://jira.hl7.org/browse/FHIR-38255)) See Changes [Here](OperationDefinition-submit-attachment.html)
40. **Applied**: Clarify use of cdex-temp code system ([FHIR-38259](https://jira.hl7.org/browse/FHIR-38259)) See Changes [Here](ValueSet-cdex-POU.html) and [Here](CodeSystem-cdex-temp.html)
41. **Applied**: Clarify use of data tagging ([FHIR-38286](https://jira.hl7.org/browse/FHIR-38286)) See Changes [Here](security.html#sensitive-and-confidential-data)
42. **Applied**: Updated X12 element mappings and X12 required citations ([FHIR-38287](https://jira.hl7.org/browse/FHIR-38287)) See Changes [Here](requesting-attachments-code.html#data-elements-for-requesting-attachments) and Changes [Here](sending-attachments.html#data-elements-for-sending-attachments)
43. **Applied**: Clarify how to find patient FHIR ID ([FHIR-38318](https://jira.hl7.org/browse/FHIR-38318)) See Changes [Here](direct-query.html#discovery-of-patient-fhir-ids)
44. **Applied**: Clarify X12 Compatibility ([FHIR-38326](https://jira.hl7.org/browse/FHIR-38326)) See Changes [Here](sending-attachments.html#sending-attachments)
45. **Applied**: Add Qualifier to Signed Document Bundle ([FHIR-38327](https://jira.hl7.org/browse/FHIR-38327)) See Changes [Here](signatures.html#step-by-step-examples)
46. **Applied**: Remove words *transaction layer* ([FHIR-38328](https://jira.hl7.org/browse/FHIR-38328)) See Changes [Here](sending-attachments.html#technical-workflow)
47. **Applied**: Word change *analogs* to *fields* ([FHIR-38330](https://jira.hl7.org/browse/FHIR-38330)) See Changes [Here](sending-attachments.html#data-elements-for-sending-attachments)
48. **Applied**: Correct rendering of CCDA ([FHIR-38367](https://jira.hl7.org/browse/FHIR-38367)) See Changes [Here](task-based-approach.html#surgical-notes-as-ccda-documents)
49. **Applied**: removed '*' from button bar ([FHIR-38368](https://jira.hl7.org/browse/FHIR-38368)) See Changes [Here](task-based-approach.html#example-of-a-signed-task-based-transaction)
50. **Applied**: Change *follows* to *adheres to* ([FHIR-38576](https://jira.hl7.org/browse/FHIR-38576)) See Changes [Here](index.html#about-this-guide)
51. **Applied**: Revise section 'what Do Payers Do with Clinical Information?' ([FHIR-38578](https://jira.hl7.org/browse/FHIR-38578)) See Changes [Here](background.html)
52. **Applied**: Clarify when CDex is used instead of other guides ([FHIR-38585](https://jira.hl7.org/browse/FHIR-38585)) See Changes [Here](background.html#where-does-cdex-fit-in-the-da-vinci-project)
53. **Applied**: Remove the HIE paragraph ([FHIR-38588](https://jira.hl7.org/browse/FHIR-38588)) See Changes [Here](background.html#actors-and-roles)
54. **Applied**: Create failed signature example transaction ([FHIR-38596](https://jira.hl7.org/browse/FHIR-38596)) See Changes [Here](sending-attachments.html#signatures)
55. **Applied**: Clarify benefits of POU element ([FHIR-38598](https://jira.hl7.org/browse/FHIR-38598)) See Changes [Here](#)
56. **Applied**: change SHOULD to SHALL ([FHIR-38599](https://jira.hl7.org/browse/FHIR-38599)) See Changes [Here](task-based-approach.html#task-reason)
57. **Applied**: Correct Preconditions and Assumptions ([FHIR-38600](https://jira.hl7.org/browse/FHIR-38600)) See Changes [Here](task-based-approach.html#scenario-2)
58. **Applied**: Correct Preconditions and Assumptions ([FHIR-38601](https://jira.hl7.org/browse/FHIR-38601)) See Changes [Here](task-based-approach.html#scenario-2)
59. **Applied**: Update polling frequency guidance([FHIR-38602](https://jira.hl7.org/browse/FHIR-38602)) See Changes [Here](task-based-approach.html#polling)
60. **Applied**: Remove trading partner agreement statement ([FHIR-38603](https://jira.hl7.org/browse/FHIR-38603)) See Changes [Here](solicited-unsolicited-attachments.html#unsolicited-attachments)
61. **Applied**: Clarify association comment and assign FMM levels to guide  ([FHIR-38605](https://jira.hl7.org/browse/FHIR-38605)) See Changes [Here](background.html#steps-2)
62. **Applied**: Clarify Profile relationship to X12  ([FHIR-38612](https://jira.hl7.org/browse/FHIR-38612)) See Changes [Here](requesting-attachments-code.html#cdex-attachment-request-profile)
63. **Applied**: Change $submit-attachment's Attachment input parameter to min=1. ([FHIR-38632](https://jira.hl7.org/browse/FHIR-38632)) See Changes [Here](OperationDefinition-submit-attachment.html)
64. **Applied**: Change Tracking-id.system to Must Support; and $submit-attachment TrackingId to type Identifier. ([FHIR-39337](https://jira.hl7.org/browse/FHIR-39337)) See Changes [Here](OperationDefinition-submit-attachment.html) and [Here](StructureDefinition-cdex-task-attachment-request.html)
65. **Applied**: Update NPI codesystem  ([FHIR-39626](https://jira.hl7.org/browse/FHIR-39626)) See Changes [Here](ValueSet-cdex-identifier-types.html)

### Version = 2.0.0-ballot
- Publication Date: 2022-08-01
- URL: <http://hl7.org/fhir/us/davinci-cdex/2022Sep>
- Based on FHIR version: 4.0.1

#### Changes:
Da Vinci CDEX 2022 September Ballot. This ballot is restricted to the *Draft* content in the STU 1.1.0 version of CDex. The draft content includes 1) requesting and sending attachments and 2) communicating the purpose of use in Task Based Queries.

### Version = 1.1.0
- Publication Date: 2022-08-01
- URL: <http://hl7.org/fhir/us/davinci-cdex/STU1.1>
- Based on FHIR version: 4.0.1

This STU1.1 version of The Da Vinci Clinical Data Exchange (CDex) Implementation Guide is the second published version of this guide and is the result of the 2022 May HL7 balloting process. The resulting resolution of the community comments and edits to the guide has been agreed to and voted on by the members of the sponsoring HL7 International Patient Care and Payer/Provider Information Exchange Work Groups.

#### What’s new in Version 1.1.0 of CDex:

- <span class="bg-warning">This content is DRAFT and is open for review.</span> An [Attachments] section  documenting how to exchange attachments for claims or prior authorization.
    - A [Solicited and Unsolicited Attachments] page documents the differences and similarities between solicited and unsolicited attachments workflows and the CDex transactions that can be used for each.
    - A [Sending Attachments] page that documents a FHIR-based approach for sending attachments for claims or prior authorization directly to a Payer.
    - A [Requesting Attachments] page to document a FHIR-based approach for requesting attachments for claims or prior authorization from a Provider.
    - A [Using CDex Attachments with DaVinci PAS] page that illustrates where in the PAS workflow the Payer could use CDEX to request attachments and the Provider could use CDEX to submit attachments.
-  [Signatures] page sections for each transaction in CDex to provide specific guidance and rules to exchange *signed* data using FHIR and non-FHIR signatures. 
- A [Change Log] page to document the changes across the versions of CDex
- More [examples](artifacts.html#6) and example scenarios
  
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
  - [Various examples such as Here](Task-cdex-task-example1.html)
  - [Various example scenarios such as Here](task-based-approach.html#step-1---post-task-to-provider-endpoint)
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
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/signatures.html#digital-signature-rules-for-cdex-fhir-bundles)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/CapabilityStatement-data-consumer-client.html#behavior)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/CapabilityStatement-data-consumer-server.html#behavior)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/CapabilityStatement-data-source-client.html#behavior)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/CapabilityStatement-data-source-server.html#behavior)
22. **Applied:** Add clarification on how to handle reads when signatures are needed ([FHIR-37265](https://jira.hl7.org/browse/FHIR-37265)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/direct-query.html#signatures)
23. **Applied:** Update $submit-attachments diagram to show 200 w/ OperationOutcome ([FHIR-37271](https://jira.hl7.org/browse/FHIR-37271)) See Changes:
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html#technical-workflow)
    -  [Here]sending-attachments.html#scenario-1b-ccda-document-attachments-submitted-prior-to-claim)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/OperationDefinition-submit-attachment.html)
24. **Applied:** Add PayerId to $submit-attachments ([FHIR-37331](https://jira.hl7.org/browse/FHIR-37331)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/OperationDefinition-submit-attachment.html)
25. **Applied:** Clarify that claim's attachment submitter is same as claim submitter ([FHIR-37332](https://jira.hl7.org/browse/FHIR-37332)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html#data-elements-for-sending-attachments)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/requesting-attachments.html#identifying-the-payer-provider-and-patient)
29. **Applied:** Add "Request Attachments" content as Draft ([FHIR-37563](https://jira.hl7.org/browse/FHIR-37563)) See Changes:
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/background.html#attachments-workflow)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/solicited-unsolicited-attachments.html)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/sending-attachments.html)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/requesting-attachments.html)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/burden-reduction.html)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/ValueSet-cdex-claim-use.html)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/OperationDefinition-submit-attachment.html)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/StructureDefinition-cdex-patient-demographics.html)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/StructureDefinition-cdex-task-attachment-request.html)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/Task-cdex-task-example19.html)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/Task-cdex-task-example20.html)
30. **Applied:** Add CCDA example and Correct PDF example ([FHIR-37655](https://jira.hl7.org/browse/FHIR-37655)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#scenario-2)
31. **Applied:** Rewrite section on Discovery of FHIR IDs ([FHIR-37652] (https://jira.hl7.org/browse/FHIR-37652)) See Changes:  
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#discovery-of-providers-payer-and-patient-ids)
    -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/direct-query.html#discovery-of-patient-fhir-ids) 
32. **Applied:** Document how implementers locate the proper identifier ([FHIR-37651](https://jira.hl7.org/browse/FHIR-37651)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/OperationDefinition-submit-attachment.html)
33. **Applied:** Clarify how to fetch data if can not perform a direct query. ([FHIR-37649](https://jira.hl7.org/browse/FHIR-37649)) See Changes [Here](http://hl7.org/fhir/us/davinci-cdex/STU1.1/task-based-approach.html#fetching-the-data)

---

### Version = 1.1.0-ballot
- Publication Date: 2022-03-25
- URL: <http://hl7.org/fhir/us/davinci-cdex/2022May>
- Based on FHIR version : 4.0.1


#### Changes:
 Da Vinci CDEX 2022 May Ballot. This ballot is restricted to the *Draft content* in the STU 1.0 version of CDex.  The draft content includes handling of Attachments and Digital Signatures.

---

### Version = 1.0.0
- Publication Date: 2022-03-25
- URL: <http://hl7.org/fhir/us/davinci-cdex/STU1>
- Based on FHIR version : 4.0.1


#### Changes:
 This STU1 version of Da Vinci Clinical Data Exchange (CDex) Implementation Guide is the first published version of this guide and is the result of the June 2019 and January 2021 HL7 balloting process. The resulting resolution of the community comments and edits to the guide has been agreed to and voted on by the members of the sponsoring HL7 International Patient Care Work Group.

January 2021 Ballot comments and links to the updated content are below::

**Status: Summary (Jira Issue) Link to Change**

1. **Applied**: CDex documents require signature, but do not explain how used ([FHIR-26855](https://jira.hl7.org/browse/FHIR-26855)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/signatures.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/direct_query#signatures.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approache#signatures.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/attachments#signatures.html)
2. **Applied**: Add reference to C-CDA on FHIR ([FHIR-28158](https://jira.hl7.org/browse/FHIR-28158)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html#home)
3. **Applied**: Provide another example of a use case not covered by another Da Vinci IG ([FHIR-30146](https://jira.hl7.org/browse/FHIR-30146)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html##where-does-cdex-fit-in-the-da-vinci-project)
4. **Applied**: Fix link and expectations to CapabilityStatements ([FHIR-30147](https://jira.hl7.org/browse/FHIR-30147)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/CapabilityStatement-data-source-server.html#resource-details)
5. **Applied**: Failed task or task without result? ([FHIR-30148](https://jira.hl7.org/browse/FHIR-30148)) See Changes:
   -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
   -  [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/CapabilityStatement-data-source-server.html#task)
6. **Applied**: add item to list of benefits ([FHIR-30440](https://jira.hl7.org/browse/FHIR-30440)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html#home)
7. **Applied**: Update section on What Payers Do with Clinical Information ([FHIR-30442](https://jira.hl7.org/browse/FHIR-30442)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/ackground.html#what-do-payers-do-with-clinical-information)
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
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/direct_query#signatures.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approache#signatures.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/attachments#signatures.html)
20. **Applied**: Rephrase. ([FHIR-30817](https://jira.hl7.org/browse/FHIR-30817)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/direct-query.html)
21. **Applied**: Clarify how subscripition mitigates risks ([FHIR-30819](https://jira.hl7.org/browse/FHIR-30819)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
22. **Applied**: Add section on termination of access to request([FHIR-30820](https://jira.hl7.org/browse/FHIR-30820)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/specification#how-long-is-the-data-available)
23. **Applied**: Update how a clients set of requests is terminated([FHIR-30821](https://jira.hl7.org/browse/FHIR-30821)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/specification#fetching-the-data)
24. **Applied**: Formalize the current scenarios ([FHIR-30826](https://jira.hl7.org/browse/FHIR-30826)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html)
25. **Applied**: replace /Patient/$everything with /Group/$export in the bulk example ([FHIR-30827](https://jira.hl7.org/browse/FHIR-30827)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/exchanging-clinical-data.html)
26. **Applied**: Remove empty pages ([FHIR-30828](https://jira.hl7.org/browse/FHIR-30828))
27. **Applied**: Clarified formal authorization use case ([FHIR-30829](https://jira.hl7.org/browse/FHIR-30829)) See Changes:
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
   - [Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
28. **Applied**: Data Consumer Server SHOULD support Claim. ([FHIR-30830](https://jira.hl7.org/browse/FHIR-30830)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/CapabilityStatement-data-source-server.html#claim)
29. **Applied**: Modify CapabilityStatement Rest summary table ([FHIR-30831](https://jira.hl7.org/browse/FHIR-30831)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/CapabilityStatement-data-consumer-server.html#resource--details)
30. **Applied**: Add hyperlinks. ([FHIR-30834](https://jira.hl7.org/browse/FHIR-30834)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/specifications)
31. **Applied**: Add benefit of transition towards direct queries to Task benefits. ([FHIR-30835](https://jira.hl7.org/browse/FHIR-30835)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/specification#task-based-approach)
32. **Appied**: Update section on Authoization requirements ([FHIR-30836](https://jira.hl7.org/browse/FHIR-30836)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/specification#formal-authorization)
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
43. **Applied**: Remove paragraph and refer to HREX security page. ([FHIR-30851](https://jira.hl7.org/browse/FHIR-30851)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/security.md)
44. **Applied**: Typo ([FHIR-30852](https://jira.hl7.org/browse/FHIR-30852)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#where-does-cdex-fit-in-the-da-vinci-project)
45. **Applied**: Reword statement. ([FHIR-30853](https://jira.hl7.org/browse/FHIR-30853)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#where-does-cdex-fit-in-the-da-vinci-project)
46. **Applied**: Typo ([FHIR-30854](https://jira.hl7.org/browse/FHIR-30854)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#example-scenarios)
47. **Applied**: Typo ([FHIR-30855](https://jira.hl7.org/browse/FHIR-30855)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#example-scenarios)
48. **Applied**: Typo ([FHIR-30856](https://jira.hl7.org/browse/FHIR-30856)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#steps)
49. **Applied**: Typo ([FHIR-30857](https://jira.hl7.org/browse/FHIR-30857)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/background.html#steps)
50. **Applied**: Updated STU-note on when authorization needed? ([FHIR-30863](https://jira.hl7.org/browse/FHIR-30863)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/specification#formal-authorization)
51. **Applied**: Remove "?" or correct the section name if it is in question ([FHIR-30864](https://jira.hl7.org/browse/FHIR-30864)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
52. **Applied**: Typo ([FHIR-30865](https://jira.hl7.org/browse/FHIR-30865)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/task-based-approach.html)
53. **Applied**: Updated Purpose of Use section for Direct Query. ([FHIR-30867](https://jira.hl7.org/browse/FHIR-30867)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/direct-query.html)
54. **Applied**: Updated Sensitivity and Confidentiality protection guidance. ([FHIR-30868](https://jira.hl7.org/browse/FHIR-30868)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/security.html#sensitive-and-confidential-data)
55. **Applied**: Updated Sensitivity and Confidentiality protection guidance. ([FHIR-30869](https://jira.hl7.org/browse/FHIR-30869)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/security.html#sensitive-and-confidential-data)
56. **Applied**: clarify when attribution is not present or non-repudiable ([FHIR-30870](https://jira.hl7.org/browse/FHIR-30870)) various changes
57. **Applied**: Fix sequential numbering of figures  ([FHIR-30935](https://jira.hl7.org/browse/FHIR-30935)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/specification.html)
58. **Applied**: correct last example bullet ([FHIR-31050](https://jira.hl7.org/browse/FHIR-31050)) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/davinci-ecdx/background.html#example-scenarios)
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
1. **Applied**: Add figure to clarify relationship between cdex and hrex([FHIR-34559](https://jira.hl7.org/browse/FHIR-34559) [See Change Here](http://hl7.org/fhir/us/davinci-cdex/STU1/index.html#about-this-guide)

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
