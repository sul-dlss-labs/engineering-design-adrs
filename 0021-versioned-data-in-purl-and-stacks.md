---
layout: default
title: ADR-0021
nav_order: 24
permalink: records/0021
---
# Versioned data in purl and stacks

* Status: drafted
* Decider(s): <!-- required -->
  * Access Team
  * Julian Morley
  * Andrew Berger
  * ...
* Date(s): <!-- required -->
  * Drafted: 2024-03-15
  * ...

Technical Story: n/a

## Context and Problem Statement <!-- required -->

Open Access (OA) guidelines require that we allow authors to publish each version of a schollarly work as citeable. In order to acchieve this, we will have a unique and stable URL for each version.  Presently we only support a single version in the access (purl/stacks based) systems.

## Decision Drivers <!-- optional -->

* Need to serve multiple versions of data and metadata for each work.
* We don't want to duplicate data that exists in multiple versions
* ... <!-- numbers of drivers can vary -->

## Considered Options

* Use the Oxford Common File Layout (OCFL) <https://ocfl.io/>.  We would merge the existing purl (metadata) and stacks (data) file systems into a single filesystem.  Each object will have a separate metadata and data directory under it.
* A separate directory for each version under the object directory
  * Optionally using a file system that can deduplicate data.
* Create a new SDR item for each version.

## Decision Outcome

Chosen option: "Oxford Common File Layout", because this has the capability of storing multiple versions.  It can deduplicate data it does not require any complex configuration or exotic file system.

### Positive Consequences <!-- optional -->

* Closer association between data and metadata

### Negative Consequences <!-- optional -->

* Converting all the data and applications will take time

## Pros and Cons of the Options

### Oxford Common File Layout (OCFL)

<https://ocfl.io/>

* Good, because data is deduplicated between versions
* Good, because other cultural heritage institutions use OCFL for versioning.
* Good, because it runs on common file systems.
* Good, because it's a relatively simple specification.
* Bad, because data migration is required
* Bad, because application changes are required

### separate directory for each version under the object directory

* Good, because the structure is very simple. No manifest is needed.
* Bad, because data from one version would need to be copied to another version.
* Bad, because mitigating duplicate data may require esoteric file systems.

### Create a new SDR item for each version

* Good, because no migration of data or systems is required
* Bad, because data would be massivly duplicated as new versions were created
* Bad, because multiple versions of each object would show up in discovery and management interfaces.

## Links

* Related to [ADR-0020](0020-purl-fetcher-api.md)
