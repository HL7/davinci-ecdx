---
title: About Payload Types
layout: default
active: About Payload Types
---

This implementation guide addresses the possibility of exchanging information as documents using standard document types defined in the HL7 C-CDA and C-CDA on FHIR implementation guides. It also supports the possibility of exchanging collections of data elements or specific data elements retrieved most likely as resources through the use of a restful query.

The expected content payload types include: C-CDA, FHIR document or collection bundles, pdfs, or individual resources when using REST API interactions.

The HRex implementation guides has a chapter on LOINC codes and how to specify the type of document or collection being requested or communicated. 

The LOINC Document Ontology is a special set of LOINC codes that are built on a framework for naming and classifying the key attributes of clinical documents. They provide consistent semantics for documents exchanged between systems for many uses. See the <a href="https://loinc.org/document-ontology/">LOINC Document Ontology website</a> for for more information.


The HRex implementation guide also explains the MIME types that can be used to encode the attachments. MIME stands for Multipurpose Internet Mail Extensions. MIME is a standard for formatting files of different types, such as text, graphics, or audio, so they can be sent over the Internet and seen or played by a web browser or email application.

