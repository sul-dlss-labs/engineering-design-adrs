---
layout: default
title: ADR-0020
nav_order: 23
permalink: records/0020
---
# Create a publish/shelve API that support versions for access systems

* Status: drafted
* Decider(s): <!-- required -->
  * Access Team
  * Infrastructure Team
  * Andrew (Repository Admin)
  * ...
* Date(s):
  * Status (from above): 2024-03-14
  * ...

Technical Story: n/a

## Context and Problem Statement <!-- required -->

Currently dor-services-app (DSA) and the SDR workflow system work together to orchestrate the three steps required for shelving and publishing an object to the access system.  DSA needs to share knowedge with the access systems for how the files in both `/stacks` and `/purl` are to be structured.

1. Put content files on `/stacks` NFS mount (<https://github.com/sul-dlss/dor-services-app/blob/main/app/services/shelving_service.rb#L4>)
1. Put metadata on `/purl` NFS mount (<https://github.com/sul-dlss/dor-services-app/blob/main/app/services/publish/metadata_transfer_service.rb#L5>)
1. Call the "purl-fetcher" API to transfer control of these objecs to the access system (mainly for indexing.)

Ideally, this would be a single API where the files are uploaded and metadata is posted (similar to the SDR deposit API).  This would allow us to decouple DSA, from needing to mount the `/stacks` and `/purl` filesystems.

## Decision Drivers <!-- optional -->

* We need to add support for versions of objects.  An API allows the access team to fully control the implementation of the filesystem required for versions, without having to share that knowledge with DSA.

## Considered Options <!-- required -->

* [option 1]
* [option 2]
* [option 3]
* ... <!-- numbers of options can vary -->

## Decision Outcome <!-- required -->

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences <!-- optional -->

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* ...

### Negative Consequences <!-- optional -->

* [e.g., compromising quality attribute, follow-up decisions required, …]
* ...

## Pros and Cons of the Options <!-- optional -->

### [option 1]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* ... <!-- numbers of pros and cons can vary -->

### [option 2]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* ... <!-- numbers of pros and cons can vary -->

### [option 3]

[example | description | pointer to more information | …] <!-- optional -->

* Good, because [argument a]
* Good, because [argument b]
* Bad, because [argument c]
* ... <!-- numbers of pros and cons can vary -->

## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* ... <!-- numbers of links can vary -->
