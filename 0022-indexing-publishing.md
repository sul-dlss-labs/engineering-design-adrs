---
layout: default
title: ADR-0022
nav_order: 25
permalink: records/0022
---

# Connecting indexing status to publish workflows

- Status: drafted
- Decider(s): <!-- required -->
  - Access Team
  - Infrastructure Team
  - Andrew (Repository Admin)
- Date(s): <!-- required -->
  - pending

Technical Story:

- <https://github.com/sul-dlss/argo/issues/3893>
- <https://github.com/sul-dlss/workflow-server-rails/issues/733>

## Context and Problem Statement <!-- required -->

When SDR content is published to PURL, purl-fetcher examines the item and sends indexing signals for each of the item's release target platforms (e.g. Searchworks, Earthworks). During the indexing process, a variety of factors (e.g. problematic metadata, connection failure) can result in metadata ultimately not being added to or removed from the target platform's search index as intended. This can create a state where the item shows as having been successfully published in Argo, but is not actually updated in the target platform. It is difficult for accessioneers to assess the scope of this problem and attempt to remediate it, especially for large collections that may have many problematic items in this state.

As of spring 2024, some work has been done to address this issue, but it is not yet fully resolved. The current approach is to dispatch events to the SDR events service during indexing that indicate whether the item was successfully indexed and to which target platform. This information is visible when expanding the event log in the Argo UI. However, this solution is incomplete: it does not provide a way to easily identify in bulk items that are failing to update, and it is still not connected to the status of the publish/release workflows in Argo.

## Decision Drivers <!-- optional -->

- Users expect that "released" means that an item was actually updated
- It should be possible to identify items that are not updating in the index
- Updating the status of items at index-time should not slow down indexing

## Considered Options <!-- required -->

1. Build on the current solution; add a new service that uses the events published to the SDR event service to connect back to the status of the release workflow
1. Move the indexing status tracking into purl-fetcher's database and use the ReleaseTag model to track indexing state, connecting this to the release workflow

## Decision Outcome <!-- required -->

Chosen option: "[option 1]", because [justification. e.g., only option, which meets k.o. criterion decision driver | which resolves force force | … | comes out best (see below)].

### Positive Consequences <!-- optional -->

- Accessioneers will be able to use Argo faceting to easily generate result sets of items to target for remediation of bad metadata
- More items will make it to their target platform, enabling the release en masse of large collections that are currently unavailable to patrons

### Negative Consequences <!-- optional -->

- The release/publish workflows will take longer to complete, as they will need to wait for a callback indicating indexing was successful

## Pros and Cons of the Options <!-- optional -->

### [option 1]

- Good, because it builds on existing work
- Bad, because it makes the SDR event service much more load-bearing than it currently is
- Bad, because it leaves open the question of where the logic to call back to the SDR workflows service should live

### [option 2]

- Good, because it potentially allows purl-fetcher to be smarter about dispatching indexing events, instead of having the indexer decide whether or not to index an item
- Good, because it allows purl-fetcher's existing HTTP APIs to become a public source of truth about what items are available via which platform
- Good, because it uses a pre-existing database to track indexing state, rather than an ephemeral service or feature added to a different codebase
- Good, because there is already a framework in place of writing and running jobs that depend on message queues in purl-fetcher
