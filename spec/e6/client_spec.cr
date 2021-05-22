require "../../src/*"

require "spec"

describe Client do
  e6c = Client.new(debug: true)
  
  it "correctly initializes" do
    e6c.site.should eq "e621.net"
    e6c.post_limit.should eq 75
    e6c.debug.should eq true
  end

  describe "#list_posts" do
    it "successfully lists 75 posts" do
      t1 = Time.monotonic
      posts = e6c.list_posts("rating:s")
      t2 = Time.monotonic

      puts "Listed 75 posts in #{(t2 - t1).total_milliseconds}ms"

      posts.should be_a(Array(Post))
      if posts
        posts.size.should eq e6c.post_limit
      end
    end
  end

  describe "#get_post" do
    it "successfully gets a post by id" do
      t1 = Time.monotonic
      post = e6c.get_post(1011510)
      t2 = Time.monotonic

      puts "Got post 1011510 in #{(t2 - t1).total_milliseconds}ms"
      
      post.should be_a(Post)
      if post
        post.rating = "s"
      end
    end
  end

  describe "#list_flags" do
    it "successfully lists some flags by post_id" do
      t1 = Time.monotonic
      flags = e6c.list_flags(427530)
      t2 = Time.monotonic

      puts "Listed a flag in #{(t2 - t1).total_milliseconds}ms"

      flags.should be_a(Array(Flag))
      if flags
        flags[0].id.should eq 107871
        flags[0].post_id.should eq 427530
      end
    end
  end

  describe "#list_tags" do
    it "successfully lists 320 tags matching `a`" do
      t1 = Time.monotonic
      tags = e6c.list_tags(name_matches: "*a*", limit: 320)
      t2 = Time.monotonic

      puts "Listed 320 tags in #{(t2 - t1).total_milliseconds}ms"

      tags.should be_a(Array(Tag))
      if tags
        tags.size.should eq 320
      end
    end 
  end

  
end