require "release_marker/version"

require "yaml"

class ReleaseMarker
  CONFIG_FILE_NAME = "release_marker.yml"

  class ConfigFileNotFound < RuntimeError ; end

  def config
    raise ConfigFileNotFound, "Could not find `#{CONFIG_FILE_NAME}`" unless config_file
    @config ||= YAML.load_file config_file
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
