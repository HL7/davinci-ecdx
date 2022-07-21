| Data Element | CDex Request Attachment Task Profile Element | X12n 277 | X12n 278 Response | Comments |
|-----|-----|---|---|-------|
| Tracking ID (Provider or Payer Assigned) | Task.identifier | REF02 | - | Provider or Payer assigned tracking control number |
| Use | Task.reasonCode | - | - | Choice of "claim" or "preauthorization" |
| Payer ID | Task.reasonReference.identifier | NM108 | - | Payer ID |
| Payer URL | "payer-url" Task.input | - | - | Payer endpoint where the attachments are submitted using the $submit-operation |
| Organization ID | - | - | - | Organization of Provider who submitted claim/prior authorization |
| Provider ID | Task.owner.identifier | - | - | Provider who submitted claim/prior authorization |
| Claim/PreAuth ID | Task.reasonReference.identifier | - | - | claim/prior authorization ID (Provider or Payer Assigned) |
| Line Item(s) | “code” Task.input.extension | - | - | claim/prior authorization line item numbers |
| LOINC Attachment Code | “code” Task.input | STC01-02 | - | LOINC attachment codes |
| Due Date | Task.restriction.period | DPT02 | - | Deadline form submitting attachments to Payer |
| Date of Service | “service-date” Task.input | DTP03 | - | Date of Service for claim/prior authorization |
| Member ID | Patient.identifier | X2100D NM | - | Payer assigned patient identifier |
| Patient Name | Patient.name | X2100D NM103-7 | - | Patient Demographic information for patient matching |
| Patient Account No. | Patient.identifier | CLM01(837) | - | Provider assigned patient identifer only for prior authorizatons |
| Date of Birth | Patient.birthDate | X12 | - | Patient Demographic information for patient matching |
{:.grid}