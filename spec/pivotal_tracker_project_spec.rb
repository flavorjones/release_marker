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
      it "returns an array of multi-line strings representing recently-delivered tracker bugs and features" do
        ptp = PTP.new "foo", "api_token" => "abcd", "project_id" => "1234"
        mock_new_feature = double "Story:feature", :release_marker? => false, :bug? => false, :feature? => true,  :chore? => false
        mock_new_bug     = double "Story:bug",     :release_marker? => false, :bug? => true,  :feature? => false, :chore? => false

        ptp.stub(:changelog_stories) { [mock_new_feature, mock_new_bug] }
        ptp.should_receive(:describe).with(mock_new_feature) { "Hello\nFeature\n" }
        ptp.should_receive(:describe).with(mock_new_bug)     { "Goodbye\nBug\n" }

        ptp.changelog.should == ["Hello\nFeature\n", "Goodbye\nBug\n"]
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
    describe "#changelog_stories" do
      context "with no label options" do
        it "sorts the stories by delivery status, accepted then delivered"
        it "by default only includes bugs and features, not chores"

        context "with include_chores" do
          it "set to true, include chores"
          it "set to false, exclude chores"
        end
      end

      context "with only_label option" do
        it "only includes stories with that label"
        it "sorts the stories by delivery status, placing included stories above excluded stories, accepted then delivered"
      end

      context "with except_label option" do
        it "includes all stories except those with that label"
        it "sorts the stories by delivery status, placing included stories above excluded stories, accepted then delivered"
      end
    end

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
