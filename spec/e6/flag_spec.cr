require "../../src/e6/types/flag.cr"

require "spec"

describe Flag do
  dummy_flag = File.read("./spec/fixtures/dummy_flag.json")
  f = Flag.from_json(dummy_flag)

  it "correctly serializes flag JSON" do
    f.id.should eq          9000
    f.created_at.should eq  "created_at"
    f.post_id.should eq     9001
    f.reason.should eq      "reason"
    f.creator_id.should eq  9002
    f.is_resolved.should    be_true
    f.updated_at.should eq  "updated_at"
    f.is_deletion.should    be_false
  end
end