# Standards

[Turing School](http://turing.io/)'s lib to work with standards.

[View the standards online](http://standards.turing.io/) (until that works, it's also [here](http://turingschool-standards.herokuapp.com/))

## Definition of a standard

Concepts that are known and can be demonstrated by a student who has mastery.

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
    * Generate a website from them
    * Integrate them into other apps
* Students
  * See whether they know all the things they should (a *standard* :D to measure themselves against)
  * Know where they are and where they're going (heavily requested by students during 1-on-1s)
  * Know what to review for assessments, etc

## Examples

For examples of how to use the libraray, see the
[acceptance spec](https://github.com/turingschool/standards/blob/master/spec/acceptance_spec.rb).


If you're going to use the binary,
you probably want to set `STANDARDS_FILEPATH` in your `bash_profile`,
otherwise you'll have to specify `-f path/to/standards.json` every time you use it.

## Considerations going forward:

* Nesting of tags so we can drill down
* Validating tags (have to explicitly add a tag?)
* Can they cross reference each other?
* Edit a specific standard (I prob want an id)
* Hierarchy of tags (ie render a static site, what goes at top?)
* Versioning (store deltas? what does CouchDB do? <-- omg, student assignment!)
* Abstract away from "standards.json" default filename by using env var or configuration file
* Should standards (the array of Standard objs) have a repository (currently, Structure si becoming that)
* Maybe configurable
* Dependencies? (e.g. this standard depends on that standard)
* Are tags sufficient, or does there need to actually be categories?
