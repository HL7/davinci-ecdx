| Data Element                             | CDex #submit-attachment Parameter   | CDex Request Attachment Task Profile Element   |
|------------------------------------------|-------------------------------------|------------------------------------------------|
| Tracking ID (Provider or Payer Assigned) | TrackingId                          | Task.identifier                                |
| Use                                      | AttachTo                            | Task.reasonCode                                |
| Payer URL                                | (operation endpoint)                | "payer-url" Task.input                         |
| Organiztion ID                           | OrganizationId                      | -                                              |
| Provider ID                              | ProviderId                          | Task.owner.identifier                          |
| line item(s)                             | Attachment.LineItem                 | “code” Task.input.extension                    |
| LOINC Attachment code                    | Attachment.Code                     | “code” Task.input                              |
| Date of Service                          | ServiceDate                         | “service-date” Task.input                      |
| Member ID                                | MemberId                            | Patient.identifier                             |
{:.grid}