require "spec_helper"

describe ReleaseMarker::PivotalTrackerProject do
  describe ".new" do
    it "requires a string name and a hash of attributes as arguments" do
      proc { ReleaseMarker::PivotalTrackerProject.new }.should raise_error(ArgumentError)
      proc { ReleaseMarker::PivotalTrackerProject.new("") }.should raise_error(ArgumentError)
      proc { ReleaseMarker::PivotalTrackerProject.new("", {}) }.should_not raise_error(ArgumentError)
    end
  end

  describe "#changelog" do
    context "there is a previous deploy" do
      it "returns an array of multi-line strings representing delivered tracker stories since the previous deploy"
    end

    context "there is no previous deploy" do
      it "returns an array of multi-line strings representing delivered tracker stories for the last two iterations"
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
