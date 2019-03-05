---
title: Understanding C-CDA and C-CDA on FHIR
layout: default
active: Understanding C-CDA and C-CDA on FHIR
---

## Clinical Document Architecture (CDA)
The HL7 Version 3 Clinical Document Architecture (CDA) is a document markup standard that specifies the structure and semantics of "clinical documents" for the purpose of exchange between healthcare entities. It defines a clinical document as having the following six characteristics:
1. Persistence
2. Stewardship
3. Potential for authentication
4. Context
5. Wholeness
6. Human readability

A CDA document can contain any type of clinical content. The standard is considered a "base standard" becuase this HL7 standard is very broad to enable it to support a wide range of use cases.

## Consolidated CDA (C-CDA)
The HL7 Consolidated CDA (C-CDA)implementation guide is a CDA implementation guide that defines 12 document templates for exchanging the information from a variety of clinical note types -- typical CDA encounter summary documents include: Discharge Summary, Imaging Report, History & Physical, Progress Note and others. A CDA patient summary document called a Continutiy of Care Document (CCD) provides a summarized longitudinal medical history over a defined span of time. The implementation guide was named "Consolidated CDA" because it resulted from a large-scale harmonization of CDA templates that had been developed by IHE, HITSP, and HL7. 

These CDA document "information structures" are used to transfer information within a message and can exist independently, outside the transferring message. The document header contains information that supplies the context for the information although additional provenance information may be carried with the data in the body of the document.

Information about the components for CDA is being presented at a high level and is intended to convey only what is necessary for the implementer to understand the application with respect to Attachments. Refer to the CDA Implementation Guides for Attachments for technical guidance on implementation of CDA for Attachments.

A CDA document has two primary groupings of information, a header and a body.

### The Document Header 
o Identifies and classifies the document
o Provides information on authentication, the encounter, the patient, and the
involved providers.
### The Document Body
o Contains the clinical report, organized into sections whose narrative content can
be encoded using standard vocabularies.
o Can be represented using a nonXMLBody or a structuredBody element.
 nonXMLBody is used when the content is an external file such as a
TIFF image, MS RTF document, PDF, etc. (Refer to Table 1 for the
complete list).The NonXMLBody class is provided for those applications
that can do no more than simply wrap an existing non-XML document
with the CDA Header.
 structuredBody is used when the body will be XML structured content.
XML structured content is always inserted into the structuredBody
element, never as an external file. The StructuredBody contains one or
more Section components.

For the purposes of this guide:
 A header paired with a structuredBody element will be referred to as a CDA Structured
Document. A header paired with a nonXMLBody element will be referred to as an CDA Unstructured
Document2.

See <a href="Structured_and_Unstructured_Documents.html">Structured and Unstructured Documents</a> for more information.

## C-CDA on FHIR
C-CDA on FHIR is a FHIR implementation guide that explains how to create FHIR Documents with the same informational content as specified for the types of documents defined in the C-CDA CDA implementation guide.  It includes profiles on the FHIR Composition resource for encounter summary documents such as: Discharge Summary, Imaging Report, History & Physical, Progress Note and others. A patient summary document called a Continutiy of Care Document (CCD) provides a summarized longitudinal medical history over a defined span of time. The implementation guide was named "C-CDA on FHIR" because the document specification resulted from the prior work done in the HL7 C-CDA specification to define information exchange structures for these standard document types.

The C-CDA on FHIR implementation guide show how to use all the same concepts from the LOINC document ontology to specify the standard document types with their expected and recommended standard sections.  FHIR profiles from the US Core implementation guide are used to specify the machine processable data to accompany the human readable text in each section.