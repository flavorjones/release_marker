# release\_marker

Integrate your deploys with Pivotal Tracker: release markers, changelogs and unicorns!

TODO: links


## Description

A gem to help you:

* track your deploys to production with release markers in Pivotal Tracker
* create changelogs based on your team's Pivotal Tracker stories

For more information on Pivotal Tracker:

* http://pivotaltracker.com/


## Features

* Creates and correctly-positions Pivotal Tracker release markers to
  represent your production deploys.
* Generates a "changelog" documenting your team's completed stories
  since your last production deploy.
* Able to pull stories from, and create release markers in, multiple
  Pivotal Tracker projects (for you crazy/unlucky peeps who don't have
  a one-to-one relationship between repositories and deployable
  projects).


### A Note on Extensibility

ReleaseMarker is built with extensibility in mind. If you use a
project tracking tool other than Pivotal Tracker, please consider
adding support for it!


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
    
If this YAML file is named "release_marker.yml" and is in either your
project root or "./config", then ReleaseMarker will find it
automatically.

Otherwise, you can pass the filename to `ReleaseMarker.new`

    ReleaseMarker.new "path/to/config_file.yml"

or you can pass the configuration hash itself:

    ReleaseMarker.new({
        "pivotal_tracker" => [
          "Frontend Web Site" => {
            "project_id" => 12345,
            "api_token" => "abcd1234abcd1234abcd1234abcd1234"
          }
        ]
      })


#### Configuring Pivotal Tracker Projects

Required configuration parameters for a Pivotal Tracker project:

* "project_id": the project id. You can get this from your URL when viewing the project.
* "api_token": a valid api token. You can get this from your "Profile" page when logged in.

Optional configuration parameters for a Pivotal Tracker project:

* "only_label": if not all stories in Tracker are relevant to a
  release, then only include those stories with this label.
* "include_chores": a boolean indicating whether to include chores in your changelogs.


### With Rake

(Assuming you've named and locate your YAML file following conventions outlined above ...)

In your Rakefile:

    require 'release_marker/rake'

Generate a changelog of accepted stories since your last deploy:

    rake release_marker:changelog

Create a release marker in Pivotal Tracker, and generate a changelog:

    rake release_marker:release

If you want to name the release marker with the version of your
software that was deployed:

    rake release_marker:release[<version-id>]

where `<version-id>` is some string that uniquely identities the
version of the software. You may want to use your RCS's commit
identifier here.


### With Your Deployment Script

In your deployment script:

    require 'release_marker'

    # create a ReleaseMarker
    rm = ReleaseMarker.new

    # generate a changelog of accepted stories since your last deploy
    changelog = rm.changelog

    # create a release marker in Pivotal Tracker
    rm.release

    # create a versioned release marker in Pivotal Tracker
    rm.release "<version-id>"

where `<version-id>` is some string that uniquely identities the
version of the software. You may want to use your RCS's commit
identifier here.
