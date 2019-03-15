---
title: CDex Track Referrals and Orders
layout: default
active: CDex Track Referrals and Orders
---

## Use Case Description
Sharing clinical information also supports providers as they place and complete orders and referrals for care. The receiving provider needs the order and supporting documentation as soon as it is signed. And the referring/ordering provider needs the results from the referral / order in a clinically significant time after the resulting work is completed.  There may be a need to receive intermediate information with each visit or at the end of some defined period for an extended process (e.g. home health). Initially, information comes from the ordering/referring  provider. Then, once services begin to be provided, information comes from the performing provider. The signed order/referral and documentation is needed to demonstrate medical necessity of the ordered services. This information must be supplied by the ordering provider to the performing provider so that the performing provider has what is needed to submit their claim for performing the services.

This use case includes a standard method to convey order and referral identifiers to facilitate information exchange between systems. The identifier makes it possible to manage inbound and outbound referral or order transactions. Including a "universally usable" referral or order id allows information related to a referral or order to be tracked and handled by all systems involved in the workflow to complete the care.

## Examples

### Referral Example
A 55-year old male patient with diabetes and a strong family history of coronary artery disease visits his primary care provider (PCP) complaining of a sudden onset of shortness of breath worse with exertion. After completing a history and performing a physical exam, the physician is concerned the patient may have a cardiac condition. She places a cardiology referral with the reason for evaluation of rule out cardiac causes of dyspnea with a request to have the patient seen in a week. The PCPs PMEHR routes the referral request to the back-office staff (using the Practice Management functionality PM of the PMEHR.

The PCPs back-office staff sends the cardiology referral request to the patients insurance company for approval. In addition to the referral request, the back-office staff also sends prior notes about the patient and any relevant laboratory test results. The supporting information is used by the health plan to approve the referral. The patients insurance company returns the authorization with a list of Cardiology practices and information about the quality of care scores and costs to help determine which Cardiologist to see. The provider shares the received information with the patient. The doctor and patient determine which Cardiologist to consult. The office staff faxes the referral request to the cardiology office that includes the patients demographics, insurance information with authorization, the PCPs clinical question, and a request to have the patient seen in a week.

The cardiologists office receives the referral request and contacts the patient to schedule an appointment. They arrange an appointment for three days later. The cardiologist's office may (or may not) notify the PCP office of the patients appointment. The cardiologist's office notifies the patient's health plan of the scheduled appointment for the referral.  Based on the date of the scheduled appointment, the health plan sends the cardiologist's office new, relevant clinical information for the patient on the day before the appointment.

The patient sees the cardiologist who has a high index of suspicion for coronary artery disease and schedules a cardiac catheterization. The cardiologist completes a Consultation Note. The cardiology back-office staff sends the Consultation Note to the PCPs office. The PCPs office may (or may not) review the Consultation Note.  They may have a manual or automated process to update the patient's information based on information in the Consultation Note returned from the cardiologist's team.

The cardiologist performs the cardiac catheterization and finds extensive coronary artery disease. The cardiologist completes the diagnostic cardiac catheterization report with suggestions to update the patient's plan of care. The cardiologist's back office staff sends a Progress Note to the PCP's office which includes result information from the diagnostic cardiac catheterization report. The PCP's office may have a manual or automated process for to update the patients information based on information in the Progress Note returned from the cardiologist's team.

Each message sent between the PCP, the payer, and the specialist results in a separate message transaction. The messages and the information in the messages are all linked together, through use of an identifier that identifies the referral across the separate systems.


### Order Example
A patient is discharged from the hospital post C-section with orders for home health services to evaluate and treat a slow healing incision. The orders are sent to a home health services selected by the patient and her family during discharge planning. The home health agency receives the order. A home health nurse does an assessment of the patient and documents her needs in a home health plan of care using the agency's home health system. The home health plan of care includes the order for daily wet-to-dry dressing changes for her incision. It includes a requirement for the provider of record to sign-off on the home health plan of care. 

A copy of the home health assessment and plan of care as well as information identifying the initial order request transaction is sent to the provider of record. The provider of record receives the message, reviews the assessment and plan.  He signs off on the home health plan of care and attaches it to the patient's chart in his system. He returns the signed plan of care back to the home health agency. 

The patient's incision worsens. 

The home health nurse sends an updated order request to increase dressing changes from daily to twice a day. She includes an image of the wound and scanned nursing notes describing the incision as well as wound measurements. The provider of record receives the information and decides to order wound vac therapy instead of wet to dry dressing changes. The order for wet to dry dressing changes is stopped and a new order for wound vac therapy is added. The updated home health care plan is signed by the provider of record, added to the patient's chart, then forwarded to the home health agency. The message is received by the home health agency and it becomes available for review as new information associated with the patient's home health care plan. 

A home health nurse reviews the updated plan information from the provider of record. The home health nurse sends a message to the provider of record with a request for the provider of record to obtain pre-authorization from the patient's payer. This is needed prior to starting wound vac therapy. The provider of record obtains the pre-authorization and forwards the information back to the home health agency. The home health nurse obtains the wound vac therapy. She adds the care plan changes for the patient in her system (which may be a manual or automated step). The order updates and the pre-authorization information are attached to patient's chart in the home health system. She initiates the ordered therapy to begin for the patient.
 
Each message sent between the provider of record, the payer, and the home health nurse results in a separate message transaction. The messages and the information in the messages are all linked together, through use of an identifier that identifies the order across the separate systems.

