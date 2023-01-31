The CDex Profile elements consist of Mandatory, Must Support, and Optional elements. Elements that are neither Mandatory or Must Support are Optional. Mandatory elements are elements with a minimum cardinality greater than 0. [Must Support] elements are marked with the *mustSupport* flag and **SHALL** be interpreted as follows:

Task Source
: Data Source server where the Task is stored and updated, or Data Consumer client that POST the Task to Data Source server.

Task Consumer
: Data Consumer client receiving a Task from the Data Source server due to a FHIR interaction.

- If the minimum cardinality of an element is greater than 0, the
  element is *required* and the Task Source **SHALL** populating the data element with value unless:
  - The profile references a dataAbsentReason (DAR) extension, then the Task
    Source **SHALL** use that extension to communicate the reason for missing data.
- If the minimum cardinality of an element is equal to 0, the Task Source **SHALL** be capable of populating the data element when sharing Task compliant with a CDex profile. Therefore, the system must demonstrate the population and sharing of the element. However, it is acceptable to omit the element if the system doesn't have values in a particular instance. A system that is incapable of ever sharing the
the element would be non-conformant.
- The Task Consumer **SHALL** be capable of processing Task instances
  containing the data elements without generating an error or causing
  the application to fail.

NOTE: *mustSupport* indicates what Da Vinci CDex conformant systems are expected to be able to handle. Systems are free to include additional
data - and receivers **SHOULD NOT** reject instances that contain unexpected data elements if those elements are not [modifier elements]. However, the Task Source should be aware that they can't count on the Task Consumer storing, processing, or doing anything other than ignoring data that is not marked as *mustSupport*.
