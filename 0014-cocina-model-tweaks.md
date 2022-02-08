---
layout: default
title: Template
nav_order: 17
permalink: records/0014/
---
# Cocina: Potential Changes

* Status: draft in progress
* Decider(s):
  * infrastructure-team developers + Andrew (+ Arcadia?)
* Date(s):
  * drafted: 2022-02-08 thru 2022-03-01

## Context and Problem Statement

Our existing Cocina models have some confusing terminology and other points of confusion. We also know they will have to evolve over time as new types of information will need to be added to the SDR and prepared for preservation and access.

Clearer models and clearer terminology will reduce maintenance costs of both the model code and the code bases that use the cocina-models.  Improvements may also reduce onboarding costs of new hires, etc.

"There is no better time than now" to make changes to the cocina-models, as we have not yet done our production migration of our SDR object metadata from Fedora 3 xml to Cocina JSON as our native object store.

This ADR is about listing some desired changes to cocina-models and roughly estimating the steps and effort involved for the proposed changes.

## Decision Drivers

* cocina-models could benefit from some changes.
* there may never be a better time to make changes to cocina-models.
* no stored cocina data to remediate right now, only code bases and models in specs.
* we will have to change cocina-models over time.

We can choose whichever changes we deem worthy.  Easiest?  Most impactful?  Best Value/Cost ratio?

# Considered Options

This is a "salad bar" of things we might change in cocina-models. Let's prioritize and/or select which things to pursue.

Additional Functionality Desired:
- Add "restrictionOnAccess"
- Add a Flag for Refreshable Metadata
- Enable Multiple Project Tags
- Indicate when dro APO differs from the APO for the dro's collection

Terminology Changes:
- Vocab class Resources renamed FileSet
- "externalIdentifier" renamed "druid"
- Access inside of Access
- Structural inside of Structural
- Rename admin_policy "defaultAccess"

Vocab Class Structure Changes
- Should Cocina::Models::Vocab::FileSet be a subclass of Cocina::Models::Vocab?
- Is it possible to document the classes and methods?

Vocab Reduction
- Remove ETD specific resource/fileset types and use (labels?) to distinguish among these types of "file"
- FileSet types of "preview" and "thumb" - Are They Worth Keeping?

Software:
- Locking to avoid crashing updates of immutable cocina objects
- Ruby Code Uses snake_case while JSON uses camelCase
- Helper Code for Effectively Mutating Cocina Objects


## Functionality: Add "restrictionOnAccess"

https://github.com/sul-dlss/cocina-models/issues/267

Add a field to cocina for "restrictionOnAccess". This will store a user-provided access note to be entered as a human readable string, similar to the "useAndReproductionStatement" field used for Use and Reproduction statements.

### Value:
(Andrew)

### Cost:
- cocina-model change: update API
- other code changes: DSA; Argo? H2? ETD?  other?
- data remediation: ?


## Functionality: Add a Flag for Refreshable Metadata

(Andrew)

### Value:

### Cost:
- cocina-model change: ?
- other code changes: ?
- data remediation: none


## Functionality: Enable Multiple Project Tags

https://github.com/sul-dlss/dor-services-app/issues/3545 (Restore support for multiple project tags)

https://github.com/sul-dlss/dor-services-app/issues/2615 (Allow AdministrativeTags#project to return multiple entries)

https://github.com/sul-dlss/dor-services-app/issues/3004 (allow release workflow to run on items with multiple Project tags)

### Value:
- Multiple project tags are useful.
- We have been able to have multiple project tags in our data in the past.
- Currently, items that have multiple Project tags fail certain actions, such as the releaseWF.

### Cost:
"From Justin C - will be easier to solve when we persist Cocina in Cocina datastore. Fedora has no place to hold routing information because tags are not in Fedora.

Routing via rabbit requires a single key (currently a Project tag serves this purpose), but users want to make use of multiple Project tags."

- cocina-model change: ?
- other code changes: ?
- data remediation: ?


## Functionality: Indicate when dro APO differs from the APO for the dro's collection

