Rgulp - Reusable Gulp
=====================

RGulp allows you to keep your gulp build process as a standalone repo that you can reuse in multiple apps.

**This is super über new stuff, but we are starting to use it in Vlipco today, so keep tuned because we'll be rolling updates on a regular basis until this notice is removed**

## Motivation

The name comes from reusable/remote gulp. We understand why something like gulp makes sense for javascripters and it's very clear the benefit of Gulp over Grunt. However, Gulp doesn't entirely reduce configuration to a very small amount of time. To build our initial Gulpfile in Vlipco we spent about a week tuning details and even ended up having a list of potential improvements in our gulpfile. We decided that there should be a way to break away from configuring stuff for every project and live the peace of convention over configuration that we are used to have in other tools, like Rails.

Rgulp makes you think about your build process a reusable entity. You have all the freedom that Gulp provides and you then use the same build patterns for several apps instead of copying the same gulpfile and related files to each repo.

You then include a small RGfile.[js/coffee] in each project to indicate rgulp where to get your gulp repo from. You can then use the build process of the repo through `rgulp` cli tool in the same way that you'd use regular `gulp`.

## Why RGulp?

- you write once your build process and establish is as a reusable convention.
- you can make incremental improvements (e.g. caching in builds) and distribute changes to all apps in an easy way.
- you don't worry about cloning repo, syncing, calling install scripts, etc.
- you can now share fancy useful gulp repo to third parties.

There may be some other benefits, but these are already some good ones ;)

## pending

- customize when to sync instead of on every task
- simplify sync to be quicker? hash based?
- use kexec for prepare script and preserver output colors