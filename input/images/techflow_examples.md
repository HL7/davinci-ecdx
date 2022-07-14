---
tags: CDEX
title: CDex Flow Chart
---


# CDex Flow Chart

These example FlowCharts were created to assist the TestScript and Reference Implementation development team and are provided here to assist developers in implementing CDEX transactions.  They are example only and actual workflows may differ from them. 

Individual flowcharts ( the text between the "'''") can be viewed using *flowchart.js*.  flowchart.js is a flowchart DSL and SVG render that runs in the browser and terminal. For more information see https://flowchart.js.org/.  Alternatively this page can be viewed on https://hackmd.io/.


## Attachments

### Client
```flow
st=>start: Start
e=>end: End (Happy Path)
bad_transaction=>end: Transaction Error
bad_sig=>end: Signature invalid

oauth=>subroutine: Authentication and Authorization
get_attach_data=>subroutine: Get Attachments data
sign=>subroutine: Signature Needed:
Bundle into provider signed
Document Bundle
unsolited_claim=>operation: unsolicited claim:
provider assigns the 
tracking control number
on the prior auth and
submitted attachments
unsolited_preauth=>operation: unsolicited pre-auth:
provider assigns the 
tracking control number
on the claim and
submitted attachments
solicited_claim=>operation: solicited claim:
used payer assigned
Claim control number
solicited_preauth=>operation: solicited pre-auth:
used payer assigned 
Claim control number
get_reassoc_data=>subroutine: collect data for reassociation
get_reassoc_data=>subroutine: supply other Data elements
for reassociation to the Claim
add_claim_param=>operation: AttachTo parameter = "claim"
add_preauth_param=>operation: AttachTo parameter = "prior-authorization"
invoke_operation=>subroutine: Provider invokes
$submit-attachment operation
to submit attachments to Payer
http_200=>operation: Receive http 200 Success
http_400=>operation: Receive Error response 
=/- OperationOutcome
is_claim=>condition: Is the documentation
for a Claim?
is_solicited_claim=>condition:  Is it in response to
a request for additional
information for a claim?
is_solicited_preauth=>condition: Is it in response
to a request for additional
information by the payer?
need_sig=>condition: Is a signature needed?
is_signed=>condition: Is the attachment
data already signed
(e.g.,signed CCDA document?)
post_ok=>condition: Is transaction successful?
validate=>subroutine: Testscript: validation step(stub)

st->get_attach_data->need_sig->is_claim
is_claim(yes)->add_claim_param->is_solicited_claim(yes)->solicited_claim->get_reassoc_data->validate->oauth->invoke_operation->post_ok
is_claim(no)->add_preauth_param->is_solicited_preauth(yes)->solicited_preauth->get_reassoc_data->validate->oauth->invoke_operation->post_ok
is_claim(yes)->add_claim_param->is_solicited_claim(no)->unsolited_claim->get_reassoc_data->validate->oauth->invoke_operation->post_ok
is_claim(no)->add_preauth_param->is_solicited_preauth(no)->unsolited_preauth->get_reassoc_data->validate->oauth->invoke_operation->post_ok
need_sig(yes)->is_signed(yes)->is_claim
need_sig(yes)->is_signed(no)->sign->is_claim
need_sig(no,bottom)->is_claim
post_ok(yes)->http_200->e
post_ok(no)->http_400->bad_transaction
```


### Server
```flow
st=>start: Start
e=>end: End (Happy Path)
bad_transaction=>end: Transaction Error
bad_sig=>end: Signature invalid

request=>operation: Receive $submit-attachments
http_200=>operation: Return http 200 Success
http_400=>operation: Return 400+ Error response +/- 
OperationOutcome
oauth_ok=>condition: Is client
authenticated?
req_ok=>condition: Is valid request?
payload_ok=>condition: Is payload valid
FHIR Object
need_sig=>condition: Are signatures
required?
is_signed=>condition: Is attachment signed
FHIR Document
sig_ok=>condition: Is valid signature?
validate=>subroutine: Testscript: validation step(stub)

st->request->oauth_ok
oauth_ok(yes)->req_ok
oauth_ok(no)->http_400->bad_transaction
req_ok(yes)->payload_ok
req_ok(no)->http_400->bad_transaction
payload_ok(yes)->need_sig
payload_ok(no)->http_400->bad_transaction
need_sig(yes)->is_signed
need_sig(no,bottom)->http_200()->e
is_signed(no)->sig_ok
is_signed(yes,bottom)->http_200->e
sig_ok(yes)->http_200->e
sig_ok(no)->http_400->bad_transaction
```


