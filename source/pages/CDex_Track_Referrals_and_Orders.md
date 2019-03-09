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
A patient is seen by his PCP with complaints of shortness of breath. The patient has a BMI of 30, no history of smoking, no complaints of chest pain, no physical signs of respiratory and cardiac problems, and a familial history of coronary artery disease. His PCP, orders a referral to a cardiologist, stating the clinical question as, "Determine the origin of the patient's shortness of breath". 

Based on the practice's workflows and the PCP's system's handling of referrals, a Referral Note is created which contains the above noted findings, demographic information, patient history, lab results, and patient insurance.

The referral request is sent to the cardiologist's practice, with the additional indication that the patient is to be seen within a week. The cardiology practice receives the referral request, sends for and receives prior authorization, and based on the practice's workflows and their system's handling of referral requests, an affirmative response to the request is sent to the referring practice.

The cardiology practice calls the patient and schedules an appointment three days later. Based on the practice's workflows and their system's handling of referral requests, a notification is sent of the scheduled appointment date/time to the patient's PCP. 

The patient goes to the appointment with the Cardiologist, and unfortunately is diagnosed with coronary artery disease and a cardiac catheterization is scheduled.

The Cardiologist completes the Consultation Note and it is sent to the referring physician, answering the clinical question and including the date of the planned cardiac catheterization diagnostic procedure. The PCP receives the message, reviews the note, and adds the documentation to his patient's chart.

After the catheterization is performed, the results are reviewed by the Cardiologist and another Consultation Note is sent to the referring physician, including a suggested plan of care. The PCP receives the message, reviews the note, and and adds the documentation to his patient's chart. He incorporates the suggested plan of care for the patient into the patient's overall care plan and closes the referral to the specialist.

### Order Example

A patient is discharged from the hospital post C-section with orders for home health
services to evaluate and treat a slow healing incision. 

Initial home health assessment includes a request to the provider of record (Dr. Woods) for approval of the initial home health plan of care. The plan of care includes an order for daily wet-to-dry dressing changes for her incision. The home health assessment and plan of care is documented in the home health system. A copy of the assessment and plan of care as well as the initial order request transaction is sent to Dr. Woods. 

Dr. Woods receives the message, reviews the assessment and plan.  He signs off on the home health plan of care and attaches it to the patient's chart. He returns the signed plan of care back to the home health agency. 

The patient's incision worsens. 

The home health nurse sends an updated order request to increase dressing changes from daily to twice a day. She includes an image of the wound and scanned nursing notes describing the incision as well as wound measurements. Dr. Woods receives the information and decides to order wound vac therapy instead of wet to dry dressing changes. The order for wet to dry dressing changes is stopped and a new order for wound vac therapy is added. The updated home health care plan is signed by Dr. Woods, added to the patient's chart, and forwarded to the home health agency.

The message is received by the home health agency and it becomes available for review as new information associated with the patient's home health care plan. A home health nurse reviews the updated plan from Dr. Woods. The home health nurse sends a message to Dr. Woods with a request for Dr. Woods to obtain pre-authorization from the patient's payer. This is needed prior to starting wound vac therapy. 

Dr. Woods obtains the pre-authorization and forwards the information back to the home health agency. 

The home health nurse obtains the wound vac therapy payer pre-author. She adds the care plan changes for the patient in her system (which may be a manual or automated step). The updated plan and the pre-authorization information are attached to patient's chart in the home health system. She initiates the ordered therapy to begin for the patient. 

Each message sent between Dr. Woods, the payer, and the home health nurse results in a separate message transaction. The messages and the information in the messages are all linked together through the use of an id that identifies the order across the separate systems.