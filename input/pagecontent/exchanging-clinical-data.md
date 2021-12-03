The Specification pages provides specific guidance on exchanging clinical data between Payers and Providers.  For general [Background on FHIR], [Conformance Expectations], refer to the corresponding sections in the [Da Vinci Health Record Exchange (HRex)] Implementation Guide.  For Security and Privacy considerations refer to the [Security and Privacy] page.

<div markdown="1" class="new-content">

When we say “Payer” on this page, we don’t mean to limit ourselves to only Payers. The same technology can be used for other data consumers like Providers.  Consider “Payer” here as a short-hand notation for "data consumer”
{:.bg-info}

</div>

FHIR offers numerous architectural approaches for sharing data between systems. Each approach has pros and cons. The most appropriate approach depends on the circumstances under which data is exchanged.  (Review the [Approaches to Exchanging FHIR Data] in the Da Vinci HRex Implementation Guide for more guidance and background.)  The guide focuses on <span markdown="1" class="bg-success">**three**</span> FHIR transaction approaches for requesting information:

1. **[Direct Query] (preferred):** Payer directly queries EHR for specific data using the standard FHIR RESTful search.
1. **[Task Based Approach]:** Payer identifies the 'type' of information desired and the EHR supplies the data possibly with human involvement to find/aggregate/filter/approve it.
1. {:.new-content}**[Attachments]** Based on pre-defined payor rules or business needs the EHR sends claims data directly to Payer without an explicit Payer request.

See the [Background](background.html#workflow-overview) page for an overview.
{:.new-content}

Payers may request data for many patients/members or anticipate large payloads from the Provider. For example, requesting all the information related to  their members using <span markdown='1' class="bg-success">`POST [base]/Group/$export`</span>.  For these requests, the [FHIR Bulk Data Access] and the [FHIR Asynchronous Request Patterns] specifications may be considered.  However, there has not been enough implementation experience with this use case to provide specific guidance in this guide.
{:.stu-note}

{% include link-list.md %}