## Direct Query

### Client:
```flow
st=>start: Start
e=>end: End (Happy Path)
bad_transaction=>end: Transaction Error
bad_sig=>end: Signature invalid
disc=>subroutine: Discovery of Patient FHIR_ID
oauth=>subroutine: Authentication and Authorization Workflow
search=>subroutine: Query for data
http1=>operation: Receive http 200 Success
+ SearchBundle payload
http2=>operation: Receive Error response 
=/- OperationOutcome
search_ok=>condition: Query Successful?
validate=>subroutine: Testscript: validation step(stub)
need_sig=>condition: Are signatures
required?
sig_ok=>condition: Is valid signature?
on SearchSet Bundle

st->disc->oauth->search->search_ok
search_ok(yes)->http1->validate->need_sig
search_ok(no)->http2->bad_transaction
need_sig(yes)->sig_ok
need_sig(no,bottom)->e
sig_ok(yes)->e
sig_ok(no)->bad_sig
```
### Server
```flow
st=>start: Start
e=>end: End (Happy Path)
bad_transaction=>end: Transaction Error

request=>operation: Receive FHIR Query
make_bundle=>subroutine: produce FHIR SearchSet Bundle
sign=>subroutine: Signature Needed:
organization signs
SearchSet Bundle
return_200=>operation: Return http 200 Success
payload = Searchset Bundle
return_400=>operation: Return 400+ Error response +/- 
OperationOutcome
oauth_ok=>condition: Is client
authenticated?
req_ok=>condition: Is valid request?
op_ok=>condition: Is operation 
successful?
need_sig=>condition: Are signatures
required?
validate=>subroutine: Testscript: validation step(stub)

st->request->oauth_ok
oauth_ok(yes)->req_ok
oauth_ok(no)->return_400->bad_transaction
req_ok(yes)->make_bundle->op_ok
req_ok(no)->return_400->bad_transaction
op_ok(yes)->validate->need_sig
op_ok(no)->return_400->bad_transaction
need_sig(yes)->sign->return_200->e
need_sig(no,bottom)->return_200->e

```


## Task

### Cient


```flow
st=>start: Start
e=>end: End (Happy Path)
bad_transaction=>end: Transaction Error
bad_sig=>end: Signature invalid

post=>subroutine: POST Task to Server
post_ok=>condition: Is FHIR create
transaction successful?
Receive http 200 Success
fetch_task_ok=>condition: Is FHIR read 
transaction successful?
Receive http 200 Success
fetch_data_ok=>condition: Is FHIR read 
transaction successful?
Receive http 200 Success
search_ok=>condition: Is FHIR search 
transaction successful?
Receive http 200 Success
is_polling=>condition: Client polling
the Task?
is_done=>condition: Is Task completed?
is_notified=>condition: Subscription Notification
that Task completed?
is_contained=>condition: Is Task.output contained?
need_sig=>condition: Is signature
required?
is_signed=>condition: Is attachment signed
FHIR Document
is_ok_sig=>condition: Is valid signature?

disc=>subroutine: Discovery of Patient FHIR_ID
create_task=>subroutine: Create Task resource to request Data
fetch_task=>subroutine: Get completed Task from 
FHIR Server using FHIR read
fetch_data=>subroutine: Get FHIR data referenced
in Task.output using FHIR read
search=>subroutine: Get Data referenced
in Task.output using FHIR search
validate_task1=>subroutine: Testscript: validation step(stub)
validate_task2=>subroutine: Testscript: validation step(stub)
validate_data=>subroutine: Testscript: validation step(stub)
validate_searchset=>subroutine: Testscript: validation step(stub)
validate_fhirdoc=>subroutine: Testscript: validation step(stub)
poll=>subroutine: Polls Task
subscribe=>subroutine: POST Subscription for Task Updates

st->disc->create_task->validate_task1->post->post_ok
post_ok(yes)->is_polling
post_ok(no)->bad_transaction
is_polling(yes)->poll->is_done
is_polling(no)->subscribe->is_notified(yes)->fetch_task
is_notified->fetch_task
is_done(yes)->fetch_task->fetch_task_ok
is_done(no)->poll
fetch_task_ok(yes)->validate_task2->is_contained  
fetch_task_ok(no)->bad_transaction
is_contained(yes)->need_sig
is_contained(no,bottom)->fetch_data->fetch_data_ok
fetch_data_ok(yes)->validate_data->need_sig
fetch_data_ok(no)->bad_transaction
need_sig(yes)->is_signed
need_sig(no,bottom)->e
is_signed(yes)->e
is_signed(no)->bad_sig
```
#### Create Task Resource

