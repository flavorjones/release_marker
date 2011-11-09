require "release_marker/version"
require "release_marker/project_manager"
require "release_marker/tracker_project"

require "yaml"

module ReleaseMarker
  class ConfigFileNotFound < RuntimeError ; end

  def ReleaseMarker.new *args
    ReleaseMarker::ProjectManager.new *args
  end
end
