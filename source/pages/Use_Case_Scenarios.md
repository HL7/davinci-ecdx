---
title: Use Case Scenarios
layout: default
active: Use Case Scenarios
---

Use case scenarios set the scope and form the foundation for this Implementation Guide.  Each use case is designed around a benefit resulting from the information exchange interaction. The following use cases are addressed:

* Improve Care Coordination
* Collect More Accurate Risk Profiles
* Improve Support for Quality Management
* Confirm Medical Necessity More Efficiently
* Improve Memeber Experience
* Track Referrals and Orders More Effectively

Each Use Case includes an overall description. It provides technical specifications for one or more options showing how FHIR-based mechanisms can be used to accomplish the needed information exchange.

## Business Actors, Technical Actors and Information Exchange Options
The Da Vinci HRex implementation guide makes use of multiple FHIR data sharing paradigms. It utilizes the transaction, messaging, and documents paradigms to facilitate bi-directional digital discussions between systems. The transaction paradigm supports RESTful APIs for querying data directly. The messaging paradigm supports asynchronous communication requests for information and direct communication of information that needs to be shared or has been requested. The documents paradigm is used to represent information organized in documents. Documents can be attached as the payload of a message. Specific types of documents or data may be requested and are communicated to supply recipients with needed information.  

While the use cases described in the implementation guide focus on business actors such as providers, payers, and other service suppliers. The information exchange mechanisms used to share data between and among these business actors is described using technical actors. The use of technical actors makes the information sharing mechanisms more generalized. It makes it possible to describe situations where a business actor may use a system that plays different technical roles with respect to how data is shared. For example, a payer's system could play the role of both an information sender as well as an information requester for a request-based information exchange.  

For a data query, the technical actors are an Information Requester and an Information Source.  For an unsolicited communication there is a Message Sender and a Message Receiver.  For an asynchronous solicited communication where certain types of information are requested by one actor of another actor, and then the actor receiving the request communicates the requested information to the actor or actors indicated as the information recipient(s) in the original request. The solicited communication includes a Communication Request Sender, a Communication Request Receiver, a Message Sender and a Message Receiver.  The system that plays the role of the Communication Request Receiver also plays the role of the Message Sender. The system that plays the role of the Communication Request Sender may or may not be a Message Receiver.  Other systems may play the role of Message Receiver.

Systems playing the roles of Message Sender, Message Receiver, Communication Request Sender and Communication Request Receiver require document handling capabilities to support payload processing required by the messaging paradigm used in this Implementation Guide.  










