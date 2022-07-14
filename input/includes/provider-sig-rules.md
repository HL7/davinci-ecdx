Some data consumers may require that the data they receive are signed. When performing Task based request when signatures are required on the returned results, the following general rules apply:

- The signature represents a human provider signature on resources attesting that the information is true and accurate to the best of their knowledge.*
- The returned object is either already inherently signed (for example, a wet signature on a PDF or a digitally signed CCDA) or it is transformed into a signed [FHIR Document](http://hl7.org/fhir/documents.html) and `Bundle.signature` used to exchange the signature.

\* Consult with your payer and your legal team for questions reqarding legal liability associated with sharing and signing data.