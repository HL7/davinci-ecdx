### Package File

The following package file includes an NPM package file used by many of the FHIR tools. It contains all the value sets, profiles, extensions, list of pages and URLs in the IG, etc., defined as part of this version of the Implementation Guides. This file should be the first choice whenever generating any implementation artifacts since it contains all the rules for validating the profiles. Implementers will still need to be familiar with the specification content and profiles that apply to make a conformant implementation. See the [validating profiles and resources] documentation in FHIR for more information.

- [Package(compressed folder)](package.tgz){::download="true"}

### Downloadable Copy of Specification

A downloadable version of this IG for local hosting is available:

- [Downloadable Copy(compressed folder)](full-ig.zip)

### Examples

All the examples in this Implementation Guide are available for download:

- [XML(compressed folder)](examples.xml.zip)
- [JSON(compressed folder)](examples.json.zip)

### Consolidated CSV and Excel File Representations of Profiles

All the profile information for the {{site.data.fhir.ig.title}} in a single CSV or Excel file, which may be helpful to testers and analysts to review element properties across profiles in a single table:

- [CSV(compressed folder)](csvs.zip)
- [Excel(compressed folder)](excels.zip)

### Schematrons

Schematrons are also available for download:

- [Schematrons(compressed folder)](schematrons.zip)

### Example Flow Chart Diagrams:

These example flow chart diagrams were created to assist the TestScript and Reference Implementation development team and are provided here to assist developers in implementing CDEX transactions. They are examples only, and actual workflows may differ from them. 


 - [Example Flow Chart Diagrams (compressed folder)](flowcharts.zip)
 - [Text based source](techflow_examples.md){:.download="true"}: These textual representations of the diagrams  ( the text between the \'\'\') can be viewed and edited  using *flowchart.js*. flowchart.js is a flowchart DSL and SVG renderer that runs in the browser and terminal. For more information, see <https://flowchart.js.org/>. Alternatively, this text can be viewed directly at <https://hackmd.io/>.


### Implementation Guide Details

The following link to the [ImplementationGuide] resource defines the technical details of this publication, including dependencies and  publishing parameters:

- [CDex ImplementationGuide Resource]

### Other Downloads

The following links allow you to download various parts of other referenced implementation guides for local use:

- The full [FHIR R4 core] specifications and other [FHIR core downloads]
- A [validator] that can be used to check FHIR resource instance validity and [instructions on how to use it]

{% include link-list.md %}