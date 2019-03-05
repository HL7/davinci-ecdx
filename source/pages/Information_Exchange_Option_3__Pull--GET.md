---
title: Information Exchange Option 3  Pull--GET
layout: default
active: Information Exchange Option 3  Pull--GET
---

## Actor Descriptions
### Information Client
The Information Client initiates a query for information from an Information Server.
### Information Server
The Information Server responds to a query for information, returning the query results to the Information Requester.
### Actor-Interaction Diagram
[Rick: Images for UC #4 - slide 2]

## Processing Steps
### Preconditions
An Information Server has health record Information and has implemented a FHIR API that allows the information to be queried.

The Information Server adheres to business rules that govern which patients can be queried by authorized Information Clients and what information can be returned to Information Clients.

The Information Client is authorized to query the Information Server. 

### Trigger
Something in the Information Requester's member-centered workflow happens which causes the need for externally available information.

### Main Flow
A query is made by the Information Client to the Information Source for the needed health record information. Query parameters allow the query to be tailored for the specific member and the specific Information needed. 

The Information Server responds with data that matches the query parameters and is permitted to be shared (based on business rules established by the Information Server).

### Post Conditions
Information Client receives health record information that the Information Server returned.  

If the Information Client was not authorized to query the Information Server, an error condition resulted.

If the patient indicated in the query parameters did not match or was not permitted to be shared with the Information Client, an error condition resulted.

If the type of information requested was not permitted to be shared (based on the business rules of the Information Server), an error condition resulted or that information simply was not returned.

## Sequence Diagram