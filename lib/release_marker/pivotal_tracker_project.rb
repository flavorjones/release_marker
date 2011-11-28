require "release_marker/project_manager"

class ReleaseMarker::PivotalTrackerProject
  ReleaseMarker::ProjectManager.register_project "pivotal_tracker", self

  attr_reader :name, :attributes

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
    stories = recently_delivered_stories.select do |story|
      story.bug? || story.feature? || (attributes["include_chores"] && story.chore?)
    end
    if attributes["only_label"]
      stories = stories.select do |story|
        story.labels.include? attributes["only_label"]
      end
    end
    if attributes["except_label"]
      stories = stories.reject do |story|
        story.labels.include? attributes["except_label"]
      end
    end
    stories
  end

  def recently_delivered_stories
    o_index = recent_stories.find_index oldest_delivered_story
    n_index = recent_stories.find_index newest_delivered_story
    recent_stories[o_index..n_index]
  end

  def recent_stories
    project.iterations[-2..0].stories
  end

  def project
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
