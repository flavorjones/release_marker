require 'spec_helper'

describe ReleaseMarker::ProjectManager do
  describe "#config" do
    context "release_marker.yml exists in the current directory" do
      around do |spec|
        in_a_tmp_dir do
          File.open("release_marker.yml", "w") do |f|
            f.write <<-EOYAML
              foo:
                bar:
                  bazz: 1234
                  quux: "abcd"
            EOYAML
          end

          spec.call
        end
      end

      it "finds it" do
        ReleaseMarker.new.config.should == {
          "foo" => { "bar" => { "bazz" => 1234, "quux" => "abcd" } }
        }
      end

      it "can be overridden by argument to .new" do
        ReleaseMarker.new("fizzle" => { "fazzle" => "shizzle" }).config.should == {
          "fizzle" => { "fazzle" => "shizzle" }
        }
      end
    end

    context "release_marker.yml exists in ./config/" do
      around do |spec|
        in_a_tmp_dir do
          FileUtils.mkdir_p "config"
          File.open("config/release_marker.yml", "w") do |f|
            f.write <<-EOYAML
              foo:
                bar:
                  bazz: 1234
                  quux: "abcd"
            EOYAML
          end

          spec.call
        end
      end

      it "finds it" do
        ReleaseMarker.new.config.should == {
          "foo" => { "bar" => { "bazz" => 1234, "quux" => "abcd" } }
        }
      end

      it "can be overridden by argument to .new" do
        ReleaseMarker.new("fizzle" => { "fazzle" => "shizzle" }).config.should == {
          "fizzle" => { "fazzle" => "shizzle" }
        }
      end
    end

    context "no release_marker.yml exists" do
      around do |spec|
        in_a_tmp_dir do
          spec.call
        end
      end

      context "initialized with no argument" do
        it "raises an exception" do
          proc do
            ReleaseMarker.new.config
          end.should raise_error(ReleaseMarker::ConfigFileNotFound)
        end
      end

      context "initialized with configuration arguments" do
        it "uses that config" do
          ReleaseMarker.new("fizzle" => { "fazzle" => "shizzle" }).config.should == {
            "fizzle" => { "fazzle" => "shizzle" }
          }
        end
      end

      context "initialized with a config_file argument" do
        around do |spec|
          in_a_tmp_dir do
            File.open("foo_fazz.yml", "w") do |f|
              f.write <<-EOYAML
                foo:
                  bar:
                    bazz: 1234
                    quux: "abcd"
              EOYAML
            end

            spec.call
          end
        end

        it "uses that config" do
          ReleaseMarker.new("foo_fazz.yml").config.should == {
            "foo" => { "bar" => { "bazz" => 1234, "quux" => "abcd" } }
          }
        end
      end
    end
  end

  describe "#projects" do
    context "no tracker projects defined" do
      it "raises an exception"
    end

    context "tracker projects defined" do
      it "creates a PivotalTrackerProject for each pivotal_tracker config entry" do
        rm = ReleaseMarker.new("pivotal_tracker" => [
            {"Project 1" => {"project_id" => 12345, "api_token" => "abcdabcd"}},
            {"Project 2" => {"project_id" => 23456, "api_token" => "12341234"}},
          ])

        rm.projects.length.should == 2
        rm.projects.all? {|p| p.is_a?(ReleaseMarker::PivotalTrackerProject)}.should be_true
      end
    end
  end

  describe "#changelog" do
    it "calls #changelog on each PivotalTrackerProject, and merges the results"
  end

  describe "#release" do
    it "calls #release on each PivotalTrackerProject"
  end
end
