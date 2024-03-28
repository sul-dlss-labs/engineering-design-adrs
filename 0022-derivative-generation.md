---
layout: default
title: ADR-0022
nav_order: 25
permalink: records/0022
---
# Text Derivative File Generation in SDR (OCR/Transcription)

* Status: [proposed]
* Decider(s): <!-- required -->
  * Peter Mangiafico
  * Ed Summers
  * Justin Coyne
  * Justin Littman
  * Alan Lundgard
  * Niqui O'Neill
  * Mike Giarlo
  * Andrew Berger
  * Dinah Handel
* Date(s):
  * Proposed: 2024-03-27
  * ...

## Context and Problem Statement <!-- required -->

Automated OCR (from images/PDFs) and transcription (from video/audio) are desired for a subset of content deposited in SDR in order to improve accessibility and discoverability.  Current processes for generating these derivative files are manual and require operator intervention.  This proposal is to automate the generation of these derivative files via various mechanisms (either on-demand or by other requests made by operators).

This propsal addresses so called "non-image" derivatives (though they may be referred to simply as "derivatives" throughout this ADR).  For the purpose of this ADR, "non-image" derivatives are defined as derivative files which add value to the delivery of content, but are not stricly required for delivery itself.  For example, JP2s must be created for the image viewer to work, and so these derivatives must be generated during accessioning prior to shelving.  OCR and transcription derivative files are used to make content accessible and searchable, but the viewers themselves will still work. Note that while the viewer will work, it may not meet accessibly requirements until the derivatives become available.

This distinction is useful because some derivatives must be generated during accessioning, while others may be genereated after accessioning.

For additional context and planning, see Links section below.

## Decision Drivers <!-- optional -->

* Derivatives should be able to be created by an automated process.
* Users should be able to supply pre-created derivatives; the automated generation should be skipped when a pre-created derivative is present.
* Users should be able to re-accession items by providing only changed files.
* Users should be able to review generated derivatives before proceeding.
* Users should be able to replace / edit / update generated derivatives as part of the review process.
* Users should be able to regenerate existing derivatives.
* Generation of non-image derivatives should not delay accessioning.
* Derivative generation failure should be handled.
* Derivatives should be versioned and there should be a single system from which all files can be retrieved.

## Considered Options <!-- required -->

