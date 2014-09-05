## Definition of a standard

Concepts that are known and can be demonstrated by a student who has mastery.

[View existing standards](http://standards.turing.io/).

## Users / Use Cases (who gives a shit and why)

* Instructors
  * Why we care
    * Tailor lesson towards specific outcomes
    * Remove lessons that don't progress us towards the standards
    * Ensure curriculum covers these concepts
    * Reflect on how well students are understanding
  * How we use it
    * Add a Standard
    * Change standards
    * Delete standards
    * Probably generate a static website from them
* Students
  * Can see standards being taught for a specific lesson
  * Can see whether they know all the things they should (a *standard* :D to measure themselves against)
  * Can know what to review for assessments, etc

## TODO before Monday, we need:

* Code
  * Pull file from ENV
  * Flag to override file
* Write standards for lessons for next week

## Considerations going forward:

* Cross referencing (might need an id... might not need to cross-reference)
* Edit a specific standard (I prob want an id)
* Hierarchy of tags (ie render a static site, what goes at top?)
* Versioning (store deltas? what does CouchDB do? <-- omg, student assignment!)
* Abstract away from "standards.json" default filename by using env var or configuration file
* Should standards (the array of Standard objs) have a repository (currently, Structure si becoming that)
* Maybe configurable
* Dependencies? (e.g. this standard depends on that standard)
* Are tags sufficient, or does there need to actually be categories?
