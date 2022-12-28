
<!-- NOT USED AND NOT CURRENT -->

### List of CDEX Scenarios


#### Direct Query Transaction Scenarios

- [Scenario 1](http://build.fhir.org/ig/HL7/davinci-ecdx/direct-query.html#scenario-1): Payer A Seeks Insured Person/Patient B’s Active Conditions from Provider C to support a claim submission.
- [Scenario 2](http://build.fhir.org/ig/HL7/davinci-ecdx/direct-query.html#scenario-2): Payer A Seeks Insured Person/Patient B’s glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.
- [Scenario 3](http://build.fhir.org/ig/HL7/davinci-ecdx/direct-query.html#scenario-3): Payer A Seeks Insured Person/Patient B’s latest history and physical exam notes from Provider C to support a claim submission.
- [Example of Signed Direct Query Response Including Provenance](http://build.fhir.org/ig/HL7/davinci-ecdx/direct-query.html#example-of-direct-query-response-including-provenance): This example is the same as Scenario 1 above except that it also includes the corresponding Provenance records.- [Example of Direct Query Response Including Provenance](http://build.fhir.org/ig/HL7/davinci-ecdx/direct-query.html#example-of-direct-query-response-including-provenance): This example is the same as Scenario 1 above except that it also includes the corresponding Provenance records.
- [Example of *Signed* Direct Query Response](http://build.fhir.org/ig/HL7/davinci-ecdx/direct-query.html#example-of-signed-direct-query-response): This example is the same as Scenario 1 above except that it also includes a digital signature. See the Signatures page for complete worked example on how the signature was created.

#### Task Based Approach Scenarios

- [Scenario 1](http://build.fhir.org/ig/HL7/davinci-ecdx/task-based-approach.html#scenario-1): Payer A Seeks Insured Person/Patient B’s Active Conditions from Provider C to support a claim submission.
- [Scenario 2](http://build.fhir.org/ig/HL7/davinci-ecdx/task-based-approach.html#scenario-2): Payer A Seeks Insured Person/Patient B’s latest history and physical exam notes from Provider C to improve care coordination.
- [Example Unsuccessful Task Based Transaction](http://build.fhir.org/ig/HL7/davinci-ecdx/task-based-approach.html#example-unsuccessful-task-based-transaction): In this scenario, Payer A Seeks Insured Person/Patient B’s glycated hemoglobin (HbA1c) test results after 2020-01-01 from Provider C for Quality reporting requirements and quality care scoring.
- [Example Task Based Transaction using Subscription](http://build.fhir.org/ig/HL7/davinci-ecdx/task-based-approach.html#example-task-based-transaction-with-a-formal-authorization): The following examples repeats Scenario 1 above using Subscription instead of Polling.
- [Example Task Based Transaction with a Formal Authorization
](http://build.fhir.org/ig/HL7/davinci-ecdx/task-based-approach.html#example-task-based-transaction-with-a-formal-authorization): In this scenario, a referred-to Provider Seeks Patient B’s Active Conditions from referring Provider to support performing the requested service.
- [Example Requests for Provenance using Task Based Transaction
](http://build.fhir.org/ig/HL7/davinci-ecdx/task-based-approach.html#example-requests-for-provenance-using-task-based-transaction): The following examples repeat the first two examples in Scenario 1 above but request Patient B’s active Conditions and associated Provenance.
- [Example of a Signed Task Based Transaction](http://build.fhir.org/ig/HL7/davinci-ecdx/task-based-approach.html#example-of-a-signed-task-based-transaction): The following example repeats Scenario 1 above, however a signature is required.

#### Attachments Scenarios

- [Scenario 1: CCDA Document Attachments](http://build.fhir.org/ig/HL7/davinci-ecdx/attachments.html#scenario-1-ccda-document-attachments): In the following example, a Provider creates a claim and sends supporting CCDA documents using the FHIR operation, $submit-attachment:
- [Example: Signed FHIR Resource Attachments](http://build.fhir.org/ig/HL7/davinci-ecdx/attachments.html#example-signed-fhir-resource-attachments): This example is the same as Scenario 1 above except that the attachment is a FHIR resource and a FHIR digital signature is required.
