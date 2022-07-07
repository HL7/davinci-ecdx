| Data Element                             | CDex Request Attachment Task Profile Element   |
|------------------------------------------|------------------------------------------------|
| Tracking ID (Provider or Payer Assigned) | Task.identifier                                |
| Use                                      | Task.reasonCode                                |
| Payer ID                                 | Task.reasonReference.identifier                |
| Payer URL                                | "payer-url" Task.input                         |
| Organiztion ID                           | -                                              |
| Provider ID                              | Task.owner.identifier                          |
| Claim/PreAuth ID                         | Task.reasonReference.identifier                |
| line item(s)                             | “code” Task.input.extension                    |
| LOINC Attachment code                    | “code” Task.input                              |
| Due Date                                 | Task.restriction.period                        |
| Date of Service                          | “service-date” Task.input                      |
| Member ID                                | Patient.identifier                             |
| Patient Name                             | Patient.name                                   |
| Patient Account No.                      | Patient.identifier                             |
| Date of Birth                            | Patient.birthDate                              |
{:.grid}