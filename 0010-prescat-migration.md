---
layout: default
title: ADR-0010
nav_order: 3
permalink: records/0010/
---
# Migrate Preservation Catalog to new storage brick VMs

* Status: proposed
* Decider(s):
  * Naomi Dushay
  * John Martin
  * Tony Zanella
* Date(s):
  * Proposed: 2019-12-03

### Context and Problem Statement

PROBLEM:

Currently we have 5 production prescat VMs:

1 - rails app
2 - resque worker box
3 - resque worker box
4 - resque worker box
5 - redis app

and Moabs on 2x storage roots (storing the Moabs) which are mounted (read only) via NFS.

The storage roots are on net-app hardware, which is going unsupported in Fall 2020.  

We will be replacing the storage roots with supermicro hardware, which has much more disk space than our current storage roots.

#### PROBLEMS:

- Accessioning demand is ever increasing, and it is outpacing our ability to provision storage in a cost effective, scalable way.
  - When we accession the scanned books from Google, we will definitely need a lot more storage.
- We are increasingly I/O bound for computing checksums and creating zip files, both key components in our preservation strategy.
- We need to prepare for the future while minimizing disruption to current services.

## Unblock Google Books Accessioning  

PROBLEM:  Google Books will need a lot of space

- QUESTION:  Are google books going to be dark (i.e. preservation only)?
  - this implies stacks space is not a similar problem (see Google Books analysis doc https://docs.google.com/document/d/1ILEzn9pdjCGdRu37LvNGHaWpLufZg-f-e2nTWgTl5fg)

### Minimum up front cost solution

We are not endorsing this approach but it is the simplest way to get a lot more storage quickly.

- use new storage bricks as new storage roots
  - nfs mount them

## Proposed Solution per Julian

There are 8 new machines;  they will be set up in pairs - so four distinct pairs;  each pair will have a primary node that will replicate content to a secondary node via an OS-level process.

Each pair will provide:

- Storage for some of SDR's Moab objects
- the prescat Rails app
  - will the database be the same as it is now - a shared postgres db (the same one currently in prod)
- a redis instance
- all the resque workers for the redis instance

Each pair will have a single *running* redis instance and workers. The secondary node of each pair will not have any running services, but in the event of a primary node failure it should be possible to promote a secondary node to the primary role.

(At some point, this document will use the term "new endpoint" (or some other term) to refer to a pair as a single entity in the doc)

### Questions

- Can we get a verification that a single pair will have 1/4 (or some other fraction) of all the stored Moabs?

- Should we run 1 instance of the PostgresDB that provides service for all pairs? Or should each pair be an island, running its own database?
  - If we decide to run a single database shared by all pairs we want to run it as a Postgres cluster, with DB nodes on each primary node. (or if impossible, a primary/secondary approach). This would remove the single PostgresDB as a point of failure.
  - how transparent can we make the "clustered" notion to the app?  Ideally, the app code always thinks it's talking to a normal rails db.

## Proposed Steps

x.  Mount new hardware as nfs storage root

- start exercising moabs living on multiple storage roots
  - gets content on new machines
  - allows us to test new machines in prod environment
- we don't get anticipated IO benefits b/c whole stack not local, but can get migration to new storage and some production environment testing of storage.


x.  Add new server as next storage root

Idea is for new Moabs to go to new storage root, removing need to migrate them later.


x.  Ensure new server works at least as well as existing storage

- can we write to it
- compute checksums (i.e. audits)
- zip files
- performance ok?
- reconstitute as needed
- accession new versions ...
- ...


x.  Accommodate Moabs living on Multiple roots

We will want to have Moabs in old and new locations so we can make changes to existing Moabs while we are in the process of migrating to new storage.

- prescat changes needed?
- moab-versioning changes needed?
-
- could be explored independent of new hardware

x.y.  Use new hardware for Moab additional copies

This approach would allow us to not view new hardware as "in production" until we are confident in it.


x. After confidence is gained in new hardware (via testing)

- duplicate one or more old storage roots on new hardware
- turn off old storage roots.


z. We need a clear migration plan

- all the way to when we turn off the last of the old storage roots, and the last of the old VMs running prescat.


### The prescat ruby app

#### QUESTIONS:

- What is needed to be confident the app works as expected on new hardware (with local storage roots)

- how will new hardware address storage across 2 physical boxes
  - A: ? our code will work with storage as a single logical node
- can it work with the correct redis instance
  - will we have multiple redis instances in this brave new world?
- the database:
  - can we stick with a single database for all four new prescat endpoints? (CRUD ops)
    - if not, how will databases be coordinated?  how will we know where database entries are for a given druid?  
    - concerns with transactions - what if we're moving stuff around?
      - JMo: we're not doing this now
      - JMa: concerned about transactional integrity for adds and moves and such
      -

### The Redis instance, queues, and workers

#### QUESTIONS:

- How do we make sure we are only replicating each file ONE time to each cloud endpoint


### Hot-Swap Problem (Not Necessarily Related):

We can't currently hot-swap resque workers on a deploy.
- b/c of the assumption per prescat that all workers are local
  - resque-pool hot-swap assumes one pool only, so will kill any workers on the box.

If we wanted to improve on this during this migration, all of the above neither improves nor degrades the situation.

#### Possible Solutions?

- push solution upstream to kill the assumption?
- use sidekiq instead of resque
  - need to be sure no multi-threading issues
