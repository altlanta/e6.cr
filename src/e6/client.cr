require "./types/*"

require "http/client"
require "json"
require "time"
require "base64"

# Main client class.
#
# Contains typical API functionality such as listing posts, flags, tags, etc.
class Client
  property site :  String
  property debug : Bool

  private property first_post_id :    UInt32?
  private property last_post_id :     UInt32?
  private property last_search_tags : String?

  private property headers = HTTP::Headers{
    "Accept" =>          "application/json",
    "Accept-Language" => "en-US, en;q=0.5",
    "Connection" =>      "keep-alive",
    "User-Agent" =>      "e6.cr/0.2.0 (by altlanta on e621)"
  }

  # Creates a new instance of Client.
  #
  # - *site* - the site to connect to.
  # - *debug* - whether or not to print debug information such as request times and URLs.
  def initialize(@site = "e621.net", @debug = false)
  end

  # Creates a new instance of Client with credentials.
  # This will include the credentials in the `Authorization:` header, as per HTTP Basic Auth.
  #
  # - *login* - your username on the site.
  # - *api_key* - your API key; get it from your account page > Manage API Access
  # - *site* - the site to connect to.
  # - *debug* - whether or not to print debug information such as request times and URLs.
  def initialize(
    login :   String,
    api_key : String,
    @site :   String = "e621.net",
    @debug :  Bool =   false
  )
    encoded_auth = Base64.strict_encode(login + ':' + api_key)
    @headers.add("Authorization", "Basic #{encoded_auth}")

    puts "[debug] Authenticating with #{encoded_auth}." if debug
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
    uri = URI.new("https", @site, path: path, query: query)
    puts "[debug] Requesting #{uri}" if debug
    return uri
  end

  # Searches posts using a string, just like how searching on the website works.
  #
  # [see e621 API > Posts > List](https://e621.net/wiki_pages/2425#posts_list)
  #
  # In addition to `a/b(post_id)` or a page number, *page* can also accept "next" or prev".
  # When using "next" or "prev" in *page*, the IDs of the first and last posts of the last search will be reused when requesting the next or previous page.
  # **Note that "next" or "prev" will not work on the first search of a specific query.**
  def list_posts(
    tags :  String,
    limit : UInt32 =          75,
    page :  String | UInt32 = 0
  ) : Array(Post)?
    # regex matches a string that begins with a single 'a' or 'b' and ends with digits
    if (page.is_a? String && page.matches? /^[ab]\d+$/) || page.is_a? UInt32
      # page stays as it is, since it's already a number or a valid format
    elsif @last_post_id.is_a? UInt32 && @last_search_tags == tags
      page = case page
      when "next" then "a#{@last_post_id}"
      when "prev" then "b#{@first_post_id}"
      else; return nil; end
    else; return nil; end

    @last_search_tags = tags

    params = URI::Params.build do |form|
      form.add "limit", limit.to_s
      form.add "page",  page.to_s
      form.add "tags",  tags
    end

    response = request(generate_uri("/posts.json", query: params))

    if response.success?
      new_post_array = Array(Post).from_json(response.body, root: "posts")

      if new_post_array.size > 0
        @first_post_id = new_post_array.first.id
        @last_post_id = new_post_array.last.id

        return new_post_array
      else; return nil; end
    else; return nil; end
  end

  # Gets a single post based on its ID.
  def get_post(id : UInt32) : Post?
    response = request(generate_uri("/posts/#{id}.json"))

    if response.success?
      return Post.from_json(response.body, root: "post")
    else; return nil; end
  end

  # Searches flags by post ID.
  # BUG: Currently, searching by creator ID or name is broken on the API side, so it is not implemented at the moment.
  #
  # [See e621 API > Flags > Listing](https://e621.net/wiki_pages/2425#flags_listing)
  def list_flags(id : UInt32) : Array(Flag)?
    params = URI::Params.build do |form|
      form.add "search[post_id]", id.to_s
    end

    response = request(generate_uri("/post_flags.json", query: params))

    if response.success? && response.body[0] == '['
      return Array(Flag).from_json(response.body)
    else; return nil; end
  end

  # Lists tags by name or category, sorted by date, count, or alphabetically.
  #
  # [See e621 API > Tags > Listing](https://e621.net/wiki_pages/2425#tags_listing)
  def list_tags(
    name_matches : String? =              nil,
    category :     UInt8 | String | Nil = nil,
    order :        String =               "date",
    hide_empty :   Bool =                 true,
    has_wiki :     Bool? =                nil,
    has_artist :   Bool? =                nil,
    limit :        UInt32 =               75,
    page :         UInt32 =               0
  ) : Array(Tag)?
    if category.is_a? String
      category = category.downcase

      category_map = {
        "general" =>   0,
        "artist" =>    1,
        "copyright" => 3,
        "character" => 4,
        "species" =>   5,
        "meta" =>      7,
        "lore" =>      8
      }

      if category_map.has_key? category
        category = category_map[category]
      else
        raise "Invalid category #{category}"
      end
    end

    unless order.in?("date", "count", "name")
      raise "Invalid order #{order}"
    end

    params = URI::Params.build do |form|
      form.add "search[name_matches]", name_matches    if name_matches
      form.add "search[category]",     category.to_s   if category
      form.add "search[order]",        order
      form.add "search[hide_empty]",   hide_empty.to_s
      form.add "search[has_wiki]",     has_wiki.to_s   if has_wiki
      form.add "search[has_artist]",   has_artist.to_s if has_artist
      form.add "limit",                limit.to_s
      form.add "page",                 page.to_s
    end

    response = request(generate_uri("/tags.json", query: params))

    if response.success? && response.body[0] == '['
      return Array(Tag).from_json(response.body)
    else; return nil; end
  end
end