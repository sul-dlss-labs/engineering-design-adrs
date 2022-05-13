---
layout: default
title: ADR-0015
nav_order: 18
permalink: records/0015
---
# Replace Openwayback with pywb

* Status: [proposed] <!-- required -->
* Decider(s): <!-- required -->
  * Andrew Berger
  * Peter Chan
  * Vivian Wong
  * Infrastructure Team
    * Aaron Collier
    * Justin Coyne
    * Naomi Dushay
    * Mike Giarlo
    * Justin Littman
    * Peter Mangiafico
    * John Martin
    * Ed Summers
    * Laura Wrubel

* Date(s): <!-- required -->
  * proposed: 2022-05-17

## Context and Problem Statement <!-- required -->

We currently use a [fork of Openwayback](https://github.com/sul-dlss/openwayback) to provide replay of web archive files (WARCs) in the Stanford Web Archive Portal (SWAP). Openwayback does not successfully replay all WARCs that are replayable elsewhere (e.g. Archive-It's Python Wayback), particularly those with Javascript, videos, and other dynamic content.  Our openwayback repo has been significantly modified and is not possible to update with upstream changes without considerable effort, as explored in [swap](https://github.com/sul-dlss/swap). Our existing CDX files are 10-column indexes which lack the compressed length field and do not use SURT-ordered keys, both of which are typical and useful in current index approaches.

The purpose of this ADR is to propose an alternative replay framework and indexing approach.

## Decision Drivers <!-- optional -->

* Support replay of WARCs with dynamic content as well as legacy WARCs, including from the early Web (SLAC)
* Support for indexing WARCs into CDX/CDXJ format
* Can exclude content at the URL level, at a minimum
* Infrastructure team can support application
* Operations team can support application
* Use actively developed software with community support

## Considered Options <!-- required -->

* pywb
* pywb + OutbackCDX
* Upstream Openwayback

## Pros and Cons of the Options

The following three options all employ open source software. pywb is licensed with the [AGPL](https://en.wikipedia.org/wiki/GNU_Affero_General_Public_License), which would prevent closed source reuse or alternative licensing of pywb. OpenWayback and OutbackCDX both use the liberal Apache license.

### pywb

* Pro
  * pywb is replacing Openwayback as wayback machine of choice among institutions running a replay system.
  * Does not require customization to provide access to crawl dates pre-1996.
  * Can continue to leverage the filesystem as a way to communicate between the workflow and the playback application.
  * Active development is occurring on the software.
  * Supports embargos and exclusions at a URL level.
  * Increasingly used by community, [recommended by IIPC](https://netpreserveblog.wordpress.com/2020/12/16/openwayback-to-pywb-transition-guide/) for replay of high-fidelity archiving. [Transition guide](https://pywb.readthedocs.io/en/latest/manual/owb-transition.html) exists.
* Con
  * As a Python application, is less familiar to developers and operations team
  * pywb development is currently done in large part by one developer
  * adding new WARC data to a collection involves merging the existing index with the new index, which can involve unknown amounts of time as collections get bigger.
* Additional context
  * It is best practice to reindex WARCs when switching to a new playback system, for consistency. While our existing indexes can be converted with a pywb utility, reindexing would be preferable.

### pywb + OutbackCDX

* Pro
  * All pros from above, including increasing use by community for indexing.
  * Eliminates need to merge index levels as collections grow; new indexes would be POSTed to OutbackCDX as created.
  * Searching indexes would be faster (to an unknown degree).

* Con
  * OutbackCDX development led by small number of developers.
  * OutbackCDX is another Java application to support.

* Additional context
  * It is best practice to reindex WARCs when switching to a new playback systems for consistency. While our current indexes can be converted with a pywb utility, reindexing would be preferable.

### Upstream Openwayback

* Pro
  * Exploratory work occurred and can be basis of new work.
  * Relatively familiar application, although requires Java which is less widely used by team.
* Con
  * Playback is not up to date with contemporary websites.
  * OpenWayback is no longer under active development.
  * Many other institution moving away from Openwayback for replay.
  * Exploratory work did not lead to implementation.
  * Will still require customization to support WARC collections
  * Adding new content involves indexing and merging, which can be costly in terms of time and resource utilization.

## Decision Outcome <!-- required -->

To be discussed

### Positive Consequences <!-- optional -->

* [e.g., improvement of quality attribute satisfaction, follow-up decisions required, …]
* ...

### Negative Consequences <!-- optional -->

* [e.g., compromising quality attribute, follow-up decisions required, …]
* ...

## Unknowns

* Any needed changes to sul-embed to support display of crawl dates (uses TimeMapAPI)

## Links <!-- optional -->

* [Link type] [Link to ADR] <!-- example: Refined by [ADR-0005](0005-example.md) -->
* ... <!-- numbers of links can vary -->
