---
layout: default
title: ADR-0013
nav_order: 16
permalink: records/0013/
---
# Securing automated access to github repositories

* Status: drafted
* Decider(s): <!-- required -->
  * Julian Morley
  * ...?
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
  * drafted: 2021-09-16

## Context and Problem Statement <!-- required -->

It is often a necessity within a project to interact with one or more github repositories directly. Depending on the needs of any particlarly access scenario security should be the utmost consern to avoid exposing any or all repositories within the DLSS organizations to malicious access.

The purpose of this ADR is to propose scenario based solutions that minimize the surface area of any potential security risk.

## Decision Drivers

* Does your project need to be able to write (commit) to a repository
  * Will a pull request (PR) but an appropriate mechanism
  * Is full automation (no human interaction) required
* Does your project only need read access
* Does your project need API access
* Single or multiple repositories

## Unknowns


## Considered Options

* User access token
* Deployment keys

## Decision Outcome


## Pros and Cons of the Options


## Links

