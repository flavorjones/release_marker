require "release_marker/project_manager"

class ReleaseMarker::PivotalTrackerProject
  ReleaseMarker::ProjectManager.register_project "pivotal_tracker", self

  def initialize name, attributes
    @name = name
    @attributes = attributes
  end

  def changelog
    changelog_stories.collect do |story|
      describe story
    end
  end

  # -------------------- below this line is not part of the public API --------------------

  def changelog_stories
    recently_delivered_stories.select do |story|
      story.bug? || story.feature? || (@attributes["include_chores"] && story.chore?)
    end
  end

  def recently_delivered_stories
    recent_stories.range(oldest_delivered_story, newest_delivered_story)
  end

  def recent_stories
    # @recent_stories ||= project.iterations[-2..0].stories
    raise NotImplementedError
  end

  def oldest_delivered_story
    # @most_recent_release_marker ||= recent_stories.reverse.find do |story|
    #   story.release_marker? && story.name =~ /^#{release_name} /
    # end
    raise NotImplementedError
  end

  def newest_delivered_story
    raise NotImplementedError
  end

  def describe story
    raise NotImplementedError
  end
end
