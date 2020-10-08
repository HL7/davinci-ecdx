{% assign base_id = {{include.id}} %}
{% assign base_type = {{site.data.structuredefinitions.[base_id].type}} %}

<!-- {{ %raw% }}### Mandatory and Must Support Data Elements

The following data-elements are mandatory (i.e., data MUST be present) or must be supported if the data is present in the sending system ([Must Support] definition). They are presented below in a simple human-readable explanation.  Profile specific guidance and examples are provided as well.  The [Formal Profile Definition] below provides the  formal summary, definitions, and  terminology requirements.

**Each {{{base_type}} must have:**

1. A logical id
1. A type code of "message"
1. A timestamp
1. An entry for the MessageHeader
1. An entry for the event or request resource reference by 'MessageHeader.focus'
{{% endraw %}} -->
**Additional Profile specific implementation guidance:**

The elements `Task.focus` is constrained to only reference a contained CommunicationRequest instance.

### Examples

- [Task minimal example]({{site.data.fhir.ver.hrex}}/2020Sep/Task-min.html#root)
- [Task minimal example with contained CommunicationRequest]c(Task-query-request-contained.json.html)
- [Task Data Request - completed query example]({{site.data.fhir.ver.hrex}}/2020Sep/Task-query-complete.html)
- [Task Data Request - completed query example with contained CommunicationRequest](Task-query-complete-contained.html)

- [Bundle Discharge Notification Message Bundle 01]

{% include link-list.md %}
