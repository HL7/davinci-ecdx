---
title: Information Exchange Option 1  Push--POST and PUT
layout: default
active: Information Exchange Option 1  Push--POST and PUT
---

## Actor Descriptions
### Information Client
The Information Client initiates a transaction to store (create) or modify (update) information on the Information Server.
### Information Server
The Information Server accepts the information provided by the Information Client,.
### Actor Interaction Diagram
See <a href="https://trifolia-fhir.lantanagroup.com/igs/davinci-cdex/Push_(POST_and_PUT).html">Push (POST and PUT) Actor Interaction Diagram</a> for an illustration.

## Processing Steps
### Preconditions
An Information Client has health record Information and wants to supply it via an Information Server with a FHIR API that allows information from the Information Client to be pushed directly to the server.

The Information Server adheres to business rules that govern which Information Clients can push information to the server.

The Information Client is authorized to create new or update information onto the Information Server. 

A secure information transport mechanism exists between the Information Sender and all Information Recipients (https)

### Trigger
Something in the Information Client's workflow happens which causes the need to share new or updated information with an external system.

### Main Flow
A POST or PUT is made by the Information Client to the Information Server to store provided health record information.  

### Post Conditions
Information Server receives health record information that the Information Client provided.  

If the Information Client was not authorized to POST/PUT information on the Information Server, an error condition resulted.

If the Patient Resource associated with the information was not appropriate to be shared with the Information Server, an error condition resulted and subsequent action was taken by the Information Server to delete the information that was PUT/POSTed.

If the type of information provided was not permitted to be received (based on the business rules of the Information Server), an error condition resulted and the information was deleted.



