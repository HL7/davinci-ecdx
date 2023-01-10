<!-- ValueSet-cdex-POU-intro.md -->
<!-- ValueSet-cdex-POU.html#cdex-purpose-of-use-value-set-hierarchy -->

### CDex Purpose of Use Value Set Hierarchy

The current state of healthcare data exchange is typically limited to a single, well-known and pre-established purpose-of-use (POU). The CDex Purpose of Use Value Set defines POU with a greater level of discrimination at the transaction level. These codes form a hierarchy where the child concepts have an IS-A relationship with the parents that rolls up to the [45 CFR 164.506 Treatment, Payment, and Health Care Operations (TPO)] concepts. The table and graph below illustrate this hierarchy:

|TPO|HL7 V3 ACTReason POU TPO Codes|CDEX POU Codes|
|---|---|---|
|T|TREAT|TREAT*|
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

{% include link-list.md %}