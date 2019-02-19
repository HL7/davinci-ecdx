---
title: CDex Profiles and Extensions
layout: default
active: CDex Profiles and Extensions
---

## Profiles Used by Reference

* TODO: add C-CDA on FHIR Document Profiles

* 	US Core Patient Profile
* 	US Core Condition Profile
* 	US Core Medication Profile
* 	US Core MedicationStatement Profile
* 	US Core AllergyIntolerance Profile
* 	US Core Procedure Profile
* 	US Core Device Profile
* 	US Core Immunization Profile
* 	US Core DocumentReference Profile
* 	US Core ObservationResults Profile
* 	US Core Practitioner Profile
* 	US Core PractitionerRole Profile
* 	US Core Organization Profile
* 	US Core Location Profile
* 	US Core Encounter Profile
* 	US Core Provenance Profile
* 	Any additional US Core Profiles that are being developed

## Da Vinci CDex Profiles
* Da Vinci CDex Bundle Profile
* Da Vinci CDex Composition Profile
* This profile will support documents that correspond to the xDocs template
* 3.2.3	Da Vinci Communication Profile
* 3.2.4	Da Vinci CommunicationRequest Profile

## EXTENSIONS
The PDex IG uses extensions defined in the US Core IG:
- US Core Race Extension
- US Core Ethnicity Extension
- US Core Birth Sex Extension.
In cases where Health Plans do not have a record of Birth Sex the field will be assigned the UNK/Unknown  NullFlavor.

Also will need extensions on Communication and CommunicationRequest for LOINC codes for the request and the response.
