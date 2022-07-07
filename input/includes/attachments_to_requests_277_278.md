| CDex #submit-attachment Parameter   | CDex Request Attachment Task Profile Element   | X12n 277   | X12n 278 Response   |
|-------------------------------------|------------------------------------------------|------------|---------------------|
| TrackingId                          | Task.identifier                                | REF02      | -                   |
| AttachTo                            | Task.reasonCode                                | -          | -                   |
| (operation endpoint)                | "payer-url" Task.input                         | -          | -                   |
| OrganizationId                      | -                                              | -          | -                   |
| ProviderId                          | Task.owner.identifier                          | -          | -                   |
| Attachment.LineItem                 | “code” Task.input.extension                    | -          | -                   |
| Attachment.Code                     | “code” Task.input                              | STC01-02   | -                   |
| ServiceDate                         | “service-date” Task.input                      | DTP03      | -                   |
| MemberId                            | Patient.identifier                             | X2100D NM  | -                   |
{:.grid}