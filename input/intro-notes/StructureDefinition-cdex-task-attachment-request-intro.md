 <!-- StructureDefinition-cdex-task-attachment-request-intro.md -->
 
 It constrains the following elements to be *mandatory* (min=1):
  
  - A [contained](http://hl7.org/fhir/R4/references.html) Patient Resource defined by the [CDex Patient Demographics Profile](StructureDefinition-cdex-patient-demographics.html) and communicating additional patient demographic data elements.
  - A [contained](http://hl7.org/fhir/R4/references.html) PractitionerRole Resource defined by the [CDex PractitionerRole Profile](StructureDefinition-cdex-practitionerrole.html) to communicate the provider ID as either a unique organization/location identifier (e.g., Type 2 NPI) or unique provider identifier (e.g., Type 1 NPI) or both.
  - <span class="bg-success" markdown="1">A `Task.identifier` element representing the payer's tracking identifier, commonly referred to as the “re-association tracking control numbers” or "attachment control number (ACN)"</span><!-- new-content -->
  - A `Task.status` with a required binding to HRex [Task Status ValueSet](http://hl7.org/fhir/us/davinci-hrex/ValueSet-hrex-task-status.html) (this element is a mandatory Task element). For guidance when the provider cannot complete the Task, refer to the [When The Task Cannot Be Completed section](task-based-approach.html#when-the-task-cannot-be-completed).
  - A `Task.intent` element that is fixed to "order" (this element is a mandatory Task element)
  - A `Task.code` of either "attachment-request-code" or "attachment-request-questionnaire"  communicating that the Payer is requesting attachments for a claim or prior authorization using a code or data request questionnaire.
    - If the code is "attachment-request-code", the provider system returns attachment(s) identified by the attachment code(s) in the "AttachmentsNeeded" input parameter.
    - If the code is "attachment-request-questionnaire", the provider system uses [Documentation Templates and Rules (DTR)](https://hl7.org/fhir/us/davinci-dtr/index.html) to complete the Questionnaire(s) referenced in the "QuestionnaireContext" input parameter.
    - When either code is present, the provider system uses the $submit-attachment operation to return the information to the endpoint provided in the "PayerUrl" input parameter.    
  - A `Task.requester`.identifier element representing the Payer ID
  - A `Task.owner`.reference element that is fixed to "\#practionerrole" -  a reference to the contained PractitionerRole Resource that represents the Provider ID.
  - A `Task.for`.reference element that is fixed to "\#patient" - a reference to the contained Patient Resource that represents patient demographic data.
  - A `Task.reasonCode` to communicate whether the attachments are for a claim or prior authorization.
  - A `Task.reasonReference`.reference referencing the claim or prior authorization ID (business Identifier).
  - A "PayerUrl" `Task.input` element representing the Payer endpoint URL the provider uses when submitting attachments with the `[$submit-attachment`](OperationDefinition-submit-attachment.html) operation.
 
  It constrains the following elements to be [*must support*](attachments-conformance.html#cdex-must-support-definition) (min=0):
  - <span class="bg-success" markdown="1">For prior authorization, the Payer may assign an administrative reference number *in addition to* the tracking control number/ACN. By using a combination of identifiers, the Payer can guarantee global uniqueness for associating attachments to the claim or prior authorization.</span><!-- new-content -->
  - A `Task.Restriction.period` element representing the due date for submitting the attachments
  - A `Task.statusReason.text` to communicate the reason for the status (for example, if the Task is rejected or failed)
  - A "AttachmentsNeeded" `Task.input` element to communicate to the provider what attachments are needed using LOINC or X12 attachment codes.*
  - A "AttachmentsNeeded" or "QuestionnaireContext" `Task.input` element extension that communicates claim or prior authorization line item numbers associated with the attachment or questionnaire.
  - A "Signature" `Task.input` element. This is a flag to indicate whether the requested data requires a signature. For more information about requiring and requesting signatures, refer to the [Signatures section](sending-attachments.html#signatures).
  - A "ServiceDate" `Task.input` element representing the date of service or starting date of the service for the claim or prior authorization. It **SHALL** be present if the attachment is for a claim.

  It defines the following *optional* elements:

  - A "QuestionnaireContext" Task.input element to communicate to the provider a URL of a data request [FHIR Questionnaire](http://hl7.org/fhir/questionnaire.html) that conforms to the [DTR Standard Questionnaire Profile](http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-std-questionnaire) or the [DTR Questionnaire for Adaptive Form Profile](http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-questionnaire-adapt).*
    - A questionnaireDisplay extension to communicate the display name of the Questionnaire
  - A "POU" `Task.input` element that is used to indicate the purpose of use (POU) for the requested data using an extensible [CDex Purpose of Use Value Set](ValueSet-cdex-POU.html). Refer to the [Purpose of Use section](task-based-approach.html#purpose-of-use) For more information about sending purpose POU codes.
  - A "MultipleSubmits" `Task.input` element that is a flag to indicate whether the requested data can be sent in multiple submissions
  - A "AttachmentsNeeded" `Task.output` element that references the result(s) of the data request code.
  - A "QuestionnaireContext" `Task.output` element which references the [FHIR QuestionnaireResponse](http://hl7.org/fhir/questionnaireresponse.html) resulting from the data request Questionnaire. The QuestionnaireResponse conforms to the [CDex SDC QuestionnaireResponse Profile](StructureDefinition-cdex-sdc-questionnaireresponse.html) or the [SDC Adaptive Questionnaire Response Profile](http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaireresponse-adapt).

  \* Either a "AttachmentsNeeded" or a "QuestionnaireContext" `Task.input` element is required