### Version = CI Build (1.1.0-preview)
- url: <http://build.fhir.org/ig/HL7/davinci-ecdx>
- Based on FHIR version : 4.0.1


#### Changes:
 Continuous Integration Build for version 1.1.0 preview of Da Vinci (latest in version control)

This STU1 version of Da Vinci Clinical Data Exchange (CDex) Implementation Guide is the second published version of this guide and is the result of the 2022 May HL7 balloting process, non-ballot issue,  and *Draft* new content to meet anticipated Attachments legislation and rules. The resulting resolution of the community comments and edits to the guide has been agreed to and voted on by the members of the sponsoring HL7 International Patient Care Work Group.

##### May 2022 Ballot comments and links to the updated content are below::

**Status: Summary (Jira Issue) Link to Change**

1. **Applied:** speling ([FHIR-36819](https://jira.hl7.org/browse/FHIR-36819)) See Changes [Here](#.html)
1. **Applied:** simple edits ([FHIR-36820](https://jira.hl7.org/browse/FHIR-36820)) See Changes [Here](#.html)
1. **Applied:** minor edits ([FHIR-36821](https://jira.hl7.org/browse/FHIR-36821)) See Changes [Here](#.html)
1. **Resolved - change required:** Nothing displayed for example ([FHIR-36822](https://jira.hl7.org/browse/FHIR-36822)) See Changes [Here](#.html)
1. **Resolved - change required:** nothing displayed for CDEX Document with Electronic Sig Example ([FHIR-36823](https://jira.hl7.org/browse/FHIR-36823)) See Changes [Here](#.html)
1. **Triaged:** Add guidance and requiriements for when Signatures fail verification ([FHIR-36842](https://jira.hl7.org/browse/FHIR-36842)) See Changes [Here](#.html)
2. **Pre-Applied:** Add link to Example of Completed Task Request for Signed Data([FHIR-36844](https://jira.hl7.org/browse/FHIR-36844)) See Changes [Here](Task-cdex-task-example18.html)
3. **Triaged:** Need clarification on who is signing for whom ([FHIR-36845](https://jira.hl7.org/browse/FHIR-36845)) See Changes [Here](#.html)
4. **Triaged:** Can providers forward supporting documents from another system? ([FHIR-36847](https://jira.hl7.org/browse/FHIR-36847)) See Changes [Here](#.html)
5. **Triaged:** Add example FlowSheets for each Transaction ([FHIR-36854](https://jira.hl7.org/browse/FHIR-36854)) See Changes [Here](#.html)
6. **Triaged:** Support for Attachments ([FHIR-36882](https://jira.hl7.org/browse/FHIR-36882)) See Changes [Here](#.html)
7. **Applied:** correct typo ([FHIR-36917](https://jira.hl7.org/browse/FHIR-36917)) See Changes [Here](#.html)
8. **Pre-Applied** Update Figure ([FHIR-36918](https://jira.hl7.org/browse/FHIR-36918)) See Changes [Here](background.html#attachments-workflow)
9. **Pre-Applied** Clarify purpose for additional information ([FHIR-36919](https://jira.hl7.org/browse/FHIR-36919)) See Changes [Here](attachments.html)
10. **Triaged:** clarify the disposition of a new attachment ([FHIR-36920](https://jira.hl7.org/browse/FHIR-36920)) See Changes [Here](#.html)
11. **Applied:** typo correction ([FHIR-36921](https://jira.hl7.org/browse/FHIR-36921)) See Changes [Here](#.html)
12. **Applied:** Change the word is to in tho make the sentence flow. ([FHIR-36922](https://jira.hl7.org/browse/FHIR-36922)) See Changes [Here](#.html)
13. **Triaged:** no content to review on page (XML or JSON may have corrections- ([FHIR-36923](https://jira.hl7.org/browse/FHIR-36923)) See Changes [Here](#.html)
14. **Applied** Clarify Figure 4 and associated text in 2.6.2 ([FHIR-36985](https://jira.hl7.org/browse/FHIR-36985)) See Changes:
   - [Here](background.html#attachments-workflow)
   - [Here](solicited-unsolicited-attachments.html)
17. **Triaged:** Signature requirements clarification in 3.2.6 and 4 ([FHIR-36986](https://jira.hl7.org/browse/FHIR-36986)) See Changes [Here](#.html)
18. **Triaged:** Add non-document based attachment scenario ([FHIR-36995](https://jira.hl7.org/browse/FHIR-36995)) See Changes [Here](#.html)
19. **Pre-Applied:** Clarify association of data ([FHIR-36996](https://jira.hl7.org/browse/FHIR-36996)) See Changes [Here](attachments.html)
20. **Pre-Applied:** Document using CDex Attachments with DaVinci PAS ([FHIR-36997](https://jira.hl7.org/browse/FHIR-36997)) See Changes [Here](burden-reduction.html)
21. **Triaged:** Replace EHR with Source HIT ([FHIR-36999](https://jira.hl7.org/browse/FHIR-36999)) See Changes [Here](#.html)
22. **Triaged:** $submit-attachment should allow for more ""attachTo"" values in valueset ([FHIR-37000](https://jira.hl7.org/browse/FHIR-37000)) See Changes [Here](#.html)
23. **Pre-Applied:** Remove "preferred" approach from direct query ([FHIR-37166](https://jira.hl7.org/browse/FHIR-37166)) See Changes [Here](direct-query.html)
24. **Triaged:** Qualifying a direct query ([FHIR-37167](https://jira.hl7.org/browse/FHIR-37167)) See Changes [Here](#.html)
25. **Triaged:** Signature attesting true and accurate resources ([FHIR-37194](https://jira.hl7.org/browse/FHIR-37194)) See Changes [Here](#.html)
26. **Triaged:** Clarify H&P in diagram is object or behavior ([FHIR-37225](https://jira.hl7.org/browse/FHIR-37225)) See Changes [Here](#.html)
27. **Pre-Applied:** Clarify roles in attachments diagram([FHIR-37226](https://jira.hl7.org/browse/FHIR-37226)) See Changes [Here](background.html)
28. **Applied:** Typo correction for clarity ([FHIR-37227](https://jira.hl7.org/browse/FHIR-37227)) See Changes [Here](#.html)
29. **Triaged:** Provide clarity on why solicited workflow varies from existing guidance in financial module ([FHIR-37228](https://jira.hl7.org/browse/FHIR-37228)) See Changes [Here](#.html)
30. **Applied:** Typo correction ([FHIR-37229](https://jira.hl7.org/browse/FHIR-37229)) See Changes [Here](#.html)
31. **Triaged:** Describe reasoning for choosing Bundle.signature in attachment signatures or signatures page ([FHIR-37230](https://jira.hl7.org/browse/FHIR-37230)) See Changes [Here](#.html)
32. **Submitted:** Same comment as above ([FHIR-37231](https://jira.hl7.org/browse/FHIR-37231)) See Changes [Here](#.html)
33. **Applied:** minor text edits ([FHIR-37233](https://jira.hl7.org/browse/FHIR-37233)) See Changes [Here](#.html)
34. **Applied:** Clarify Figure 7 step 4 text to match the description ([FHIR-37234](https://jira.hl7.org/browse/FHIR-37234)) See Changes [Here](#.html)
35. **Applied:** operation name used in examples  ([FHIR-37235](https://jira.hl7.org/browse/FHIR-37235)) See Changes [Here](#.html)
36. **Pre-Applied:** Rewrite introduction to Signature ([FHIR-37243](https://jira.hl7.org/browse/FHIR-37243)) See Changes [Here](signatures.html)
37. **Triaged:** change SHOULD to SHALL ([FHIR-37244](https://jira.hl7.org/browse/FHIR-37244)) See Changes [Here](#.html)
38. **Triaged:** Signatures should not be required for more than one per Task ([FHIR-37246](https://jira.hl7.org/browse/FHIR-37246)) See Changes [Here](#.html)
39. **Triaged:** overly vague ([FHIR-37248](https://jira.hl7.org/browse/FHIR-37248)) See Changes [Here](#.html)
40. **Triaged:** data consumer?  ([FHIR-37250](https://jira.hl7.org/browse/FHIR-37250)) See Changes [Here](#.html)
41. **Triaged:** re write section  ([FHIR-37251](https://jira.hl7.org/browse/FHIR-37251)) See Changes [Here](#.html)
42. **Pre-Applied:** Rewrite introduction to Signature ([FHIR-37253](https://jira.hl7.org/browse/FHIR-37253)) See Changes [Here](signatures.html)
43. **Triaged:** overlap with DV Burden Reduction guides? ([FHIR-37257](https://jira.hl7.org/browse/FHIR-37257)) See Changes [Here](#.html)
44. **Pre-Applied:** Update Polling Guidance ([FHIR-37260](https://jira.hl7.org/browse/FHIR-37260)) See Changes [Here](task-based-approach.html#polling-vs-subscriptions)

##### Non-Ballot Issues and links to the updated content are below::

**Status: Summary (Jira Issue) Link to Change**

48. **Triaged:** Does the IG support ""Access"" without retrieval of data? - CDex #16 ([FHIR-23429](https://jira.hl7.org/browse/FHIR-23429)) See Changes [Here](#.html)
1. **Triaged:** This is a use case between two providers, primarily. - CDex #28 ([FHIR-23441](https://jira.hl7.org/browse/FHIR-23441)) See Changes [Here](#.html)
1. **Triaged:** AMA believes quality reporting should include the goal of increasing the transparency of health care data. - CDex #307 ([FHIR-23672](https://jira.hl7.org/browse/FHIR-23672)) See Changes [Here](#.html)
1. **Triaged:** This use case needs to be narrowed in order to prevent medical necessity determinations delaying or completely impeding access to appropriate care. - CDex #309 ([FHIR-23674](https://jira.hl7.org/browse/FHIR-23674)) See Changes [Here](#.html)
1. **Pre-Applied:** Recommendation for exchanging purpose of use. ([FHIR-30824](https://jira.hl7.org/browse/FHIR-30824)) See Changes:
  - [Here](task-based-approach.html)
  - [Here](task-based-approach.html#purpose-of-use)
  - [Here](security.html#general-considerations)
  - [Here](security.html#purpose-of-use)
2. **Triaged:** Messaging not reflected in data flow. ([FHIR-30837](https://jira.hl7.org/browse/FHIR-30837)) See Changes [Here](#.html)
3. **Triaged:** overflowing their workflow in-basket impacting patient care ([FHIR-31890](https://jira.hl7.org/browse/FHIR-31890)) See Changes [Here](#.html)
4. **Triaged:** add a profile on Parameters ([FHIR-34425](https://jira.hl7.org/browse/FHIR-34425)) See Changes [Here](#.html)
5. **Pre-Applied** Make Task.reasonReference.identifer 0…1 MS ([FHIR-35151](https://jira.hl7.org/browse/FHIR-35151)) See Changes:
  - [Here](StructureDefinition-cdex-task-data-request.html)
  - [Various examples such as Here](Task-cdex-task-example1.html)
  - [Various example scenarios such as Here](task-based-approach.html#step-1---post-task-to-provider-endpoint)
6. **Submitted:** move change log from version HX to changes page ([FHIR-36727](https://jira.hl7.org/browse/FHIR-36727)) See Changes [Here](#.html)
7. **Pre-Applied:** Change re-associate to associate ([FHIR-36733](https://jira.hl7.org/browse/FHIR-36733)) See Changes [Here](attachments.html)
8. **Submitted:** Submit attachment operation sentence modification ([FHIR-36735](https://jira.hl7.org/browse/FHIR-36735)) See Changes [Here](signed-searchset-bundle-example.html)
9.  **Applied:** Fix Typo([FHIR-36736](https://jira.hl7.org/browse/FHIR-36736)) See Changes [Here](signed-searchset-bundle-example.html)
10. **Submitted:** Explicitly call out that HRex and FHIR define the content that is exchanged, while CDex defines additional conditions for how it is exchanged ([FHIR-36741](https://jira.hl7.org/browse/FHIR-36741)) See Changes [Here](#.html)
11. **Submitted:** SubmitAttachment AttachTo text correction ([FHIR-36756](https://jira.hl7.org/browse/FHIR-36756)) See Changes [Here](#.html)
12. **Submitted:** Unclear why certain inputs are required ([FHIR-36757](https://jira.hl7.org/browse/FHIR-36757)) See Changes [Here](#.html)
13. **Submitted:** Clarify that signature.who should reference an Organization resource or Practitioner resource ([FHIR-36846](https://jira.hl7.org/browse/FHIR-36846)) See Changes [Here](#.html)
14. **Applied:** Fix grammar([FHIR-36848](https://jira.hl7.org/browse/FHIR-36848)) See Changes [Here](direct-query.html#signatures)
15. **Applied:** Fix formatting Error to separate several entries([FHIR-36853](https://jira.hl7.org/browse/FHIR-36853)) See Changes [Here](signatures.html#digital-signatures)
16. **Applied:** Fix capitalization([FHIR-36896](https://jira.hl7.org/browse/FHIR-36896)) See Changes [Here](attachments.html)
17. **Applied:** Adds links to operation consistently ([FHIR-36897](https://jira.hl7.org/browse/FHIR-36897)) See Changes [Here](attachments.html)
18. **Pre-Applied:** Rewrite digital signature functional requirements: ([FHIR-36905](https://jira.hl7.org/browse/FHIR-36905)) See Changes [Here](signatures.html#digital-signatures)
19. **Pre-Applied:** Add conformance Verbs to SubmitAttachment operation page ([FHIR-36906](https://jira.hl7.org/browse/FHIR-36906)) See Changes [Here](OperationDefinition-submit-attachment.html)
20. **Submitted:** Incomplete Narrative Content rendering of Submit Attachment Parameters Resource example ([FHIR-36907](https://jira.hl7.org/browse/FHIR-36907)) See Changes [Here](#.html)
21. **Submitted:** Missing examples  ([FHIR-37245](https://jira.hl7.org/browse/FHIR-37245)) See Changes [Here](#.html)
22. **Submitted:** We appreciate the robust P&S section ([FHIR-37247](https://jira.hl7.org/browse/FHIR-37247)) See Changes [Here](#.html)
23. **Pre-Applied:** Rewrite background on section on Payers([FHIR-37252](https://jira.hl7.org/browse/FHIR-37252)) See Changes [Here](background.html#what-do-payers-do-with-clinical-information)
24. **Pre-Applied:** Clarify support for XML with signatures ([FHIR-37264](https://jira.hl7.org/browse/FHIR-37264)) See Changes:
    -  [Here](signatures.html#digital-signature-rules-for-cdex-fhir-bundles)
    -  [Here](CapabilityStatement-data-consumer-client.html#behavior)
    -  [Here](CapabilityStatement-data-consumer-server.html#behavior)
    -  [Here](CapabilityStatement-data-source-client.html#behavior)
    -  [Here](CapabilityStatement-data-source-server.html#behavior)
25. **Triaged:** Add clarification on how to handle reads when signatures are needed ([FHIR-37265](https://jira.hl7.org/browse/FHIR-37265)) See Changes [Here](#.html)
26. **Pre-Applied:** Update $submit-attachments diagram to show 200 w/ OperationOutcome ([FHIR-37271](https://jira.hl7.org/browse/FHIR-37271)) See Changes:
    -  [Here](sending-attachments.html#technical-workflow)
    -  [Here]sending-attachments.html#scenario-1b-ccda-document-attachments-submitted-prior-to-claim)
    -  [Here](OperationDefinition-submit-attachment.html#submitattachment)
27. **Pre-Applied:** Add PayerId to $submit-attachments ([FHIR-37331](https://jira.hl7.org/browse/FHIR-37331)) See Changes [Here](OperationDefinition-submit-attachment.html)
28. **Applied:** Clarify that claim's attachment submitter is same as claim submitter ([FHIR-37332](https://jira.hl7.org/browse/FHIR-37332)) See Changes:
   - [Here](pagecontent/sending-attachments.html#data-elements-for-sending-attachments)
   - [Here](pagecontent/requesting-attachments.html#identifying-the-payer-provider-and-patient)
29. **Applied:** Add "Request Attachments" content as Draft ([FHIR-37563](https://jira.hl7.org/browse/FHIR-37563)) See Changes:
    -  [Here](background.html#attachments-workflow)
    -  [Here](solicited-unsolicited-attachments.html)
    -  [Here](sending-attachments.html)
    -  [Here](requesting-attachments.html)
    -  [Here](burden-reduction.html)
    -  [Here](ValueSet-cdex-claim-use.html)
    -  [Here](OperationDefinition-submit-attachment.html)
    -  [Here](StructureDefinition-cdex-patient-demographics.html)
    -  [Here](StructureDefinition-cdex-task-attachment-request.html)
    -  [Here](Task-cdex-task-example19.html)
    -  [Here](Task-cdex-task-example20.html)
30. **Applied:** Add CCDA example and Correct PDF example ([FHIR-37655](https://jira.hl7.org/browse/FHIR-37655)) See Changes [Here](task-based-approach.html#scenario-2)
31. **Applied:** Rewrite section on Discovery of FHIR IDs ([FHIR-37652] (https://jira.hl7.org/browse/FHIR-37652)) See Changes:  
    -  [Here](task-based-approach.html#discovery-of-providers-payer-and-patient-ids)
    -  [Here](direct-query.html#discovery-of-patient-fhir-ids) 
32. **Applied:** Document how implementers locate the proper identifier ([FHIR-37651](https://jira.hl7.org/browse/FHIR-37651)) See Changes [Here](OperationDefinition-submit-attachment.html#submitattachment)

---

### Version = 1.1.0-ballot
- Publication Date: 2022-03-25
- url: <http://hl7.org/fhir/us/davinci-cdex/2022May>
- Based on FHIR version : 4.0.1


#### Changes:
 Da Vinci CDEX 2022 May Ballot. This ballot is restricted to the *Draft content* in the STU 1.0 version of CDex.  The draft content includes handling of Attachments and Digital Signatures.

---

### Version = 1.0.0
- Publication Date: 2022-03-25
- url: <http://hl7.org/fhir/us/davinci-cdex/STU1>
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
- url: <http://hl7.org/fhir/us/davinci-cdex/2021Jan>
- Based on FHIR version : 4.0.1


#### Changes:
 Based on the 2019-06-20 ballot feedback, this IG has been completely re-written for this ballot. The refactoring has been sufficiently large that it is not practical/useful to enumerate a list of changes between this ballot version (0.2.0) and the 2019-06-20 ballot version (0.1.0).

---

### Version = 0.1.0
- Publication Date: 2019-06-18
- url: <http://hl7.org/fhir/us/davinci-cdex/2019Jun>
- Based on FHIR version : 4.0.0


#### Changes:
 June 2019 Ballot for Da Vinci CDex

---
