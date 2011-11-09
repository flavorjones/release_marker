require 'spec_helper'

describe ReleaseMarker do
  describe ".new" do
    it "calls ReleaseMarker::ProjectManager.new" do
      ReleaseMarker::ProjectManager.should_receive(:new).with(:foo, :bar)
      ReleaseMarker.new :foo, :bar
    end
  end
end
  
