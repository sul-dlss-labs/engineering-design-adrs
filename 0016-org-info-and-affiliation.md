---
layout: default
title: ADR-0016
nav_order: 16
permalink: records/0016/
---
# Pull Stanford Organization Hiearchy and Research Affiliations for Reporting

* Status: drafted
* Decider(s): <!-- required -->
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
  * drafted: 2022-08-08

## Context and Problem Statement <!-- required -->

The sul-pub system and database currently contains researcher information pulled from the Stanford Profiles API and MaIS ORCID API.  The information we store in our database includes name, sunet, ORCID, employee ID, and status (e.g. active or not).

We use this information to harvest publications from various external sources (e.g. Web of Science, Pubmed, ORCID) that is returned via an API to the Stanford Profiles system for the purpose of building profiles pages for researchers.

This publication data is also useful for research intelligence reporting, such as reporting on the publications for specific departments or schools over a period of time, or other related analytics as requested by campus stakeholders.

However, we currently do not have any way of identifying researcher affiliation with Stanford organizational units, as our database does not include this information.  For example, if a stakeholder wants to know about publications for a department, we first need to figure out what researchers (e.g. sunets) belong to this department.

Organization info is available via the Profiles API and we have used in the past when building the first version of RIALTO.  It would be useful to have the organizational hierarchy, along with the connection between researcher and organizational unit, stored in our database to faciliate research intelligence queries.

## Decision Drivers

* Better support research intelligence
* Consider a new database/system vs repuporse an existing one (sul-pub)

## Considered Options

The current expirment at <https://github.com/sul-dlss/sul_pub/pull/1537> uses deprecated rialto-etl code at <https://github.com/sul-dlss-deprecated/rialto-etl> to pull organizational data and research affiliations and add them to new tables in the existing sul-pub database.

The experiment was run locally on my laptop, but using production organiation data pulled from the Profiles API using the existing rialto-etl code which already did this.

The process is:

* create two new tables in the sul-pub database, one to store the organizational hierarchy, and one to store connections between researchers (which we already have) and organizational unit
* run the rialto-etl code to pull all organizations from the Profiles API into a json file
* run a new rake task in the sul-pub code to load this organization data into the new sul-pub database table
* run the rialto-etl code pull all researchers and their organization affiliations into a json file
* run a new rake task in the sul-pub code to load these links between researchers and organizations into the new sul-pub database table

When complete, the two new tables now allow you to run queries such as:

* given a specific unit (e.g. a school, or institute, or department), return the researchers (e.g. sunets) of all affiliated researchers, taking into account organizational hiearchies
* given a specific unit (e.g. a school, or institute, or department), return the organization in the hiearchy (e.g. for a school, return all departments, or for a department, tell me which school it is in)

These types of queries are very useful to running research intelligence reports that are centered around organizational units instead of specific researchers.

So options for the future would be:

### Use the sul-pub database

This is what was done in this experiment.  It requires adding tables and code to the existing system.  To continue this approach, we would accept that we would be adding new data and code that is unrelated to the current production usage of sul-pub.  We would also want to remove the rialo-etl depedency by moving the code that pulls organization data into sul-pub itself and writing some additional code to automate the process of pulling and updating the data.  Given we already have connections to the Profiles API in sul-pub, this shouldn't be that much work.

We'd also likely want to write new API wrappers around the queries to facilitate it's usage without having to work directly on the server.

This approach is probably the most expedient, but carries the downside of adding additional complexity to the codebase, as well as requiring us to use a production system for somewhat unrelated reporting purposes.

### Spin up new system and database

This would require spinning up a new codebase, new servers and database, and pulling data into a new system, designed soley for this type of reproting.  Besides having to build a new Profiles API client, we'd also need to populate the new system will all researcher data (names, ORCIDs, etc.) so we'd be able to query user info.

This approach is the least risky, since we don't touch an existing production codebase, but would take more time, as we would be spinning up a new system.  As with the sul-pub solution, we'd also likely want to write new API wrappers around the queries to facilitate it's usage without having to work directly on the server.  We would also still need to port some code over from rialto-etl.

## Decision Outcome

NOT YET.

## Pros and Cons of the Options

### Use SUL-Pub

* Pro
  * System already exists and has a lot of researcher data in it
  * We currently use it to export publication data for research analytics reports, so this would just extend for organization data
* Con
  * Adds code/data unrelated to current functions of production system.

### New system

* Pro
  * No risk to production system
  * No legacy code to worry about
* Con
  * Need to get new Profiles API credentials
  * Code duplication (e.g. Profiles API client will be very similar to existing one in sul-pub code)
  * Need to spin up and maintain new servers and databases

## Links

* Draft PR with experiment: <https://github.com/sul-dlss/sul_pub/pull/1537>
