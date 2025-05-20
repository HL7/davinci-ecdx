<!-- StructureDefinition-cdex-task-data-request-intro.md -->

  It constrains the following elements to be *mandatory* (min=1):

  - A `Task.status` with a required binding to HRex [Task Status ValueSet](http://hl7.org/fhir/us/davinci-hrex/STU1.1/ValueSet-hrex-task-status.html) (this element is a mandatory Task element). For guidance when the provider is not able to complete the Task, refer to the [When The Task Cannot Be Completed section](task-based-approach.html#when-the-task-cannot-be-completed).
  - A `Task.intent` fixed to "order" (this element is a mandatory Task element)
  - A `Task.code` of "data-request-query", "data-request-code", or "data-request-questionnaire" communicating that the Data Consumer is requesting data using a FHIR RESTful query, a code (or free text), or a data request questionnaire.
    - If the code is "data-request-query", the provider system returns data(s) identified by the FHIR RESTful query in the "query" input parameter.
    - If the code is "data-request-code", the provider system returns data(s) identified by the LOINC code in the "code" input parameter.
    - If the code is "data-request-questionnaire", the provider system uses [Documentation Templates and Rules (DTR)](https://hl7.org/fhir/us/davinci-dtr/STU2.1/index.html) to complete the Questionnaire referenced in the "questionnaire" input parameter.
  - A `Task.for` element representing the member (i.e.,patient) for whom the data is being requested
  - A `Task.authoredOn` to communicate the date and time this task was created
  - A `Task.requester` element communicating who is requesting the data
  - A `Task.owner` element representing the Provider who is being asked to provide the data

  It constrains following elements to be [*must support*](task-based-conformance.html#cdex-must-support-definition) (min=0):

  - A `Task.identifier` element representing the unique data request identifier
  - A `Task.basedOn` element to communicate the order (ServiceRequest, CommunicationRequest, etc.) that authorizes the data request
  - A `Task.statusReason.text` to communicate the reason for the status (for example, if the Task is rejected or failed)
  - A `Task.businessStatus.text` element representing the progress in retrieving the data (for example, "waiting on internal review").
  - A `Task.for.reference.identifier` element representing a patient business identifier like a Member ID
  - A `Task.requester.reference.identifier` element representing the Data Consumer business identifier
  - A `Task.owner.reference.identifier` element representing the Provider business identifier
  - A `Task.reasonCode.text` to communicate why the data is being requested
  - A `Task.reasonReference.reference.identifier` for the claim, pre-auth or coverage business identifier*
  - A "query" `Task.input` element to communicate to the provider what information is needed using a FHIR RESTful query.*
  - A "code" `Task.input` element to communicate to the provider what information is needed using a LOINC code.*
    - For the "code" `Task.input` element, an extensible LOINC® Document types value set to communicate the specific information being requested
  - A `Task.input` element representing a flag to indicate whether the requested data requires a signature
  - A "data" `Task.output` element referring to FHIR resource(s) representing the result(s) of the data request.

  It defines the following elements to be *optional*:
  - A `meta.tag` element representing work-queue hints. Refer to the [Work Queues](task-based-approach.html#work-queues) section For more information about work-queue hint codes.
  - A "questionnaire" `Task.input` element to communicate to the provider a URL of a data request [FHIR Questionnaire](http://hl7.org/fhir/questionnaire.html) that conforms to the [DTR Standard Questionnaire Profile](http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-std-questionnaire) or the [DTR Questionnaire for Adaptive Form Profile](http://hl7.org/fhir/us/davinci-dtr/StructureDefinition/dtr-questionnaire-adapt).*
    - A questionnaireDisplay extension to communicate the display name of the Questionnaire
  - A `Task.input` element representing the purpose of use for the requested data using an extensible [CDex Purpose of Use Value Set](ValueSet-cdex-POU.html)
  - A "response" `Task.output` element which is a local reference to the [FHIR QuestionnaireResponse](http://hl7.org/fhir/questionnaireresponse.html) resulting from the data request Questionnaire. The QuestionnaireResponse conforms to the [CDex SDC QuestionnaireResponse Profile](StructureDefinition-cdex-sdc-questionnaireresponse.html) or the [SDC Adaptive Questionnaire Response Profile](http://hl7.org/fhir/uv/sdc/StructureDefinition/sdc-questionnaireresponse-adapt).

  It prohibits the following elements (max=0):
  - `Task.focus`

  \* Either a "query", "code", or "questionnaire" `Task.input` element is required


Although the CDex Task Data Request Profile is based upon the [Da Vinci HRex Task Data Request](http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-task-data-request), this profile is technically non-conformant with it because of the questionnaire input parameter. The CDex editors made a change request [FHIR-39686](https://jira.hl7.org/browse/FHIR-39686) to update the HRex Profile. If the change request is approved and applied, a future version of CDex will be derived from HRex.
{:.stu-note}

*The `Task.reasonReference` `DocumentReference.author` is a *Must Support* element with four target profile and three Coverage profiles. Servers **SHALL** support at least one of them, and when supporting a Coverage profile, **SHALL** support the Coverage Profile based on the US Core version as follows:

|US Core Version|Coverage Profile (version)|
|---|---|
|3.1.1|[Coverage]|
|6.1.0|[US Core Coverage Profile (6.1.0)](https://hl7.org/fhir/us/core/STU6.1/StructureDefinition-us-core-coverage.html)
|7.0.0|[US Core Coverage Profile (7.0.0)](https://hl7.org/fhir/us/core/STU7/StructureDefinition-us-core-coverage.html)
{:.grid}

Clients **SHALL** support all four profiles.


{% include link-list.md %}