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
    * Add and Standard
    * Change standards
    * Cross referencing
* Students
  * Can see standards being taught for a specific lesson

## Structure

For Monday:

```json
{ "standards": [
    { "id":       1,
      "standard": "SW know that find is a method used on collections.",
      "tags":     ["ruby", "enumerable"],
    },
    { "id":       2,
      "standard": "SW know that map is a method used on collections.",
      "tags":     ["ruby", "enumerable"],
    },
  ],
}

```

Considerations going forward:

* Cross referencing (might need an id... might not need to cross-reference)
* Edit a specific standard (I prob want an id)
* Hierarchy of tags (ie render a static site, what goes at top?)


## To use this on Monday, we need:

* Structure described above
* Standards for the lessons being taught next week
* Basic presentation (ie render a static site)

-----

Potential use cases for the future:
  maybe configurable
  validates input (e.g. names don't collide)
  probably an intermediate way to show it (I don't need to save it to see it)
  some way to modify
  maybe versioning or maybe awareness of git?

-----

Uhm, apparently teachers teach to something
called a "standard". Seemed like a good idea
to at least identify what topics we'd like to
hit. Both for us to make sure we're teaching
things that are relevant, and for students
to have a better understanding of what they
should know and where they're at (something
that has come up multiple times in 1on1s)

This might eventually become such a standard.

For now, it's the very early stages of a brain dump
of things that people should know.

It's just organized by indentation. Anything
indented is scoped by the line it is indented
under.

Feel free to change at will. Don't worry too much
about formatting, we'll deal with all that after
we have information worth doing it with.

After the brain dump seems to be fairly thorough
we should probably organize it. Possibly into
dependencies (this topic depends on that topic)
or possibly into sections that could map to our
courses. Probably dependencies is best, because
then it's independent of our current schedule
and it can be easily turned into a progression
for anyone interested, plus tells them where they
can go next.

I also have no formal teaching background, so IDK
if its better to learn the dependent info first,
and then the info that is now learnable (seems like
it would ease the difficulty of learning any given
piece) or if it is better to get a touch of the dependent
info first (so that it is understood why the depended info
is valuable and what it's going to be used for -- giving
it a context and purpose) ...or maybe something else.
I think the dependency tree can handle any of these.

But! Who knows what will happen!
