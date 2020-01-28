---
layout: default
title: ADR-0006
nav_order: 9
permalink: records/0006/
---
# Create a Deposit API for SDR

* Status: drafted
* Decider(s): <!-- required -->
  * Andrew Berger
  * Vivian Wong
  * Infrastructure Team
    * Justin Coyne
    * Mike Giarlo
    * Peter Mangiafico
    * Jeremy Nelson
    * Justin Littman
    * Naomi Dushay
    * John Martin
    * Aaron Collier
* Date(s): <!-- required -->
  * drafted: 2019-10-31
  * ...

## Context and Problem Statement <!-- required -->

Currently the way to create new objects in the SDR is to:

1. Register an object (typically using Argo)
1. Move files into the `/dor` mount.
1. Run the assembly workflow (pre-assembly?).

The google books project presents an opportunity to create millions of new objects. We see this as an opportunity to inject an API into the architecture. Creating such and external facing API positions us to accept further deposits from on campus stakeholder such as Big Local News and Open Neuro. APIs allow us to validate the completeness and correctness of the data. We foresee an opportunity to use such an API to refactor internal projects (such as ETDs) so they don't need to have knowledge of the internals of the SDR.

## Decision Drivers <!-- optional -->

* APIs make it possible to decouple implementations.  Our current deposit process is tightly coupled to persistence and we would like to sever this coupling.
* We have potential projects on campus that could deposit to SDR in self-service mode.
* We occasionally have bad data that causes problems in the workflow.  Having an API would allow us to detect these problems earlier.

## Considered Options <!-- required -->

1. Use existing process (no API)
1. Create an API

## Decision Outcome <!-- required -->

TBD

## Pros and Cons of the Options <!-- optional -->

### Create a deposit API

* Pro
  * Early data validation.
  * Depositors don't need to understand how DOR works.
  * Offer SDR services to more patrons.
* Con
  * We have another service to monitor and keep updated.

### Do nothing

* Pro
  * Less work
* Con
  * Depositors need intimate knowledge of DOR to deposit
  * Clearer path to opening up content flows to campus stakeholders
