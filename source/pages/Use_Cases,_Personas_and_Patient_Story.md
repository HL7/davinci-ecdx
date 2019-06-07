---
title: Use Cases, Personas and Patient Story
layout: default
active: Use Cases, Personas and Patient Story
---

Use case scenarios set the scope and form the foundation for this Implementation Guide.  Each use case is designed around a benefit resulting from the information exchange interaction. The following use cases are addressed:

* Improve Care Coordination
* Collect More Accurate Risk Profiles
* Improve Support for Quality Management
* Confirm Medical Necessity More Efficiently
* Improve Member Experience
* Track Referrals and Orders More Effectively

Each Use Case includes an overall description. It provides technical specifications for one or more options showing how FHIR-based mechanisms can be used to accomplish the needed information exchange.


## Business Actors, Technical Actors and Information Exchange Options
The use cases descriptions in the implementation guide focus on business actors (organizations and people who need to share information). The information exchange mechanisms are specified using technical actors (systems involved in making digital information exchange possible). The use of technical actors makes specification of the information sharing mechanisms more generalized. It makes it possible to describe situations where a business actor may use a system that plays different technical roles with respect to how data is shared. For example, a payer's system could play the role of both an Information Sender as well as an Information Request Sender for a request-based information exchange.  

For a data query, the technical actors are an Information Client and an Information Server.  For an unsolicited communication there is an Information Sender and an Information Recipient.  For an asynchronous solicited communication, an Information Request Sender sends a communication request to an Information Request Recipient. The system acting as the Information Request Recipient processes the request as a task that gets completed, then acting as an Information Sender returns information to the Information Recipient (or Recipients) indicated in the communication request. The system that plays the role of the Information Request Sender may or may not be an Information Recipient.  Other systems may play the role of Information Recipient.

## Paradigms and Payloads
The implementation guide makes use of multiple FHIR data sharing paradigms. It utilizes the transaction, messaging, and documents paradigms to facilitate bi-directional digital information exchange between systems used by organizations and individuals. The transaction paradigm supports RESTful APIs for querying data and documents directly. The messaging paradigm supports asynchronous communication requests for information and direct communication of information that needs to be shared or has been requested. The documents paradigm is used to represent information organized in documents. Documents can be attached as the payload of a message. Specific types of documents or data may be requested and are communicated to supply recipients with needed information.  

The payloads for these information exchange interactions may be documents or collections of data.  

A document is a predefined set of information that is persistent, has stewardship, has the potential for authentication, establishes a default context for its contents, is authenticated as a whole, and is human readable. See <a href="http://www.hl7.org/implement/standards/product_brief.cfm?product_id=7">HL7 Clinical Document Architecture</a> for more information about the characteristics of documents.

A collection of data can be any set of resources or a single resource that matches a very specific query. 



