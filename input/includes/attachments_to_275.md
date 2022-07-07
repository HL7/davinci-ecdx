| Data Element                             | CDex #submit-attachment Parameter   | X12n 275   | Comments                                                |
|------------------------------------------|-------------------------------------|------------|---------------------------------------------------------|
| Tracking ID (Provider or Payer Assigned) | TrackingId                          | -          | Tracking ID (Provider or Payer Assigned)                |
| Use                                      | AttachTo                            | -          | Claim or Prior Authorization.                           |
| Payer URL                                | (operation endpoint)                | -          | Payer URL                                               |
| Organiztion ID                           | OrganizationId                      | -          | Organization of Provider who submitted Claim/Prior-Auth |
| Provider ID                              | ProviderId                          | -          | Provider who submitted Claim/Prior-Auth                 |
| line item(s)                             | Attachment.LineItem                 | -          | Claim/Prior-Auth line item # nos                        |
| LOINC Attachment code                    | Attachment.Code                     | -          | LOINCs                                                  |
| Date of Service                          | ServiceDate                         | -          | Claim/Prior-Auth Date of Service (encounter info)       |
| Member ID                                | MemberId                            | -          | Member ID (patient info)                                |
{:.grid}