---
title: About Workflow Support in FHIR
layout: default
active: About Workflow Support in FHIR
---

## Workflow in FHIR
Workflow is an essential part of healthcare - orders, care protocols, referrals are the drivers of most activity within in-patient settings and a great deal of activity in community care as well. FHIR is concerned with workflow when there's a need to share information about workflow state or relationships, when there's a need to coordinate or drive the execution of workflow across systems and when there's a need to define allowed actions, dependencies and conditions on behavior.

See the FHIR specification for more information on <a href="http://hl7.org/FHIR/workflow.html">FHIR Workflow.</a>

### About FHIR Tasks
The FHIR Task resource is used to represent a task that needs to be performed. A task resource describes an activity that can be performed and tracks the state of completion of that activity. It is a representation that an activity should be or has been initiated, and eventually, represents the successful or unsuccessful completion of that activity.

See the FHIR Specification for more information about the <a href="http://hl7.org/FHIR/workflow.html#respatterns">Workflow Resource Pattern</a>  and the Task State Machine and the <a href="http://hl7.org/FHIR/valueset-task-status.html">allowable states.</a> 

### Support for Tasks
In a RESTful context, a server functions as a repository of tasks. The server itself, or other agents are expected to monitor task activity and initiate appropriate actions to ensure task completion, updating the status of the task as it proceeds through its various stages of completion. These agents can be coordinated, following well choreographed business logic to ensure that tasks are completed. Task management may also be centrally controlled using some form of a workflow engine, in which case, the workflow engine itself may update and maintain the task resources in the server, and through its orchestration activities ensure that tasks are completed. The task resource enables either model of task management yet provides a consistent view of the status of tasks being executed in support of healthcare workflows.

The assignment of tasks into categories by type of task, type of performer and task status enable the server to function as a queue of work items. This queue can be polled or subscribed to by various agents, enabling automation of workflows in FHIR using existing search and subscription mechanisms. Owners, requesters, other agents (e.g. workflow managers) can thus be ready to initiate the next steps in a complex workflow.