An item isGovernedBy an APO and isMemberOf one or more collections, which are also governed by APOs.  It would be helpful to be able to indicate when the item APO differs from one or more of its collection APOs.

### Value:
(Andrew)

### Cost:
- cocina-model change: ?
- other code changes: ?
  - design needed for Argo;  anywhere else?
- data remediation: ?


## Terminology: Vocab class Resources renamed FileSet

Vocab::*Resources* but cocina-models calls it FileSet (see https://github.com/sul-dlss/cocina-models/blob/main/lib/cocina/models/file_set.rb and https://github.com/sul-dlss/cocina-models/blob/main/lib/cocina/models/vocab.rb#L95)

- "Resources" is overloaded term
- our code calls it FileSet nearly everywhere
- Note: collective noun so singular, not plural
- open to other suggestions as long as we're consistent everywhere

### Value:
- consistent language reduces cognitive load
- we call it FileSet everywhere else (and if we don't already, we should)

### Cost:
- cocina-models: change API (only?)
- other code changes: anywhere it's used (simple string substitution)
- data remediation: none


## Terminology: "externalIdentifier" renamed "druid"?

Is there a reason we don't call it what it is?

### Value:
- good naming reduces cognitive load

### Cost:
- cocina-models: simple change to openapi.yml
- other code changes: where used (simple string substitution?)
- data remediation: none


## Terminology: Access inside of Access

It's confusing. Could one become "access_rights" or "viewable" or ...

### Value:
- good naming reduces cognitive load

### cost:
- cocina-models: simple change to openapi.yml
- other code changes: where used (simple string substitution?)
- data remediation: none


## Terminology: Structural inside of Structural

It's confusing.

### Value:
- good naming reduces cognitive load

### Cost:
- cocina-models: simple change to openapi.yml
- other code changes: where used (simple string substitution?)
- data remediation: none


## Terminology: Rename admin_policy "defaultAccess"

It's not clear from the name that this is the default for the constituent objects.  

Since "governedBy" is the relationship, should we use the term "governed" here?

Or should we call it "dro_default_access"?  "governed_default_access"?

This is or is not coming through the collection record?

### Value:
- good naming reduces cognitive load

### Cost:
- cocina-models: simple change to openapi.yml
- other code changes: where used (simple string substitution?)
- data remediation: none


## Vocab Class Structure: Should Cocina::Models::Vocab::FileSet be a subclass of Cocina::Models::Vocab?

This feels "hinky."  Perhaps Vocab should have two subclasses:  "Object" and "FileSet" and the individual values/methods should be in one of those, rather than some at the top level and some in a subclass?

Not even knowing if this is correct is a red flag: a FileSet (with type http://cocina.sul.stanford.edu/models/resources/xxx) may contain files (http://cocina.sul.stanford.edu/models/file.jsonld) -- FileSet is the outer object.  In the Vocabulary, the FileSet types are a subclass of Vocab - see  https://github.com/sul-dlss/cocina-models/blob/main/lib/cocina/models/vocab.rb#L95)

It might make the duplicate values, such as document file, image, media, object, page less confusing to use ... if it always has to be in one namespace or the other and our code uses "FileSet" consistent with the model ...  (e.g. top level "file" (http://cocina.sul.stanford.edu/models/file.jsonld) and "file" within fileset (http://cocina.sul.stanford.edu/models/resources/file.jsonld) )

### Value
- the nesting confuses Naomi.  Does it confuse anyone else?

### Cost:
- cocina-models: fairly simple update?
- other code changes: anywhere values are used (simple string substitution)
- data remediation: none


## Vocab Class Structure: Document the classes and methods

Is this possible?

### Value:
- clearer notion of difference between "object type" and "fileset type".

### Cost:
- cocina-models: not sure how to do this -- add to generator?
- other code changes: none
- data remediation: none



## Vocab Reduction: Remove ETD specific FileSet types
Use (labels?) to distinguish among these types of "file" http://cocina.sul.stanford.edu/models/resources/xxx.jsonld
    * main_augmented - ETD
    * main_original - ETD
    * permissions - ETD
    * supplement - ETD

GitHub:

- https://github.com/sul-dlss/dor-services-app/issues/3298 (Remediate ETD structural cocina FileSet.type that use Cocina::Models::Vocab::Resources.main-original, .main-augmented, .supplement, .permission)
    * This will match the practice assumed when PR sul-dlss/hydra_etd#1167 was deployed in early Feb, 2022

- https://github.com/sul-dlss/dor-services-app/issues/3299 (Remediate ETD empty structural cocina FileSet.label values)

- https://github.com/sul-dlss/cocina-models/issues/302 (AFTER data remediation, remove ETD specific Vocab::Resource types )

### Value:  
We should (need to?) make ETD data consistent; it is not currently. Since we have to do some data remediaton regardless, let's select the data modeling that is most consistent with other modeling choices / most useful.

### Cost:
- cocina-model change:  simple - remove the types from the Vocabulary
- ETD code changes:  change the cocina structural metadata created by the app to use vocab "file" and ensure it has useful labels to distinguish among the 4 possible file types.  Look in code for any other used of these file types.
- other code changes:  ensure these vocab terms are not used anywhere.  If they are, modify code to seek this information in file label.
- data remediation:  there are roughly 10K ETDs. We would need to write a script or scripts to:
    - ensure conversion of ETD objects containing such files get written to cocina with appropriate "file" type and appropriate label.
    - ensure proper labels are assigned to each file in an ETD object

NOTE:  we already have inconsistent data.  There are at least 3 sets, and at least 2 ways that contentMetadata has been written and preserved:

1. Old ETDs before latest ETD work cycle - this could split into many sets as our ETD objects have been accessioned for over 10 years/
2. ETD work cycle decoupling direct access to Fedora - produced contentMetadata one way
3. cocina-izing the contentMetadata part in ETD app - produced contentMetadata one way


## Vocab Reduction: FileSet types of "preview" and "thumb" - Are They Worth Keeping?
  * http://cocina.sul.stanford.edu/models/resources/xxx.jsonld
    * thumb
    * preview

### Value:  
- are either of these used in their Fedora representation?
  - preview:  I don't think so;  sul-embed figures it out some other way?
  - thumb: didn't Aaron do some research into this?
- are they distinct enough to warrant keeping both of them?
- would we do just as well with a label value, like the suggestion for the removal of ETD specific types?

### Cost:
- if we're keeping both, maybe we could ... have a better description?  

- cocina-model change:  simple - remove the types from the Vocabulary
- other code changes:  ensure these vocab terms are not used anywhere.  If they are, modify code to seek this information in file label.

- data remediation:  We would need to write a script or scripts


## Software: Locking to avoid crashing updates of immutable cocina objects

https://github.com/sul-dlss/dor-services-app/issues/3568 ([SPIKE] Optimistic locking)

### Value:
clashing updates are hard to detect
clashing updates are hard to debug after the fact, and hard to fix after the fact

### Concerns:

Is optimistic locking good enough?

### Cost:
- cocina-model change: ?
- other code changes: ?
- data remediation: ?


### Software: Ruby Code Uses snake_case while JSON uses camelCase

https://github.com/sul-dlss/cocina-models/pull/299 (Mike's spike)

### Value:
It would feel less "hinky" to use snake_case in our ruby code.  

### Tradeoff:  
consistent snake_case in ruby code, but camelCase in JSON in specs, etc.

### Cost:
- cocina-model change:  take Mike's spike;  deprecate camelCase methods.
- other code changes:  switch direct consumers of cocina-models to use snake_case
- data remediation:  none -- the JSON would remain camel_case


## Software: Helper Code for Effectively Mutating Cocina Objects

https://github.com/sul-dlss/cocina-models/pull/303 (Mike's spike)

### Value:
Working with our cocina-models can be jarring because, unlike most of the rest of the code we write, dry-structs are immutable which can lead to surprising results when leaning on the usual assignment interactions

### Concern:
Don't want to give up any validation.

### Cost:
- cocina-model change: additions to cocina-models but no API change?
- other code changes: DSA; where else?
- data remediation: none


# Decision Outcomes

relative priority of the options

which of the above are we planning to do?
