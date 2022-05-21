The Specification pages provides specific guidance on exchanging clinical data between Payers and Providers.  For general [Background on FHIR], [Conformance Expectations], refer to the corresponding sections in the [Da Vinci Health Record Exchange (HRex)] Implementation Guide.  For Security and Privacy considerations refer to the [Security and Privacy] page.

When we say “Payer” in these pages, we don’t mean to limit ourselves to only Payers. The same technology can be used for other data consumers like Providers.  Consider “Payer” here as a short-hand notation for "data consumer”
{:.bg-info}

FHIR offers numerous architectural approaches for sharing data between systems. Each approach has pros and cons. The most appropriate approach depends on the circumstances under which data is exchanged.  (Review the [Approaches to Exchanging FHIR Data] in the Da Vinci HRex Implementation Guide for more guidance and background.)  This guide focuses on **three** FHIR transaction approaches for requesting information:

1. **[Direct Query]:** Payer directly queries EHR for specific data using the standard FHIR RESTful search.
2. **[Task Based Approach]:** Payer requests the information desired using the FHIR *Task* resource and the EHR supplies the data possibly with human involvement to find/aggregate/filter/approve it.
3. **[Attachments]** <span class="bg-warning">This content is DRAFT and is open for ballot.</span>  Based on pre-defined payor rules or business needs the EHR sends supporting information for claims or prior authorization directly to Payer using a "push" based FHIR operation.

See the [Background](background.html#workflow-overview) page for an overview.

Payers may request data for many patients/members or anticipate large payloads from the Provider. For example, requesting a detailed set clinical information related to their members.  For these requests, the [Bulk Data Access IG] and the [FHIR Asynchronous Request Patterns] specifications may be considered.  However, there has not been enough implementation experience with this use case to provide specific guidance in this guide.
{:.stu-note}

{% include link-list.md %}
