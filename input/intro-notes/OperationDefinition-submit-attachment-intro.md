<!-- OperationDefinition-submit-attachment-intro.md -->
  The input parameters are:
  1. One or more attachments as FHIR Resources
      - Optionally, one or more unique line item numbers associated with the attachment
      - Optionally, the attachment code used to request the information
  1. Data elements for the association to the claim/prior authorization
      - An tracking identifier referred to as the "re-association tracking control number" or "attachment control number (ACN)" that ties the attachment(s) back to the claim or prior authorization.
      - Optionally, a payer-assigned "administrative reference number" identifier.
      - What are the attachments for:
        - Claims
        - Prior Authorizations
      - Optionally, a unique payer identifier
      - A unique organization/location identifier (e.g., [Type 2 NPI](https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/downloads/NPI-What-You-Need-To-Know.pdf)) or unique provider identifier (e.g., [Type 1 NPI](https://www.cms.gov/Outreach-and-Education/Medicare-Learning-Network-MLN/MLNProducts/downloads/NPI-What-You-Need-To-Know.pdf))
      - A unique Patient member identifier
      - A Date of Service
      - A Flag indicating whether the operation is the last attachment submission for the claim or prior authorization.

  There are no output parameters.