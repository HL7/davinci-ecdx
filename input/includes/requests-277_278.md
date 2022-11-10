| Data Element | CDex Request Attachment Task Profile Element | X12n 277 | X12n 278 Response | Request Attachments Comments |
|-----|-----|---|---|-----------|
| Tracking ID (Provider or Payer Assigned) | Task.identifier | REF02 | - | <span class="bg-success" markdown="1">Payer-assigned tracking/control number</span><!-- new-content --> |
| Use | Task.reasonCode | - | - | Choice of "claim" or "preauthorization" |
| Payer ID | Task.requester.identifier | NM108 | - | Payer ID |
| Payer URL | "payer-url" Task.input | - | - | Payer endpoint where the attachments are submitted using the $submit-operation |
| Organization ID | Task.owner.identifier | - | - | Organization of provider who submitted claim/prior authorization |
| Provider ID | Task.owner.identifier | - | - | Provider who submitted claim/prior authorization |
| Claim/PreAuth ID | Task.reasonReference.identifier | - | - | <span class="bg-success" markdown="1">Provider-assigned claim/prior authorization ID</span><!-- new-content --> |
| Line Item(s) | “code” Task.input.extension | - | - | Claim/prior-authorization line item numbers |
| LOINC Attachment Code | “code” Task.input | STC01-02 | - | LOINC attachment codes |
| Due Date | Task.restriction.period | DPT02 | - | Deadline for submitting attachments to Payer |
| Date of Service | “service-date” Task.input | DTP03 | - | Date of service for claim/prior authorization |
| Member ID | Patient.identifier | X2100D NM | - | Payer assigned patient identifier |
| Patient Name | Patient.name | X2100D NM103-7 | - | Patient demographic information for patient matching |
| Patient Account No. | Patient.identifier | CLM01(837) | - | <span class="bg-success" markdown="1">Patient Account Number is a provider-assigned identifier</span><!-- new-content --> |
| Date of Birth | Patient.birthDate | X12 | - | Patient demographic information for patient matching |
{:.grid}