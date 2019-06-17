---
title: Information Exchange Interactions and Specifications
layout: default
active: Information Exchange Interactions and Specifications
---

[Previous Page](Argonaut_FHIR_(DSTU2)_Profiles.html)

## Actor Requirements to Support CDex Implementation Guide

## Information Server
A system acting as an Information Server SHALL support receiving a Push (POST/PUT) interaction using any of the Profiles supported by the CDex IG.
A system acting as an Information Server SHALL support receiving a Pull (GET) interaction using any of the Profiles supported by the CDex IG.
## Information Client
A system acting as an Information Client SHALL support initiating a Push (POST/PUT) interaction using any of the Profiles supported by the CDex IG..
A system acting as an Information Client SHALL support initiating a Pull (GET) interaction using any of the Profiles supported by the CDex IG.

## Information Sender
A system acting as an Information Sender SHALL support initiating a Push (POST/PUT) interaction using the CDex Communication Resource Profile.
When grouped with an Information Request Recipient, the system SHALL support including the Communication Request Resource identifier in the Communication.
## Information Sender with task-based workflow option
When supporting the task-based workflow option, the Information Sender SHALL support generating and sharing a Communication Resource according to the CDex Communication Resource Profile. The system SHALL support initiating a Push (POST/PUT) interaction of a Communication Task to an Information Recipient.
## Information Recipient
A system acting as an Information Recipient SHALL support receiving a Push (POST/PUT) interaction for a CDex Communication Resource Profile.
When grouped with an Information Request Sender, the system SHALL support processing the Communication Resource identifier in the received Communication.
## Information Recipient with task-based workflow option
When supporting the task-based workflow option, the Information Recipient SHALL support receiving a Push (POST/PUT) interaction of a CDex Communication Task from an Information Sender. The system SHALL support initiating a Pull (GET) interaction to retrieve the Communication Resource identified in the Communication Task.

## Information Request Sender
A system acting as an Information Request Sender SHALL support initiating a Push (POST/PUT) interaction using the CDex Communication Request Resource Profile. 
## Information Request Sender with task-based workflow option
When supporting the task-based workflow option, the Information Request Sender SHALL support generating a Communication Request Resource according to the CDex Communication Request Resource Profile. The system SHALL support initiating a Push (POST/PUT) interaction of a Communication Request Task to an Information Request Recipient.

## Information Request Recipient
A system acting as an Information Request Recipient SHALL support receiving a Push (POST/PUT) interaction for a CDex Communication Request Task Profile from an Information Request Sender. When grouped with an Information Sender, the system SHALL support processing the Communication Request Resource and generating a Communication Resource with the requested information and including the identifier of the corresponding Communication Request.

## Information Request Recipient with task-based workflow option
When supporting the task-based workflow option, the Information Request Recipient SHALL support receiving a Push (POST/PUT) interaction of a Communication Request Task from an Information Request Sender. The system SHALL support initiating a Pull (GET) interaction to retrieve the Communication Request Resource identified in the Communication Request Task.

[Next Page](Push_(POST_and_PUT).html)