```flow
st=>start: Start
e=>end: End (Happy Path)
bad_transaction=>end: Transaction Error
bad_sig=>end: Signature invalid
in_data=>operation: Populate Task with Patient,date,owner,requester
in_text=>operation: Add text to Task.input
in_code=>operation: Add code to Task.input
in_search=>operation: Add search string to Task.input
in_sig=>operation: indicate signature required
in_pou=>operation: Add POU to Task.input
in_wq=>operation: Add Work Queue to Task.input
in_reason=>operation: Add reason code or reference to
Task.reasonCode/reasonReference
is_text=>condition: Is free text request?
is_code=>condition: Is coded request?
is_pou=>condition: Add Purpose of Use Code?
is_sig=>condition: Is Signature required?
is_wq=>condition: Add Work Queue Code?
is_formalauth=>condition: Is formal authorization
needed?
in_formalauth=>operation: Add reference to 
formal request resource (e.g.,CommunicationRequest
or ServiceRequest) to Task.basedOn
is_prov=>condition: Is Provenance needed?
in_prov=>operation: Add request for provenance
to request (as _include param
to search string or free text)

st->in_data->in_reason->is_text(yes)->in_text->is_sig
is_text(no)->is_code(yes)->in_code->is_sig
is_code(no)->in_search->is_sig
is_sig(yes)->in_sig->is_pou
is_sig(no,bottom)->is_pou
is_pou(yes)->in_pou->is_wq
is_pou(no,bottom)->is_wq
is_wq(yes)->in_wq->is_formalauth
is_wq(no,bottom)->is_formalauth
is_formalauth(yes)->in_formalauth->is_prov
is_formalauth(no,bottom)->is_prov
is_prov(yes)->in_prov->e
is_prov(no,bottom)->e
```

#### Subscription Flow

```flow
st=>start: Start
e=>end: End (Happy Path)
bad_transaction=>end: Transaction Error
bad_sig=>end: Signature invalid

create_subsc=>subroutine: Create Subscription resource
to notify When Task is
completed, failed, or rejected 
post=>subroutine: POST Subscription for Task Updates
oauth=>subroutine: Authentication and Authorization Workflow
post=>subroutine: POST Subscription to Server
post_ok=>condition: Is FHIR create
transaction successful?
get_notified=>inputoutput: Get notified Task status updated
cancel_subsc=>subroutine: DELETE Subscription for Task Updates
del_ok=>condition: Is FHIR delete
transaction successful?

st->create_subsc->oauth->post->post_ok

post_ok(yes)->get_notified->cancel_subsc->del_ok
post_ok(no)->bad_transaction

del_ok(yes)->e
del_ok(no)->bad_transaction
```

