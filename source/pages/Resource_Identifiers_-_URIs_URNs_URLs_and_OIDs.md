---
title: Resource Identifiers - URIs URNs URLs and OIDs
layout: default
active: Resource Identifiers - URIs URNs URLs and OIDs
---

[Previous Page](Understanding_C-CDA_and_C-CDA_on_FHIR.html)

## Resource Identification in FHIR
The FHIR standard uses Uniform Resource Identifiers (URIs), Uniform Resource Names (URNs), and Uniform Resource Locators (URLs). Usage for URIs, URNs, and URLs is covered in the FHIR data types chapter. See <a href="http://hl7.org/FHIR/datatypes.html">documentation on FHIR datatypes</a> for more information.

A <a href="https://en.wikipedia.org/wiki/Uniform_Resource_Identifier">Uniform Resource Identifier (URI)</a> is a string of characters that unambiguously identifies a particular resource. A <a> href="https://en.wikipedia.org/wiki/Uniform_Resource_Name">Uniform Resource Name (URN)</a> is a Uniform Resource Identifier (URI) that uses the urn scheme. A <a href="https://en.wikipedia.org/wiki/URL">Uniform Resource Locator (URL)</a>, colloquially termed a web address,[1] is a reference to a web resource that specifies its location on a computer network and a mechanism for retrieving it. A URL is a specific type of Uniform Resource Identifier (URI),[2][3] although many people use the two terms interchangeably.[4][a] URLs occur most commonly to reference web pages (http), but are also used for file transfer (ftp), email (mailto), database access (JDBC), and many other applications.

## ISO Object Identifiers (OIDs) in CDA
In CDA, resources are identified using Object Identifiers (OIDs). <a href="https://en.wikipedia.org/wiki/Object_identifier">OIDs</a> are an identifier mechanism standardized by the International Telecommunications Union (ITU) and ISO/IEC for naming any object, concept, or "thing" with a globally unambiguous persistent name.

In FHIR, an OID is represented using a URN, e.g urn:oid:1.2.3.4.5. If converting from CDA to FHIR, implementers will need to prepend "urn:oid:" to the front of the OID. 

The HL7 OID registry, mentioned below, can be used to find or create OIDs. 

OIDs are used in CDA to identify the coding systems and identifier name spaces and in the C-CDA
Templates to identify value sets. An OID is a globally unique string consisting of numbers and dots (e.g.,
2.16.840.1.113883.6.90). This string expresses a tree data structure, with the left-most number representing the root and the right-most number representing a leaf.
Each branch under the root corresponds to an assigning authority. Each of these assigning authorities may, in turn, designate its own set of assigning authorities that work under its auspices, and so on down the line. Eventually, one of these authorities assigns a unique (to it as an assigning authority) number that corresponds to a leaf node on the tree.

OIDs present a systematic way to identify the organization responsible for issuing a code or entity identifier (scope). HL7 is an assigning authority, and has the OID prefix "2.16.840.1.113883." broken down as follows:
(2) represents that the OID was assigned by a joint ISO-ITU
(16) represents assigning authority which is specific to the country
(840) reflects the USA
(1) is specific to the organization
(113883) represents Health Level Seven (as the assigning authority).

Any OID that begins with this is further described by a registry maintained by the HL7 organization. For
example, the OID 2.16.840.1.113883.6.90 (above) was established by HL7 as a globally unique identifier for the ICD-10-CM code set for diagnoses.

Beyond that, the HL7 organization assigns any numbers - and these are maintained in a registry available on the HL7 Website. HL7 uses its registry to assign OIDs within its branch for HL7 users and vendors upon their request. HL7 also assigns OIDs to public identifier-assigning authorities both U.S. nationally (e.g., the U.S. State driver license bureaus, U.S. Social Security Administration, US National Provider Identifier (NPI) registry) and internationally (e.g., other countries' social security administrations, citizen ID registries)

Additional reference information about OIDs, including the current directory of OIDs assigned by HL7, is
available at http://www.hl7.org/oid/index.cfm. Organizations that wish to request an OID for their own use (e.g., to be able to create identifiers within a CDA document) may also obtain one from HL7 at this site.

## The Use of OIDs in C-CDA Documents
OIDs are used throughout the C-CDA used in Attachments. However, there are times in which an OID may not have been assigned to the information being exchanged. In this situation it is permissable to use UNK as the OID. For example, Patient ID is required in C-CDA header but Patient ID is not defined nor does it state whether it is Patient ID identified by provider or the payer.

When exchanging information using C-CDA documents, each provider or payer should obtain an OID for their organization to establish the scope for a Patient ID.

If a provider or payer does not have an OID for their organization to establish the scope for a Patient ID, the following is a valid way to represent a Patient or Member Id:
&</&id NullFlavor=UNKextension=MemberID&>/&
	

	

[Next Page](Structured_and_Unstructured_Documents.html)