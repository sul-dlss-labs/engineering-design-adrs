---
layout: default
title: Template
nav_order: 27
permalink: records/0024
---
# Port Cocina TitleBuilder to Access-maintained gem

* Status: drafted
* Decider(s):
  * Infra team
  * Access team
* Date(s):
  * Drafted: 2025-06-13

Related [ticket in cocina_display gem](https://github.com/sul-dlss/cocina_display/issues/1).

## Context and Problem Statement

The goal of this architectural change is to move the title-rendering logic in `cocina-models` into the `cocina_display` gem.

### Background

#### The `cocina-models` and `cocina_display` gems

Some work has been done to shift patron-facing applications in the Access team portfolio to use Cocina metadata rather than MODS XML. Notable examples include the [Earthworks indexer](https://github.com/sul-dlss/searchworks_traject_indexer/blob/main/lib/traject/config/geo_aardvark_config.rb), [Dataworks SDR mapper](https://github.com/sul-dlss/dataworks-etl/blob/main/app/services/dataworks_mappers/sdr.rb), and [PURL's schema.org mapper](https://github.com/sul-dlss/purl/blob/679132b2e61d64213fb2189aba943553bbb27959/lib/metadata/schema_dot_org.rb). Other applications remain heavily reliant on MODS XML, including Searchworks's indexer, Exhibits, and PURL.

Although `cocina-models` exists for parsing and validating Cocina, it makes some guarantees about the structure of the underlying metadata and fails validation for objects that do not conform to those expectations. Because Access applications use the "shelved" version of Cocina metadata available via PURL, which may be published very infrequently, it is often out of date and thus unparsable with respect to `cocina-models`. To avoid tightly coupling Access applications to `cocina-models` and to centralize logic related to rendering Cocina JSON into human-friendly strings, the [`cocina_display` gem](https://github.com/sul-dlss/cocina_display) was created.

#### The `TitleBuilder` class

Rendering human-friendly titles from Cocina metadata is a complex process. Objects can have several different types of titles, each with potentially multiple values. The titles may need to be rendered different depending on the context in which they are used, incorporating punctuation, dates, and other elements. The `TitleBuilder` class in `cocina-models` encapsulates this logic and provides several methods for rendering titles, and it is at present the only implementation of this logic.

As a result, several applications have already come to depend on `cocina-models` solely for the `TitleBuilder` class:
- `gis-robot-suite`
- `searchworks_traject_indexer`
- `purl_fetcher`

For `dataworks-etl`, the implementation is very basic expressly in order to _avoid_ a dependency on `cocina-models`, but would benefit from more sophistication. The number of Access apps that need to render titles from Cocina will continue to grow, so this list will likely expand.

### Proposed changes

The resulting changes would be:
- Move the `TitleBuilder` class and associated tests from `cocina-models` to `cocina_display`.
- Update infrastructure team applications using `TitleBuilder` to depend on `cocina_display`:
  - `dor-services-app`
  - `gis-robot-suite`
- Switch access team applications that depend on `cocina-models` for `TitleBuilder` to depend on `cocina_display`:
  - `searchworks_traject_indexer`
  - `purl_fetcher`

Possible additional changes:
- Refactor the `TitleBuilder` class to make it clear which codepaths are used in which situations.
- Update Dataworks' indexer to use `TitleBuilder` instead of its (less smart) title rendering step.

## Decision Drivers

* Desire to decrease usage of MODS XML
* Desire to have centralized title rendering logic

## Considered Options

1. This proposal
1. Continue to have more access apps depend on `cocina-models` exclusively for `TitleBuilder`
1. Move title-rendering logic to a secret third gem???

## Decision Outcome

TBD
