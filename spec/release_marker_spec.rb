require 'spec_helper'

describe ReleaseMarker do
  describe ".config" do
    context "release_marker.yml exists in the current directory" do
      it "finds it" do
        in_a_tmp_dir do
          File.open("release_marker.yml", "w") do |f|
            f.write <<-EOYAML
              foo:
                bar:
                  bazz: 1234
                  quux: "abcd"
            EOYAML
          end

          ReleaseMarker.new.config.should == {
            "foo" => { "bar" => { "bazz" => 1234, "quux" => "abcd" } }
          }
        end
      end
    end

    context "release_marker.yml exists in ./config/" do
      it "finds it" do
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

          ReleaseMarker.new.config.should == {
            "foo" => { "bar" => { "bazz" => 1234, "quux" => "abcd" } }
          }
        end
      end
    end

    context "no release_marker.yml exists" do
      it "raises an exception" do
        in_a_tmp_dir do
          proc do
            ReleaseMarker.new.config
          end.should raise_error(ReleaseMarker::ConfigFileNotFound)
        end
      end
    end
  end
end
