require "spec_helper"

describe ReleaseMarker::PivotalTrackerProject do
  PTP = ReleaseMarker::PivotalTrackerProject

  describe "Public interface" do
    describe ".new" do
      it "requires a string name and a hash of attributes as arguments" do
        proc { PTP.new }.should raise_error(ArgumentError)
        proc { PTP.new("") }.should raise_error(ArgumentError)
        proc { PTP.new("", {}) }.should_not raise_error(ArgumentError)
      end
    end

    describe "#changelog" do
      context "there is a previous deploy-named release marker" do
        before do
          @ptp = PTP.new "foo", "api_token" => "abcd", "project_id" => "1234"
          @mock_story_set = double("StorySet")
          @mock_release_marker = double "Story:release", :release_marker? => true,  :bug? => false, :feature? => false
          @mock_new_feature    = double "Story:feature", :release_marker? => false, :bug? => false, :feature? => true
          @mock_new_bug        = double "Story:bug",     :release_marker? => false, :bug? => true,  :feature? => false

          @ptp.stub(:recent_stories) { @mock_story_set }
          @ptp.stub(:most_recent_release_marker) { @mock_release_marker }
          @ptp.stub(:most_recent_delivered_story) { @mock_new_bug }
          @mock_story_set.stub(:range).with(@mock_release_marker, @mock_new_bug) {
            [@mock_release_marker, @mock_new_feature, @mock_new_bug]
          }

          @ptp.should_receive(:describe).with(@mock_new_feature) { "Hello\nFeature\n" }
          @ptp.should_receive(:describe).with(@mock_new_bug) { "Goodbye\nBug\n" }
        end

        it "returns an array of multi-line strings representing delivered tracker stories since the previous deploy" do
          @ptp.changelog.should == ["Hello\nFeature\n", "Goodbye\nBug\n"]
        end
      end

      context "there is a previous non-deploy-named release marker" do
        it "returns an array of multi-line strings representing delivered tracker stories for the current and previous two iterations"
      end

      context "there is no previous release marker" do
        it "returns an array of multi-line strings representing delivered tracker stories for the current and previous two iterations"
      end

      context "with no options" do
        it "includes all bugs and features, but not chores"
        it "sorts the stories by delivery status, accepted then delivered"
      end

      context "with only_label option" do
        it "only includes stories with that label"
        it "sorts the stories by delivery status, placing included stories above excluded stories, accepted then delivered"
      end

      context "with except_label option" do
        it "includes all stories except those with that label"
        it "sorts the stories by delivery status, placing included stories above excluded stories, accepted then delivered"
      end

      context "with include_chores" do
        it "set to true, include chores"
        it "set to false, exclude chores"
      end
    end

    describe "#release" do
      context "with no options" do
        it "places the release marker below all delivered stories"
      end

      context "with only_label option" do
        it "places the release marker above excluded stories"
      end

      context "with exclude_label option" do
        it "places the release marker above excluded stories"
      end
    end
  end

  describe "Private interface" do
    describe "#recent_stories" do
      it "needs specs"
    end

    describe "#most_recent_release_marker" do
      it "needs specs"
    end

    describe "#most_recent_delivered_story" do
      it "needs specs"
    end

    describe "#describe" do
      context "a bug" do
        it "displays story information"
      end

      context "a feature" do
        it "displays story information"
      end

      context "a chore" do
        it "displays story information"
      end
    end
  end
end
