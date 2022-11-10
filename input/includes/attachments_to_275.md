| Data Element | CDex $submit-attachment Parameter | X12n 275 | Submit Attachments Comments |
|-----|----|---|-------------------|
| Tracking ID (Provider or Payer Assigned) | TrackingId | - | <span class="bg-success" markdown="1">For *unsolicited* attachments, this is the provider-assigned tracking/control number. For *solicited* attachments, this is the payer-assigned tracking/control number.</span><!-- new-content --> |
| Use | AttachTo | - | Choice of "claim" or "preauthorization" |
| Payer URL | (operation endpoint) | - | Payer endpoint where the attachments are submitted using the $submit-operation |
| Organization ID | OrganizationId | - | Organization of provider who submitted claim/prior authorization |
| Provider ID | ProviderId | - | Provider who submitted claim/prior authorization |
| Line Item(s) | Attachment.LineItem | - | Claim/prior-authorization line item numbers |
| LOINC Attachment Code | Attachment.Code | - | LOINC attachment codes |
| Date of Service | ServiceDate | - | Date of service for claim/prior authorization |
| Member ID | MemberId | - | Payer assigned patient identifier |
{:.grid}