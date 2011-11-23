require "spec_helper"

describe ReleaseMarker::PivotalTrackerProject do
  PTP = ReleaseMarker::PivotalTrackerProject

  def make_story story_type
    double("Story:#{story_type}", {
        :release_marker? => (story_type == :release_marker),
        :bug? => (story_type == :bug),
        :feature? => (story_type == :feature),
        :chore? => (story_type == :chore)
      })
  end

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
        ptp = PTP.new "foo", {}
        feature = make_story :feature
        bug     = make_story :bug

        ptp.stub(:changelog_stories) { [feature, bug] }
        ptp.should_receive(:describe).with(feature) { "Hello\nFeature\n" }
        ptp.should_receive(:describe).with(bug)     { "Goodbye\nBug\n" }

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
      let(:release_marker) { make_story :release_marker }
      let(:feature)        { make_story :feature }
      let(:chore)          { make_story :chore }
      let(:bug)            { make_story :bug }

      context "with no label options" do
        context "stories are not in order of delivery status" do
          it "sorts the stories by delivery status, accepted then delivered"
        end

        it "by default only includes bugs and features from recent_stories, not chores or release_markers" do
          ptp = PTP.new "foo", {}
          ptp.stub(:recently_delivered_stories) { [release_marker, feature, chore, bug] }
          ptp.changelog_stories.should == [feature, bug]
        end

        context "with include_chores" do
          it "set to true, include chores" do
            ptp = PTP.new "foo", {"include_chores" => true}
            ptp.stub(:recently_delivered_stories) { [release_marker, feature, chore, bug] }
            ptp.changelog_stories.should == [feature, chore, bug]
          end

          it "set to false, exclude chores" do
            ptp = PTP.new "foo", {"include_chores" => false}
            ptp.stub(:recently_delivered_stories) { [release_marker, feature, chore, bug] }
            ptp.changelog_stories.should == [feature, bug]
          end
        end
      end

      context "with only_label option" do
        context "stories are not in order of delivery status and label inclusiong" do
          it "sorts the stories by delivery status, placing included stories above excluded stories, accepted then delivered"
        end

        it "only includes stories with that label" do
          feature.stub(:labels) { ["foo"] }
          bug.stub(:labels)     { ["bar"] }

          ptp = PTP.new "foo", {"only_label" => "foo"}
          ptp.stub(:recently_delivered_stories) { [release_marker, feature, chore, bug] }
          ptp.changelog_stories.should == [feature]
        end
      end

      context "with except_label option" do
        context "stories are not in order of delivery status and label inclusiong" do
          it "sorts the stories by delivery status, placing included stories above excluded stories, accepted then delivered"
        end

        it "includes all stories except those with that label" do
          feature.stub(:labels) { ["foo"] }
          bug.stub(:labels)     { ["bar"] }

          ptp = PTP.new "foo", {"except_label" => "foo"}
          ptp.stub(:recently_delivered_stories) { [release_marker, feature, chore, bug] }
          ptp.changelog_stories.should == [bug]
        end
      end
    end

    describe "#recently_delivered_stories" do
      it "returns the range of recent_stories between oldest_delivered_story and newest_delivered_story" do
        ptp = PTP.new "foo", {"except_label" => "foo"}
        ptp.stub(:recent_stories) { [0,1,2,3,4,5,6] }
        ptp.stub(:oldest_delivered_story) { 2 }
        ptp.stub(:newest_delivered_story) { 4 }
        ptp.recently_delivered_stories.should == [2,3,4]
      end
    end

    describe "#recent_stories" do
      it "needs specs"
    end

    describe "#oldest_delivered_story" do
      it "needs specs"
    end

    describe "#newest_delivered_story" do
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
