# release\_marker

Integrate your deploys with Pivotal Tracker: release markers, changelogs and unicorns!

TODO: links

## Description

A gem to help you:

* track production deploys with release markers in Pivotal Tracker
* assemble changelogs based on your team's Pivotal Tracker stories

For more information on Pivotal Tracker:

* TODO: link to Pivotal Tracker


## Features

* Creates and positions Pivotal Tracker release markers to demarcate
  your production deploys.
* Generates a "changelog" documenting the completed stories since your
  last production deploy.
* Able to pull stories from, and create release markers in, multiple
  Pivotal Tracker projects, for you crazy/unlucky peeps who don't have
  a one-to-one relationship between repositories and deployable
  projects.

## Synopsis

### Configuration

Create a YAML config file:

    pivotal_tracker:
      Frontend Web Site:  # all stories in this tracker project are relevant
        project_id: 12345
        api_token: "abcd1234abcd1234abcd1234abcd1234"
      
      Restful Services:  # only some of the stories in this tracker project are relevant
        project_id: 23456
        api_token: "dcba2345dcba2345dcba2345dcba2345"
        only_label: "rails"  # which stories are relevant? those labeled "rails"
        release_name: "frontend"  # (optional) name used in the release marker
    
### With Rake

In your Rakefile (optionally):

    require 'release_marker/rake'

which creates the following rake tasks:

* release_marker:changelog # generate a changelog of accepted stories since your last deploy
* release_marker:release # create a release marker in Pivotal Tracker, and generate a changelog

### With Your Deployment Script

In your deployment script:

    require 'release_marker'

Then:

    # generate a changelog of accepted stories since your last deploy
    changelog = ReleaseMarker.changelog

    # create a release marker in Pivotal Tracker
    ReleaseMarker.release