### Server
```flow
st=>start: Start
e=>end: End (Happy Path)
bad_transaction=>end: Transaction Error
bad_sig=>end: Signature invalid

request=>operation: Receive Task
http_200=>operation: Return http 200 Success
http_400=>operation: Return 400+ Error response +/- 
OperationOutcome
get_data=>subroutine: Get requested data
may require human intervention
validate=>subroutine: Testscript: validation step(stub)
update_taskout=>subroutine: update Task.out with 
external references to the data
update_taskout_contained=>subroutine: Populate Task.contained 
with the requested data
and reference it inTask.out
status_completed=>operation: Change Task.status to "completed"
status_failed=>operation: Change Task.status to "failed"
sign=>subroutine: Signature Needed:
Bundle into provider signed
Document Bundle

oauth_ok=>condition: Is client
authenticated?
req_ok=>condition: Is valid request?
payload_ok=>condition: Is payload valid
FHIR Object
pou_ok=>condition: Is POU(and reason)
appropriate use of data?
need_sig=>condition: Are signatures
required?
is_signed=>condition: Is attachment signed
FHIR Document
sig_ok=>condition: Is valid signature?
is_completed=>condition: Is successful in completing
the request (requested data
is available)
is_contained=>condition: Is output data 
contained in the Task?

st->request->oauth_ok

oauth_ok(yes)->req_ok
oauth_ok(no)->http_400->bad_transaction
req_ok(yes)->payload_ok
req_ok(no)->http_400->bad_transaction

payload_ok(yes)->pou_ok(yes)
payload_ok(no)->http_400->bad_transaction

pou_ok(yes)->get_data->is_completed
pou_ok(no)->http_400->bad_transaction

is_completed(yes)->is_contained
is_completed(no)->status_failed->status_failed->validate

is_contained(yes)->update_taskout_contained->status_completed->validate
is_contained(no)->update_taskout->status_completed->validate

validate->need_sig

need_sig(yes)->sign->http_200->e

need_sig(no,bottom)->http_200->e
```


## Signatures

### Creation 

```flow
st=>start: Start
e=>end: End (Happy Path)
get_cert=>subroutine: Obtain a digital certificate and keys from a third-party certificate authority (CA)
prep_base64_Der=>operation: Prepare base64 DER Certifcate - it is Cert PEM file wihout the footer and header and line returns
jws_header=>operation: Create JWS header to Attach to Bundle
header = {"alg": "RS256","kty": "RS", "x5c": [base64 DER]}
prep_bundle=>operation: Remove the id and meta element from Bundle to be signed
canon_bundle=>operation:  Canonicalize Bundle using IETF JSON Canonicalization Scheme (JCS) 
base64_url_bundle=>operation: base64_urlize the canonicalized bundle- this is the JWS payload.
creat_sig=>operation: Create Signature using private key
and RS256 algorithm to get the JWS compact serialization format
using the header and paylaod as inputs
detach=>operation: detached payload by removing the payload element
from the JWS compact serialization format
base64_jws=>operation: base64 the JWS (not base64_url!)
add_sig=>operation: Append FHIR Signature element to the Bundle be signed

st->get_cert->prep_base64_Der->jws_header->prep_bundle
prep_bundle->canon_bundle->base64_url_bundle->creat_sig->detach
detach->base64_jws->add_sig->e
```

### Validation

```flow
st=>start: Start
e=>end: End (Happy Path)
bad_sig=>end: Invalid Signature
get_cert=>subroutine: Obtain digital public key from
first certificate in JWS header "x5c" key
(or get from sender)
prep_bundle=>operation: Remove the id and meta element from Bundle to be signed
canon_bundle=>operation:  Canonicalize Bundle using IETF JSON Canonicalization Scheme (JCS). 
Signature using public key or Cert
and RS256 algorithm
reattach=>operation: Add payload to JWS compact serialization format
decode_jws=>operation: decode base64 JWS (not base64_url!)
rem_sig=>operation: Remove FHIR Signature element from the signed Bundle
base64_url_bundle=>operation: base64_urlize the canonicalized bundle- this is the JWS payload.
inspect_cert_info=>subroutine: Verify Issuer, Validity Dates, Subject, and KeyUsage of certificate
info_ok=>condition: Certificate information OK
(e.g., not expired)?
verify_sig=>operation: Verify JWS 
is_valid=>condition: Signature validates?

rem_sig->decode_jws->prep_bundle->canon_bundle
canon_bundle->base64_url_bundle->reattach->get_cert->inspect_cert_info
inspect_cert_info->info_ok(yes)->verify_sig->is_valid
inspect_cert_info->info_ok(no)->bad_sig
is_valid(yes)->e
is_valid(no)->bad_sig
```

## Testscripts

### Profile Validation

```flow
st=>start: Start
ts_o1=>subroutine: Testscript: validation step(stub)
ts_cond1=>condition: Is Payload Valid?
ts_e1=>end: Valid Payload
ts_e2=>end: Invalid Payload

st->ts_o1->ts_cond1
ts_cond1(yes)->ts_e1
ts_cond1(no)->ts_e2
```
