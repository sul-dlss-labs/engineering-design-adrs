---
layout: default
title: ADR-0001
nav_order: 3
permalink: records/0001/
---
# Use a data model for technical metadata

* Status: proposed
* Decider(s):
  * Justin Coyne
  * Justin Littman
* Date(s):
  * Proposed: 2019-05-17

## Context and Problem Statement

Currently we create technical metadata by running JHOVE on every binary.  For XML
binaries this is very slow and for an object with a lot of binaries (like a book)
this can block the robot pipeline for everyone.  JHOVE has been an ongoing maintenance
problem.  We store all JHOVE output which can be excessively verbose and has caused
operation problems with memory consumption.  We believe that only a small subset of the
JHOVE output will ever be useful to SDR consumers.  Note: SMPL content ships with
it's own metadata typically from MediaInfo rather than JHOVE.

Using a data model will give us greater flexibility in how we choose to persist
this data.  The data model will show which fields we believe to
be important and will allow us to discard that which we do not believe to be important.
Because the data is modeled it is more readily actionable and analyzable, which will
give value to the data that we preserve.

## Decision Drivers <!-- optional -->

This is particularly important because:

* Google books will clog the robots (because existing process is slow)
* We want to move off Fedora 3, so having data models allow us to swap persistence layers.
* Certain pathological cases (books with > 700 pages) cause existing robots to run out of memory.
* Samvera and Valkyrie communities have identified data models for their technical metadata
* JHOVE only supports a small number of file formats, which does not cover the heterogeneity of SDR.
* Having data models is prerequisite for developing APIs
* SDR evolution meetings emphasized the need to move to well defined data models

## Considered Options

* Get rid of technical metadata entirely.  This might conflict with requirements for being a trusted digital repository
* Pursue technical fixes to JHOVE and the technical metadata robot
* Replace JHOVE with other characterization tools. Crosswalk data to a data model.
  * Use the [Princeton data model](https://github.com/pulibrary/figgy/blob/master/app/resources/nested_resources/file_metadata.rb#L4-L35) as a starting point.
  * We anticipate use of ImageMagick, MediaInfo and Tika, although specific technology choice requires further analysis.

## TBD

* What does SMPL do with technical metadata datastream. Should this be cross-walked or added as an attached binary?
* How does this relate to the file identification as part of the contentMetadata? Should we persist the
  modeled data as a new type of datastream or as part of contentMetadatata?
* Hannah has forthcoming notes about technical metadata.

## Decision Outcome

To be discussed.
