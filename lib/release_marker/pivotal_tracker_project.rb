require "release_marker/project_manager"

class ReleaseMarker::PivotalTrackerProject
  ReleaseMarker::ProjectManager.register_project "pivotal_tracker", self

  def initialize name, attributes
    @name = name
    @attributes = attributes
  end

  def changelog
    recent_stories.range(most_recent_release_marker, most_recent_delivered_story).select do |story|
      story.bug? || story.feature?
    end.collect do |story|
      describe story
    end
  end

  # -------------------- below this line is not part of the public API --------------------

  def recent_stories
    # @recent_stories ||= project.iterations[-2..0].stories
    raise NotImplementedError
  end

  def most_recent_release_marker
    # @most_recent_release_marker ||= recent_stories.reverse.find do |story|
    #   story.release_marker? && story.name =~ /^#{release_name} /
    # end
    raise NotImplementedError
  end

  def most_recent_delivered_story
    raise NotImplementedError
  end

  def describe story
    raise NotImplementedError
  end
end
