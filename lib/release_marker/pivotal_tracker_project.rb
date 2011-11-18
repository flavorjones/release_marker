require "release_marker/project_manager"

class ReleaseMarker::PivotalTrackerProject
  ReleaseMarker::ProjectManager.register_project "pivotal_tracker", self

  def initialize name, attributes
  end
end
