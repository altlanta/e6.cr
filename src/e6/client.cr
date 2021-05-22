require "./post.cr"
require "./flag.cr"
require "./tag.cr"

require "http/client"
require "json"
require "time"
require "benchmark"

# Main client class.
#
# Contains typical API functionality such as listing posts, flags,
# tags, etc.
class Client
  property site :       String
  property api_key :    String
  property login :      String
  property debug :      Bool

  # Creates a new instance of Client.
  #
  # - *site* - the site to connect to.
  # - *api_key* - your API key; get it from your account page > Manage API Access
  # - *login* - your username on the site.
  # - *debug* - whether or not to print request times.
  def initialize(@site = "e621.net", @api_key = "", @login = "", @debug = false)
    @headers = HTTP::Headers.new

    @headers.add("Accept", "application/json")
    @headers.add("Accept-Language", "en-US, en;q=0.5")
    @headers.add("Connection", "keep-alive")
    @headers.add("User-Agent", "e6.cr/0.1 (by altlants on e621)")
  end

  # A convenience function that allows for timing requests in debugging.
  private def request(uri : URI) : HTTP::Client::Response
    if debug
      t1 = Time.monotonic
      response = HTTP::Client.get(uri, @headers)
      t2 = Time.monotonic
      puts "[debug] Request took #{(t2 - t1).total_milliseconds}ms."
    else
      response = HTTP::Client.get(uri, @headers)
    end

    return response
  end

  # A convenience function to reuse values to generate a URI.
  private def generate_uri(path : String, query : String? = nil) : URI
    return URI.new("https", @site, path: path, query: query)
  end

  # Searches posts using a string, just like how searching on the website works.
  #
  # [see e621 API > Posts > List](https://e621.net/wiki_pages/2425#posts_list)
  def list_posts(tags : String, post_limit : UInt32 = 75, page = 0) : Array(Post)?
    params = URI::Params.build do |form|
      form.add "limit", post_limit.to_s
      form.add "page", page.to_s
      form.add "tags", tags
    end

    response = request(generate_uri("/posts.json", query: params))

    if response.success?
      new_post_array = Array(Post).new
      post_array = JSON.parse(response.body)["posts"].as_a
      
      if post_array.size > 0
        JSON.parse(response.body)["posts"].as_a.each do |post|
          new_post_array << Post.from_json(post.to_json)
        end

        return new_post_array
      else
        return nil
      end
    else
      return nil
    end
  end

  # Gets a single post based on its ID.
  def get_post(id : UInt32) : Post?
    response = request(generate_uri("/posts/#{id}.json"))

    if response.success?
      return Post.from_json(JSON.parse(response.body)["post"].to_json)
    else
      return nil
    end
  end

  # Searches flags by post ID.
  # BUG: Currently, searching by creator ID or name is broken on the API side.
  #
  # [See e621 API > Flags > Listing](https://e621.net/wiki_pages/2425#flags_listing)
  def list_flags(id : UInt32) : Array(Flag)?
    params = URI::Params.build do |form|
      form.add "search[post_id]", id.to_s
    end

    response = request(generate_uri("/post_flags.json", query: params))

    if response.success? && response.body[0] == '['
      new_flag_array = Array(Flag).new

      JSON.parse(response.body).as_a.each do |flag|
        new_flag_array << Flag.from_json(flag.to_json)
      end

      return new_flag_array
    else
      return nil
    end
  end

  # Lists tags by name or category, sorted by date, count, or alphabetically.
  #
  # [See e621 API > Tags > Listing](https://e621.net/wiki_pages/2425#tags_listing)
  def list_tags(name_matches : String? = nil, category : UInt8 | String | Nil = nil, order = "date", hide_empty = true, has_wiki : Bool? = nil, has_artist : Bool? = nil, limit = 75, page = 0) : Array(Tag)?
    if category.is_a?(String)
      category = category.downcase
      
      case category
      when "general"
        category = 0
      when "artist"
        category = 1
      when "copyright"
        category = 3
      when "character"
        category = 4
      when "species"
        category = 5
      when "meta"
        category = 7
      when "lore"
        category = 8
      else
        raise "Invalid category name \"#{category}\""
      end
    elsif category.is_a?(UInt8)
      if [0, 1, 3, 4, 5, 7, 8].none?(category)
        raise "Invalid category number #{category}"
      end
    end

    if ["date", "count", "name"].none?(order)
      raise "Invalid order \"#{order}\""
    end

    params = URI::Params.build do |form|
      form.add "search[name_matches]", name_matches if name_matches
      form.add "search[category]", category.to_s if category
      form.add "search[order]", order
      form.add "search[hide_empty]", hide_empty.to_s
      form.add "search[has_wiki]", has_wiki if has_wiki
      form.add "search[has_artist]", has_artist if has_artist
      form.add "limit", limit.to_s
      form.add "page", page.to_s
    end

    response = request(generate_uri("/tags.json", query: params))

    if response.success? && response.body[0] == '['
      new_tag_array = Array(Tag).new
      
      JSON.parse(response.body).as_a.each do |tag|
        new_tag_array << Tag.from_json(tag.to_json)
      end

      return new_tag_array
    else
      return nil
    end
  end
end