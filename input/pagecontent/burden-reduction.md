

In [Da Vinci - Prior Authorization Support] (PAS), the expectation is that a final decision is generated immediately and automatically in the majority of cases.  The flow below depicts the cases where the result is "pended" and additional data is needed.  In these cases the Payer or Provider may elect to use a CDex Transaction to request or submit attachments.  The flow sheets diagrams below illustrate where in the PAS workflow the Payer could use CDEX to request attachments and the Provider could use CDEX to submit attachments.

There is no direct intersection with [Da Vinci - Documentation Templates and Rules](http://hl7.org/fhir/us/davinci-dtr/index.html) (DTR) workflow. In DTR, the Questionnaire/QuestionnaireResponse asking for additional information is held until any [required Tasks](http://hl7.org/fhir/us/davinci-dtr/specification__behaviors__task_creation.html) are completed and the question is answered which not compatible with the CDex attachments workflow.
{: .bg-info}

{% include img.html img="burden-reduction-flow.svg" caption="CDex in DaVinci Burden Reduction Workflow" %}


{% include img.html img="pas-pended-flow.svg" caption="CDex in DaVinci PAS 'Pended' Workflow" %}

{% include link-list.md %}