Three original options were considered, as summarized in [this document](https://docs.google.com/document/d/10MzjOjwmuijHD5rgO5QxxuLKFwv94Lq29vDy0Y_xDUg)

* Option 1 had derivatives generated prior to accessioning (similar to the current manual process)
* Option 2 had derivatives generated during accessioning (similar to JP2 derivative creation)
* Option 3 had derivatives generated after accessioning

After considering the pros and cons of each approach, option 3 was selected, and is described here.  The pros and cons of the vairous options are summarized in the above document, and the reason option 3 was selected was the requirement that generation of these derivatives should not delay accessioning, which would not be possible with options 1 and 2.

The proposed solution uses a combination of a messaging and workflow driven solutions as described in more detail in [this document](https://docs.google.com/document/d/1JLJwio7xVDDh75KY3dZJIFPDep-92hoQJ5p9EgFKabY) and summarized below.

## Decision Outcome <!-- required -->

After [several discussions](https://docs.google.com/document/d/1H1zy-yCDErMTf2IWK1PdN9r_6IjqRqiREc0yYnaiYvo) as part of an Architecture Forum, we propose to use a combination of messaging and new workflow(s) to produce non-image derivatives, a form of Option 3 as decribed in documents listed above.

The basic flow and architecture is:

* The user initiates accessioning via current systems, e.g. pre-assembly, Goobi, H2.  New user interface elements will need to be added to indicate if OCR or transcription is needed for the material or batch of materials.  This will set new fields in cocina and/or add new workflow variables.
* Accessioning will proceed as normal.
* When accessioning is complete, an `end-accession.completed` message is currently sent.  A new service will look for these messages and [use logic](https://docs.google.com/document/d/1JLJwio7xVDDh75KY3dZJIFPDep-92hoQJ5p9EgFKabY/edit#heading=h.n930qglopzgc) to create the new OCR/captioning workflow for that object if needed.  Logic will the content type, the new fields set and the existence of derivatives to determine if the new OCR/captioning workflow is needed.
* The new workflow will have consist of several steps, which will inclue any required versioning, OCR and transcription, and possible pause of review.  If review is required, it will be indicated by the operator ahead of time via a UI element, and this will be passed through to the workflow.
* The OCR will be peformed by ABBYY, and the transcription will be peformed by Whipser.  These services are likely to be run separately from the server(s) monitoring for `end-accession.completed` and running the new robots, and will triggered by API calls from the robots.
* As part of the workflow, the object will be opened, and then closed when OCR and transcrption is complete to ensure files are preserved.
* Closing the object will trigger assemblyWF, which will ensure the files are properly shelved and preserved.
* Changes being made to versioning in a separate workcycle will ensure that no other user or process can close the object while this new workflow is in process, preventing two processes from altering the object at the same time.

Implementation Details:

* One new workflow would be created

** The workflow will be called something like textGenerationWorkflow (TBD)
** The steps in these workflows would be: openVersion, createOCR, createTranscription, review, closeVersion
** The workflow definition will be in `workflow-server-rails`, alongside other workflows
** The robots to act on steps in this workflow will be in `common-accessioning`

* A new service to monitor for the `end-accession.completed` message will be created, which will create the new worfklow if needed.  The actual logic to determine if the workflow is needed is [summarized here](https://docs.google.com/document/d/1JLJwio7xVDDh75KY3dZJIFPDep-92hoQJ5p9EgFKabY/edit#heading=h.n930qglopzgc), and will be based on a combination of content types and inputs coming from the accesioneer (via cocina model changes and/or workflow variables set via pre-assembly and/or Argo).
* The actual implementation of performing OCR (e.g. ABBBYY) and transcription (e.g. via Whisper) may occur on a separate service, such as occurs with the technical-metadata service.  In this case, the robot step will make an API call out to the new service(s)
* Read-only preservation mounts will be required on whatever VMs are performing OCR and transcription so that these services have access to files.
* Cocina model changes will be needed to store information about the sdr generated derivative files.  This is required so that if a user later edits one of these derivatives, we can record this to prevent automatically overwriting the edited derivatives.
* Argo and pre-assembly will be changed to add user interface elements needed to pass messages to the new workflow.  The variables needed will be defined later, but will include:

** should OCR and transcription be peformed?
** is review required?
** [more]

### TBD

Some issues are known to be outstanding and will be decided later:

* Which exact variables need to be passed from the accessioneer through the system.
* Where these variables will be stored (e.g. in cocina or in the workflow model or a combination of the two).
* How reviews will be performed and which system will be used to do this.
* How edits will be performed and which system will be used to do this.
* How will the code be distributed between existing codebases and VMs and new codebases and VMs.
* [more]

## Links <!-- optional -->

* [Integrating Text Extraction into SDR Accessioning - Architecture Forum Overview](https://docs.google.com/document/d/1vzDFaD9BKmyDaJdXcVIp82Vd2BJ9hnuUH1KhXilEOWk)
* [Deriviative Generation Proposal](https://docs.google.com/document/d/1JLJwio7xVDDh75KY3dZJIFPDep-92hoQJ5p9EgFKabY)
* [Meeting Running Notes](https://docs.google.com/document/d/1H1zy-yCDErMTf2IWK1PdN9r_6IjqRqiREc0yYnaiYvo)
* [High level overview of options by Andrew](https://docs.google.com/document/d/10MzjOjwmuijHD5rgO5QxxuLKFwv94Lq29vDy0Y_xDUg)
