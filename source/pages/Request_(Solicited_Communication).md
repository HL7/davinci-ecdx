---
title: Request (Solicited Communication)
layout: default
active: Request (Solicited Communication)
---

[Previous Page](Pull_(GET).html)

This information exchange mechanism includes useful differences from the Pull (GET) method. 

This is an asynchronous response. This is a curated (or processed) information exchange. It encompasses a task to prepare the response. The task may be completed by a system or a human or a combined effort.

This information exchange method can be used when: the Information Request Sender does not have rights to query the Information Source directly, or the Information Source does not support direct queries (data resides on internal database only), or the information being requested may not yet be available (requires processing time to produce or gather the information) but is expected to become available in the span of time associated with the request.  Use of the Task-based workflow option permits the Information Request Receiver to determine if they will process the communication request or not and it allows the Information Request Sender to monitor progress on the processing of the request.
## Information Exchange Interaction Description
The Request (Solicited Communication) information exchange interaction is a alternative way to handle a Pull interaction for FHIR APIs. It uses the CommunicationRequest Resource to send a message that communicates an information request.  The CommunicationRequest includes the kind of information requested. It may also information supporting the request and the tasks requested to be performed associated with the information to be returned. The Information Request Recipient processes the message payload, performs the tasks based on their business logic and internal processes, then returns the requested information and the completed task information in a Communication Message that is linked to the original Information Request Message through an identifier established in the request. The Information Request Recipient acts an an Information Sender and returns the requested information to the Information Recipient(s) identified in the original CommunicationRequest. The Information Recipient's business rules for processing the communicated information are outside the scope of this implementation guide.

## Actor Descriptions
### Information Request Sender
An Information Request Sender is a system that delivers a communication request message to an Information Request Recipient. When the task-based workflow option is supported, the Information Request Sender pushes a communication request task to an Information Request Recipient which enables the Information Request Recipients to pull the communication request from the Information Request Sender. 

### Information Request Recipient
An Information Request Recipient is a system that receives a communication request message from an Information Request Sender. An Information Request Recipient is grouped with an Information Sender.  When the task-based workflow option is supported, the Information Request Recipient receives a communication request task from an Information Request Sender which enables the Information Request Recipients to pull the communication request from the Information Request Sender. 

The Information Request Recipient processes the communication request task.  In the "happy case", the system decides to get and perform the communication request. It gathers or generates the requested information and returns it within the defined or requested period of time.  The task remains unfinished until the Information Request Recipient returns the requested information. It is then marked completed.

Acting as an Information Sender, the requested information is communicated to the Information Recipient (or Information Recipients) indicated in the previously delivered communication request. When the task-based worflow option is supported, the Information Sender pushes a communication task to the Information Recipient(s). Each Information Recipient system determines if and when to get the available information. 

### Information Sender
An Information Sender is a system that delivers a communication message to an Information Recipient. When the task-based workflow option is supported, the Information Sender delivers a communication task to the Information Recipients system which enables the Information Recipient to get the available information.

### Information Recipient
An Information Recipient is a system that receives a communication message from an Information Sender. When the task-based workflow option is supported, the Information Recipient receives a communication task from an Information Sender which enables the information Recipient to get the available information.
## Actor Interaction Diagram
### Solicited Communication without Task 


<table><tr><td><img src="Request Solicited-noTask.png" alt="RequestSolicitednoTask" /></td></tr></table>

### Solicited Communication With Task

<table><tr><td><img src="Request Solicited-with Task.png" alt="RequestSolicitedwithTask" /></td></tr></table>

## Processing Steps
### Preconditions
The Information Request Sender needs certain information and the messaging address for the Information Request Recipient (or Information Request Recipients) is known.
### Trigger
Something in the Information Requester Senders workflow happens to cause the need for information to be collected from an external entity.
### Main Flow
The Information Request Sender sends a communication request message to the Information Request Recipient (or Recipients) asking for health record information. The communication request message includes information about the person, the type of information requested, and the timeframe for the expected response.

Each Information Request Recipient receives and processes the request. A task or set of tasks are created for information communications that need to be completed. The specification includes expected processing tasks to be completed by the Information Request Recipient.

The Information Request Recipient performs the requested tasks, based on their own governance, business logic and workflows.

As the information becomes available the Information Request Recipient (acting as an Information Sender) communicates information back to the indicated Information Recipients, referencing the id of the original communication request for reference, until the tasks associated with the communication request are completed. The Information Request Recipient only gathers and sends information it determines is appropriate to return to the specified Information Recipient(s), based on its own governance, business logic and workflows.

The Information Request Recipient closes communication request related tasks once the response has been sent.

### Post Conditions
Information Recipients receive information that the Information Request Recipient agrees to provide in response to the communication request.
## Detailed Specification
For a more detailed specification of the <a href="https://build.fhir.org/ig/HL7/davinci-ehrx/HRex_Interactions.html">Push (Unsolicited Communication) Interaction</a>, consult the HRex implementation guide.

	

[Next Page](Subscribe.html)