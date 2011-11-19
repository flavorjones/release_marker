require "spec_helper"

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
      it "raises an exception" do
        proc {
          ReleaseMarker.new({"foo" => {"bar" => "bazz"}}).projects
        }.should raise_error(ReleaseMarker::InvalidConfig)
      end
    end

    context "tracker projects defined" do
      it "creates a PivotalTrackerProject for each pivotal_tracker config entry" do
        rm = ReleaseMarker.new("pivotal_tracker" => [
            {"Project 1" => {"project_id" => 12345, "api_token" => "abcdabcd"}},
            {"Project 2" => {"project_id" => 23456, "api_token" => "12341234"}},
          ])

        ReleaseMarker::PivotalTrackerProject.should_receive(:new).with("Project 1", {"project_id" => 12345, "api_token" => "abcdabcd"}).and_return(:project_1)
        ReleaseMarker::PivotalTrackerProject.should_receive(:new).with("Project 2", {"project_id" => 23456, "api_token" => "12341234"}).and_return(:project_2)

        rm.projects.should =~ [:project_1, :project_2]
      end
    end
  end

  describe "#changelog" do
    it "calls #changelog on each PivotalTrackerProject, and merges the results" do
      project_1_config = {"Project 1" => {"project_id" => 12345, "api_token" => "abcdabcd"}}
      project_2_config = {"Project 2" => {"project_id" => 23456, "api_token" => "12341234"}}

      mock_project_1 = Object.new
      mock_project_2 = Object.new

      ReleaseMarker::PivotalTrackerProject.stub(:new).with(project_1_config.keys.first, project_1_config.values.first).and_return(mock_project_1)
      ReleaseMarker::PivotalTrackerProject.stub(:new).with(project_2_config.keys.first, project_2_config.values.first).and_return(mock_project_2)

      changelog_1 = [
        "(feature) Updated the froonting turlindromes to micturate\n   Some details here",
        "(bug) App should not rend thee in the gobberworts with a blurglecruncheon\n   Some more details here"
      ]
      changelog_2 = [
        "(feature) West Coast represent, now put your hands up\n   Some details here",
        "(bug) All I want to know is where the party at?\n   And can I bring my gat?"
      ]

      mock_project_1.should_receive(:changelog).and_return(changelog_1)
      mock_project_2.should_receive(:changelog).and_return(changelog_2)

      rm = ReleaseMarker.new("pivotal_tracker" => [project_1_config, project_2_config])
      rm.changelog.should == (changelog_1 + changelog_2)
    end
  end

  describe "#release" do
    context "given a version-id argument" do
      it "calls #release on each PivotalTrackerProject with that version-id" do
        mock_project_1 = Object.new
        mock_project_2 = Object.new

        rm = ReleaseMarker.new({})
        rm.stub(:projects).and_return([mock_project_1, mock_project_2])

        mock_project_1.should_receive(:release).with("foo")
        mock_project_2.should_receive(:release).with("foo")

        rm.release "foo"
      end
    end

    context "given no arguments" do
      it "calls #release on each PivotalTrackerProject" do
        mock_project_1 = Object.new
        mock_project_2 = Object.new

        rm = ReleaseMarker.new({})
        rm.stub(:projects).and_return([mock_project_1, mock_project_2])

        mock_project_1.should_receive(:release).with()
        mock_project_2.should_receive(:release).with()

        rm.release
      end
    end
  end
end
