- The Data Source/Responder follows the documentation on the [Signatures] page for producing signatures.
- When an electronic or digital signature is required, the Data Source/Responder returns either:
  2. document(s) that are already inherently signed
  3. FHIR resource(s) transformed into a *signed* FHIR Document.
  4. <span class="bg-success" markdown="1">or for requests using Questionnaire, a *signed* FHIR QuestionnaireResponse.</span><!-- new-content -->
- if multiple documents need to be signed, systems should minimize the number of interactions required by the user
- As discussed in the [What is Signed] section, a signed FHIR document could have objects that are individually signed within it as well. If the Consumer/Requester assumed there would be a signature (wet, electronic, or digital) on an individual returned object (e.g CCDA, PDF, Image, CDA on FHIR, QuestionnaireResponse ) and it is not present, they can *re-request* the data using a Task-based request to indicate it needs to be signed with the `Task.input` signature flag.