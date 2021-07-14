require "../../src/e6/client.cr"
require "../../src/e6/types/*"

require "spec"

describe Client do
  e6c = Client.new(debug: true)

  it "correctly initializes" do
    e6c.site.should eq "e621.net"
    e6c.debug.should eq true
  end

  describe "#list_posts" do
    it "successfully lists 75 posts" do
      posts = e6c.list_posts("rating:s")

      posts.should be_a Array(Post)

      if posts
        posts.size.should eq 75
      end
    end
  end

  describe "#get_post" do
    it "successfully gets a post by id" do
      post = e6c.get_post(1011510)

      post.should be_a Post

      if post # We know that this post exists, but Crystal doesn't.
        post.rating.should eq "s"
        post.tags.first_artist.should eq "huiro"
      end
    end
  end

  describe "#list_flags" do
    it "successfully lists some flags by post_id" do
      flags = e6c.list_flags(427530)

      flags.should be_a Array(Flag)

      if flags
        flags[0].id.should eq 107871
        flags[0].post_id.should eq 427530
      end
    end
  end

  describe "#list_tags" do
    it "successfully lists 320 tags matching `a`" do
      tags = e6c.list_tags(name_matches: "*a*", limit: 320)

      tags.should be_a Array(Tag)

      if tags
        tags.size.should eq 320
      end
    end
  end
end

