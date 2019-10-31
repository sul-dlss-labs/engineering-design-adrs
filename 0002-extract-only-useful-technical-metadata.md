---
layout: default
title: ADR-0002
nav_order: 5
permalink: records/0002/
---
# Extract Only Useful Technical Metadata

* Status: proposed
* Decider(s): <!-- required -->
  * Andrew Berger
  * Vivian Wong
  * Infrastructure Team
* Author(s):
  * Justin Coyne
  * Mike Giarlo
  * ...
* Date(s): <!-- required -->
  * proposed: 2019-10-29
  * ...

## Context and Problem Statement <!-- required -->

Currently we are using JHOVE 1.x to generate voluminous technical metadata for every file and every object accessioning in SDR, and we do not use most of this metadata. This is problematic especially for large & many files: we cannot currently accessioning books with many pages because the technical metadata robot consumes all system memory which causes the virtual machine to kill the JHOVE process.

## Decision Drivers <!-- optional -->

* Cannot accession large files (objects > 1GB or so)
* Cannot accession objects with many pages, such as books
* Blocker for Google Books project
* Causes extreme delays accessioning other content

## Considered Options <!-- required -->

* Do nothing
* Identify, and only persist, *needed* technical metadata (implies using a tool other than JHOVE)
* Stop extracting technical metadata
* Add resources to worker machines
* Run extraction using cloud-based processing

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
