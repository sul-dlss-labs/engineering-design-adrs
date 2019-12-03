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

## Context and Problem Statement

PROBLEM:

Currently we have 5 production prescat VMs:

1 - rails app
2 - resque worker box
3 - resque worker box
4 - resque worker box
5 - redis app

and Moabs on 20 storage roots (storing the Moabs) which are mounted (read only) via NFS.

The storage roots are on net-app hardware, which is going unsupported in Fall 2020.  

We will be replacing the storage roots with supermicro hardware, which has much more disk space than our current storage roots.

PROBLEM:

Accessioning demand is ever increasing, and it is outpacing our ability to provision storage in a cost effective, scalable way.

When we accession the scanned books from Google, we will definitely need a lot more storage.

PROBLEM:

We are increasingly I/O bound for computing checksums and creating zip files, both key components in our preservation strategy.

PROBLEM:

We need to prepare for the future while minimizing disruption to current services.


## Proposed Solution

There are 8 new machines;  they will be set up in pairs - so four distinct pairs;  each pair is a live backup for the other three pairs.

Each pair will represent:

- ALL storage for Moabs
- the prescat Rails app
  - will the database be the same as it is now - a shared postgres db (the same one currently in prod)
- the redis instance ?
- all the resque workers for the redis instance ?


Will each pair have a *running* redis instance and workers, or will that only be true for the "live box"?


### Questions

- is the second machine of the pair

       A. an additional storage root only  
                 *or*  
       B.  a replica of the first machine
            - running the app, redis, workers, but having a distinct storage root avail to BOTH machines (i.e. both machines in the pair access the 2 logical storage roots)


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

- What is needed to be confident the app works as expected on new hardware (with local storage roots)

- already one central database - can it work with it smoothly (read, write ...)
- how will new hardware address storage across 2 physical boxes
- can it work with the correct redis instance


- would the workers be balanced across the PAIR of new machines, or what?


### The Redis instance, queues, and workers

- How do we make sure we are only replicating each file ONE time to each cloud endpoint




### Problem:

We can't currently hot-swap resque workers on a deploy.
- b/c of the assumption per prescat that all workers are local
  - resque-pool hot-swap assumes one pool only, so will kill any workers on the box.

If we wanted to improve on this during this migration, all of the above neither improves nor degrades the situation.


#### Possible Solutions?

- push solution upstream to kill the assumption?
- use sidekiq instead of resque
  - need to be sure no multi-threading issues
