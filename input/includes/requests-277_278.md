| Data Element                             | CDex Request Attachment Task Profile Element   | X12n 277       | X12n 278 Response   | Comments                                                |
|------------------------------------------|------------------------------------------------|----------------|---------------------|---------------------------------------------------------|
| Tracking ID (Provider or Payer Assigned) | Task.identifier                                | REF02          | -                   | Tracking ID (Provider or Payer Assigned)                |
| Use                                      | Task.reasonCode                                | -              | -                   | Claim or Prior Authorization.                           |
| Payer ID                                 | Task.reasonReference.identifier                | NM108          | -                   | Payer ID - should be a business ID -requester.reference |
| Payer URL                                | "payer-url" Task.input                         | -              | -                   | Payer URL                                               |
| Organiztion ID                           | -                                              | -              | -                   | Organization of Provider who submitted Claim/Prior-Auth |
| Provider ID                              | Task.owner.identifier                          | -              | -                   | Provider who submitted Claim/Prior-Auth                 |
| Claim/PreAuth ID                         | Task.reasonReference.identifier                | -              | -                   | Claim/Prior-Auth ID (Provider or Payer Assigned)        |
| line item(s)                             | “code” Task.input.extension                    | -              | -                   | Claim/Prior-Auth line item # nos                        |
| LOINC Attachment code                    | “code” Task.input                              | STC01-02       | -                   | LOINCs                                                  |
| Due Date                                 | Task.restriction.period                        | DPT02          | -                   | When attachments are Due                                |
| Date of Service                          | “service-date” Task.input                      | DTP03          | -                   | Claim/Prior-Auth Date of Service (encounter info)       |
| Member ID                                | Patient.identifier                             | X2100D NM      | -                   | Member ID (patient info)                                |
| Patient Name                             | Patient.name                                   | X2100D NM103-7 | -                   | Patient Name (patient info)                             |
| Patient Account No.                      | Patient.identifier                             | CLM01(837)     | -                   | Patient Account No. PreAuth Only (patient info)         |
| Date of Birth                            | Patient.birthDate                              | X12            | -                   | Date of Birth (patient info)                            |
{:.grid}