| Data Element | CDex #submit-attachment Parameter | X12n 275 | Comments |
|-----|----|---|-------|
| Tracking ID (Provider or Payer Assigned) | TrackingId | - | Provider or Payer assigned tracking control number |
| Use | AttachTo | - | Choice of "claim" or "preauthorization" |
| Payer URL | (operation endpoint) | - | Payer endpoint where the attachments are submitted using the $submit-operation |
| Organization ID | OrganizationId | - | Organization of Provider who submitted claim/prior authorization |
| Provider ID | ProviderId | - | Provider who submitted claim/prior authorization |
| Line Item(s) | Attachment.LineItem | - | claim/prior authorization line item numbers |
| LOINC Attachment Code | Attachment.Code | - | LOINC attachment codes |
| Date of Service | ServiceDate | - | Date of Service for claim/prior authorization |
| Member ID | MemberId | - | Payer assigned patient identifier |
{:.grid}