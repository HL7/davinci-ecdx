<!-- ValueSet-cdex-POU-intro.md -->
<!-- ValueSet-cdex-POU.html#cdex-purpose-of-use-value-set-hierarchy -->

This Value Set is draft content. The process for submitting the CDex Temporary Code System POU Codes for inclusion into HL7 Terminology (THO) ACTReason CodeSystem is underway. A final value set will be published as part of an STU update.
{:.stu-note}

### CDex Purpose of Use Value Set Hierarchy

The current state of healthcare data exchange is typically limited to a single, well-known and pre-established purpose-of-use (POU). The CDex Purpose of Use Value Set defines POU with a greater level of discrimination at the transaction level. These codes form a hierarchy where the child concepts have an IS-A relationship with the parents that rolls up to the [45 CFR 164.506 Treatment, Payment, and Health Care Operations (TPO)] concepts. The table and graph below illustrate this hierarchy:

|TPO|HL7 V3 ACTReason POU TPO Codes|CDEX POU Codes|
|---|---|---|
|T|TREAT|TREAT*|
|T||treatment-noa**|
|P||payment-noa**|
|O||operations-noa**|
|P|HPAYMT|COVERAGE*|
|P|HPAYMT|CLMATTCH*|
|P|HPAYMT|COVAUTH*|
|O|HOPERAT|HQUALIMP*|
|O|HOPERAT|HDM*|
|T|TREAT|COC*|
|T||care-planning**|
|O||care-planning**|
|T||social-risk**|
|O||social-risk**|
{:.grid}

\* HL7 ACTReason CodeSystem  
\*\* CDex Temporary Code System Codes

{% include img.html img="POU-rollup.svg" caption = "CDex Purpose of Use Value Set Heirarchy Graph" %}

{% include img.html img="POU-rollup-legend.svg" caption = "Legend" %}

### Using Not OtherWise Enumerated Codes

Implicit in using the *Not OtherWise Enumerated Codes*:
 - treatment-noa
 - payment-noa
 - operations-noa
  
is that an existing concepts do not define the detailed POU and the implementer must supply an additional, alternate code. The resource fragment below shows their use:

{% include noe-fragment.md %}

{% include link-list.md %}