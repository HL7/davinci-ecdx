---
title: Information Exchange Option 4  Request--Solicited Communication
layout: default
active: Information Exchange Option 4  Request--Solicited Communication
---

This information exchange mechanism includes useful differences from the Pull (GET) method. 

This is an asynchronous response. This is a curated (or processed) information exchange. It encompasses a task to prepare the response. The task may be completed by a system or a human or a combined effort.

This information exchange method can be used when: the Information Request Sender does not have rights to query the Information Source directly, or the Information Source does not support direct queries (data resides on internal database only), or the information being requested may not yet be available (requires processing time to produce or gather the information) but is expected to become available in the span of time associated with the request. 

## Actor Descriptions
### Information Request Sender
An Information Request Sender is a system that delivers a communication request message to an Information Request Recipient.

### Information Request Recipient
An Information Request Recipient is a system that receives a communication request message from an Information Request Sender. An Information Request Recipient is grouped with an Information Sender.  

The Information Request Recipient processes the communication request message and creates an associated task to gather or generate the requested information and return it within a defined or requested period of time.  The task remains unfinished until the Information Request Recipient returns the requested information. It is then marked completed.

Acting as a Information Sender, the requested information is communicated to the Information Recipient (or Information Recipients) indicated in the previously delivered communication request.

### Information Sender
An Information Sender is a system that delivers a message to an Information Recipient.

### Information Recipient
An Information Recipient is a system that receives a message from an Information Sender.

### Actor-Interaction Diagram
[Rick: Images for UC#4 slide 6]

## Processing Steps
### Preconditions
The Information Request Sender needs certain information and the messaging address for the Information Request Recipient (or Information Request Recipients) is known.

### Trigger
Something in the Information Requester Senders workflow happens to cause the need for information to be collected from an external entity.

### Main Flow
The Information Request Sender sends a communication request message to the Information Request Recipient (or Recipients) asking for health record information. The communication request message includes information about the person, the type of information requested, and the timeframe for the expected response. 

Each Information Request Recipient receives and processes the request. A task or set of tasks are created for information communications that need to be completed. 

As the information becomes available the Information Request Recipient (acting as an Information Sender) communicates the information back to the indicated Information Recipients, referencing the id of the original communication request for reference. The Information Request Recipient only gathers and sends information it determines is appropriate to return to the specified Information Recipient(s).

The Information Request Recipient closes communication request related tasks once the response has been sent.

### Post Conditions
Information Recipients receive requested information that the Information Request Recipient agrees to provide.
## Sequence Diagram