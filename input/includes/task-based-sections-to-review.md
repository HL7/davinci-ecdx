Payers can request attachments and additional data for claims and prior authorizations as a FHIR transaction. CDex uses [Task] to represent both the data request and the returned data and provides information such as why it needs to be completed, who is to complete it, who is asking for it, when it is due, etc. The Provider updates the Task’s status as the task is fulfilled. 

The [Task Based Approach] page documents the general approach to using Task to request data.  For requesting attachments using CDex Attachments, review the following sections on the Task Based Approach page:

- [Benefits]
- [Task Inputs and Outputs]
- [Purpose of Use]
- [Task Reason]
- [Discovery of Identifiers]
- [Task State Machine]
- [Using Questionnaire as Task Input]

In the more general CDEX Task Based Approach, the Data Consumer polls or subscribes to Task status updates and *pulls* the data when the Task is complete. In contrast, for CDEX Attachments, The Provider *pushes* the data to the Payer-supplied endpoint using the [`$submit-attachment`] operation, as documented on the [Sending Attachments] page. 
{:.bg-info}



#### CDex Attachment Request Profile

**For CDex attachment requests transactions, the Payer SHALL use the [CDex Task Attachment Request Profile] to solicit information from a Provider.** 
<!-- {% raw %} {{ site.data.resources.['StructureDefinition/cdex-task-attachment-request']['description'] }} {% endraw %} -->
For a detailed description of all the mandatory, [*must support*], and optional elements, as well as formal definitions and profile views, see the [CDex Task Data Request Profile] page.