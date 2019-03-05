---
title: Information Exchange Option 2  Push--Unsolicited Communication
layout: default
active: Information Exchange Option 2  Push--Unsolicited Communication
---

This information exchange mechanism includes useful differences from the Push (POST and PUT) method also used to create and update information on an external system. 

This is a curated (or processed) information exchange. It encompasses a task to accept/process the response. The task may be completed by a system or a human or a combined effort.

This information exchange method can be used when: the Information Sender does not have rights to post/put information directly on the Information Recipient system, or the Information Recipient System does not support direct POST/PUT operations, or the information being provided may not be expected (requires processing to review or make decisions about the information before it is incorporated into the receiving system). 

## Actor Descriptions
### Information Sender
An Information Sender is a system that delivers a message to an Information Recipient.
### Information Recipient
An Information Recipient is a system that receives a message from an Information Sender.
### Actor-Interaction Diagram
[Rick: Images for UC#4 slide 4]

## Processing Steps
### Preconditions
The Information Sender has established rules about information sharing requirements after various types of service events occur, 

The Information Sender has access to look-up digital addresses for Information Recipients or has previously been given the address information for the Information Recipient.

### Trigger
Something in the Information Sender's workflow happens to cause the need for information to be shared with an external entity.

### Main Flow
The Information Sender sends a communication message with the agreed health record information to the Information Recipient(s) who are known to need the information.

### Post Conditions
Each Information Recipient receives the communication message and processes it according to their business logic. 

## Sequence Diagram