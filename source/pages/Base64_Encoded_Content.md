---
title: Base64 Encoded Content
layout: default
active: Base64 Encoded Content
---

[Previous Page](Structured_and_Unstructured_Documents.html)

## Base64 Encoding Content
This Guide requires the use of Base64 encoding for embedding non XML documents and graphics. Also the authors acknowledge that Base64 encoding may present rendering challenges in some browsers.
### Purpose of Base64 Encoding
The purpose of Base64 Encoding is to eliminate characters and binary representation that may interfere with the messaging standards used to exchange a specific payload (in the case of this Guide, the C-CDA). Base64 Encoding uses an algorithm that transforms the payload into a specific set of 64 characters that are both members of a subset common to most encodings, and also printable. For example, MIME's Base64 implementation uses A-Z, a-z, and 0-9 for the first 62 values. Other variations share this property but differ in the symbols chosen for the last two values.
### Standards for Base64 Encoding
In both CDA and FHIR, the body of an unstructured CDA must be Base64 encoded and decoded as defined in RFC 4648.

[Next Page](Versioning_Mechanisms.html)