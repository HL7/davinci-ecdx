<!-- StructureDefinition-cdex-task-data-request-intro.md -->

Although the CDex Task Data Request Profile is based upon the [Da Vinci HRex Task Data Request](http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-task-data-request), this profile is technically non-conformant with it because of the questionnaire input parameter. The CDex editors made a change request [FHIR-39686](https://jira.hl7.org/browse/FHIR-39686) to update the HRex Profile. If the change request is approved and applied, a future version of CDex will be derived from HRex.
{:.stu-note}

*The `Task.reasonReference` `DocumentReference.author` is a *Must Support* element with four target profile and three Coverage profiles. Servers **SHALL** support at least one of them, and when supporting a Coverage profile, **SHALL** support the Coverage Profile based on the US Core version as follows:

|US Core Version|Coverage Profile (version)|
|---|---|
|3.1.1|[Coverage]|
|6.1.0|[US Core Coverage Profile (6.1.0)](https://hl7.org/fhir/us/core/STU6.1/StructureDefinition-us-core-coverage.html)
|7.0.0|[US Core Coverage Profile (7.0.0)](https://hl7.org/fhir/us/core/STU7/StructureDefinition-us-core-coverage.html)
{:.grid}

Clients **SHALL** support all four profiles.


{% include link-list.md %}