- The Data Source follows the documentation on the [Signatures] page for producing signatures.
- When an electronic or digital signature is required, the Data Source returns either:
  1. document(s) that are already inherently signed
  2. FHIR resource(s) transformed into a *signed* FHIR Document.
  3. or for requests using Questionnaire, a *signed* FHIR QuestionnaireResponse. 
- If multiple documents need to be signed, systems should minimize the number of interactions required by the user
- As discussed in the [What is Signed] section, a signed FHIR document could have objects that are individually signed within it as well. Therefore, if the Consumer/Requester incorrectly assumed there would be a signature (wet, electronic, or digital) on an individual returned object (e.g., C-CDA, PDF, Image, CDA on FHIR, QuestionnaireResponse), they can *re-request* the data using a Task-based request and use the `Task.input` signature flag to indicate that the Data Source needs to sign it.