class ReleaseMarker::ProjectManager
  CONFIG_FILE_NAME = "release_marker.yml"

  def initialize arg=nil
    if arg.is_a?(String)
      @config = YAML.load_file arg
    elsif arg.is_a?(Hash)
      @config = arg
    end
  end

  def config
    @config ||= begin
                  raise ReleaseMarker::ConfigFileNotFound, "Could not find `#{CONFIG_FILE_NAME}`" unless config_file
                  YAML.load_file config_file
                end
  end

  def projects
    @projects ||= begin
                    config["pivotal_tracker"].to_a.collect do |config|
                      name = config.keys.first
                      attrs = config.values.first
                      ReleaseMarker::PivotalTrackerProject.new name, attrs
                    end
                  end
    raise ReleaseMarker::InvalidConfig, "No projects defined" if @projects.empty?
    @projects
  end

  def changelog
    projects.collect(&:changelog).flatten
  end

  private

  def config_file
    @_config_file ||= [
      File.expand_path(File.join(Dir.pwd, CONFIG_FILE_NAME)),
      File.expand_path(File.join(Dir.pwd, "config", CONFIG_FILE_NAME))
    ].find do |file_path|
      File.exists? file_path
    end
  end
end
