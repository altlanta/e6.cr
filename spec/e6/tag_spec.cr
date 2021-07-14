require "../../src/e6/types/tag.cr"

require "spec"

describe Tag do
  tag_json = File.read("./spec/fixtures/dummy_tag.json")
  t = Tag.from_json(tag_json)

  related_tags = {
    "rel1" => 9002,
    "rel2" => 9003,
    "rel3" => 9004,
    "rel4" => 9005
  }

  related_tags_str = "rel1 9002 rel2 9003 rel3 9004 rel4 9005"

  it "correctly serializes tag JSON" do
    t.id.should eq                      9000
    t.name.should eq                    "name"
    t.post_count.should eq              9001
    t.related_tags.should eq            related_tags
    t.related_tags_string.should eq     related_tags_str
    t.related_tags_updated_at.should eq "related_tags_updated_at"
    t.category.should eq                8
    t.is_locked.should                  be_false
    t.created_at.should eq              "created_at"
    t.updated_at.should eq              "updated_at"
  end
end