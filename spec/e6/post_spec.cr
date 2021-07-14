require "../../src/e6/types/post.cr"

require "spec"

describe Post do
  post_json = File.read("./spec/fixtures/dummy_post.json")
  p = Post.from_json(post_json)

  tags = [
    ["tags_general_0", "tags_general_1"],
    ["tags_species_0", "tags_species_1"],
    ["tags_character_0", "tags_character_1"],
    ["tags_copyright_0", "tags_copyright_1"],
    ["conditional_dnp", "tags_artist_1"],
    ["tags_invalid_0", "tags_invalid_1"],
    ["tags_lore_0", "tags_lore_1"],
    ["tags_meta_0", "tags_meta_1"]
  ]

  alt_urls = [
    ["480p_urls_0", "480p_urls_1"],
    ["720p_urls_0", "720p_urls_1"],
    ["original_urls_0", "original_urls_1"]
  ]

  locked_tags = ["locked_tags_0", "locked_tags_1"]
  sources = ["sources_0", "sources_1"]

  it "correctly serializes post JSON" do
    p.id.should eq                                   9000
    p.created_at.should eq                           "created_at"
    p.updated_at.should eq                           "updated_at"

    p.file.width.should eq                           9001
    p.file.height.should eq                          9002
    p.file.ext.should eq                             "file_ext"
    p.file.size.should eq                            9003
    p.file.md5.should eq                             "file_md5"
    p.file.url.should eq                             "file_url"

    p.preview.width.should eq                        9004
    p.preview.height.should eq                       9005
    p.preview.url.should eq                          "preview_url"

    p.sample.has.should                              be_true
    p.sample.width.should eq                         9006
    p.sample.height.should eq                        9007
    p.sample.url.should eq                           "sample_url"

    p.sample.alternates["480p"].type.should eq       "480p_type"
    p.sample.alternates["480p"].width.should eq      9008
    p.sample.alternates["480p"].height.should eq     9009
    p.sample.alternates["480p"].urls.should eq       alt_urls[0]

    p.sample.alternates["720p"].type.should eq       "720p_type"
    p.sample.alternates["720p"].width.should eq      9010
    p.sample.alternates["720p"].height.should eq     9011
    p.sample.alternates["720p"].urls.should eq       alt_urls[1]

    p.sample.alternates["original"].type.should eq   "original_type"
    p.sample.alternates["original"].width.should eq  9012
    p.sample.alternates["original"].height.should eq 9013
    p.sample.alternates["original"].urls.should eq   alt_urls[2]

    p.score.up.should eq                             9014
    p.score.down.should eq                           -9015
    p.score.total.should eq                          -1

    p.tags.general.should eq                         tags[0]
    p.tags.species.should eq                         tags[1]
    p.tags.character.should eq                       tags[2]
    p.tags.copyright.should eq                       tags[3]
    p.tags.artist.should eq                          tags[4]
    p.tags.invalid.should eq                         tags[5]
    p.tags.lore.should eq                            tags[6]
    p.tags.meta.should eq                            tags[7]
    p.tags.all.should eq                             tags.flatten.sort
    p.tags.first_artist.should eq                    "tags_artist_1"
    p.tags.first_artist(false).should eq             "conditional_dnp"

    p.locked_tags.should eq                          locked_tags
    p.change_seq.should eq                           9016

    p.flags.pending.should                           be_true
    p.flags.flagged.should                           be_false
    p.flags.note_locked.should                       be_true
    p.flags.status_locked.should                     be_false
    p.flags.rating_locked.should                     be_true
    p.flags.deleted.should                           be_false

    p.rating.should eq                               "rating"
    p.fav_count.should eq                            9017
    p.sources.should eq                              sources
    p.pools.should eq                                [9018, 9019]

    p.relationships.parent_id.should eq              9020
    p.relationships.has_children.should              be_true
    p.relationships.has_active_children.should       be_true
    p.relationships.children.should eq               [9021, 9022]

    p.approver_id.should eq                          9023
    p.uploader_id.should eq                          9024
    p.description.should eq                          "description"
    p.comment_count.should eq                        9025
    p.is_favorited.should                            be_true
    p.has_notes.should                               be_true
    p.duration.should eq                             9026.27_f32
  end
end