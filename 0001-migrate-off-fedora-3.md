---
layout: default
title: ADR-0001
nav_order: 4
permalink: records/0001/
---
# Migrate off Fedora 3

* Status: proposed
* Decider(s): <!-- required -->
  * Julian Morley
  * Andrew Berger
  * Vivian Wong
  * Tom Cramer
  * Hannah Frost
  * Infrastructure Team
* Author(s):
  * Justin Coyne
  * Mike Giarlo
  * ...
* Date(s): <!-- required -->
  * proposed: 2019-10-29
  * ...

## Context and Problem Statement <!-- required -->

Fedora 3 is unsupported and has been unsupported for four years; it is unlikely to be supported in the foreseeable future. It also requires a difficult-to-support version of the Java Virtual Machine. And yet, Fedora 3 is the cornerstone of our management "repository," in which all SDR content is managed and from which said content flows to access and preservation environments. At the same time, there is a dwindling number of organizations in the cultural heritage community who are still using Fedora 3.

## Decision Drivers <!-- optional -->

* Fedora 3 is unsupported and unlikely to be supported
* Fedora 3 will be harder to install on newer operating systems
* The Fedora 3 data model is not inherently validatable
* The Fedora 3 community is disappearing, so we are increasingly going it alone
* Fedora 3 is a critical piece of SDR infrastructure and represents an enormous risk
* Samvera software that supports Fedora 3 is outdated and maintained/supported only through our own efforts, preventing us from using mainstream Samvera software

## Considered Options <!-- required -->

* Do nothing
* Keep using Fedora 3 & DLSS Infrastructure Team takes over maintenance of Fedora 3 and Fedora 3-supporting software in Samvera community
* Replace Fedora 3 with PostgreSQL
* Replace Fedora 3 with latest Fedora version

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
