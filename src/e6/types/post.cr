require "json"

# A representation of a post, with some convenience functions.
class Post
  include JSON::Serializable

  property id :            UInt32
  property created_at :    String
  property updated_at :    String?
  property file :          PostFile
  property preview :       PostPreview
  property sample :        PostSample
  property score :         PostScore
  property tags :          PostTags
  property locked_tags :   Array(String)
  property change_seq :    UInt32
  property flags :         PostFlags
  property rating :        String
  property fav_count :     UInt32
  property sources :       Array(String)
  property pools :         Array(UInt32)
  property relationships : PostRelationships
  property approver_id :   UInt32?
  property uploader_id :   UInt32
  property description :   String?
  property comment_count : UInt32
  property is_favorited :  Bool
  property has_notes :     Bool
  property duration :      Float32?

  def self.from_json(json : String)
    parser = JSON::PullParser.new(json)
    self.start_safe_parser(parser, json)
  end

  def self.from_json(json, root : String)
    parser = JSON::PullParser.new(json)
    parser.on_key!(root) do
      self.start_safe_parser(parser, json)
    end
  end

  def self.start_safe_parser(parser : JSON::PullParser, json : String)
    begin
      new parser
    rescue exception
      puts "#{exception}\nDumping JSON:"
      puts json
      exit 1
    end
  end
end

class PostFile
  include JSON::Serializable

  property width :  UInt32
  property height : UInt32
  property ext :    String
  property size :   UInt32
  property md5 :    String
  property url :    String?
end

class PostPreview
  include JSON::Serializable

  property width :  UInt32
  property height : UInt32
  property url :    String?
end

class PostSample
  include JSON::Serializable

  property has :        Bool # This doesn't even indicate anything. Useless.
  property width :      UInt32
  property height :     UInt32
  property url :        String?
  property alternates : Hash(String, PostSampleAlternates)
end

class PostSampleAlternates
  include JSON::Serializable

  property type :   String
  property width :  UInt32
  property height : UInt32
  property urls :   Array(String?)

  def after_initialize
    @urls.compact!
  end
end

class PostScore
  include JSON::Serializable

  property up :    UInt32
  property down :  Int32
  property total : Int32
end

class PostTags
  include JSON::Serializable

  property general :   Array(String)
  property species :   Array(String)
  property character : Array(String)
  property copyright : Array(String)
  property artist :    Array(String)
  property invalid :   Array(String)
  property lore :      Array(String)
  property meta :      Array(String)

  # Returns an array containing all categories' tags, sorted alphabetically.
  def all : Array(String)
    return (
      @general +
      @species +
      @character +
      @copyright +
      @artist +
      @invalid +
      @lore +
      @meta
    ).sort
  end

  # Returns the first artist from an alphabetically sorted array of artists.
  # *ignore_notices* ignores "contidional_dnp", "sound_warning" or any tags that do not belong to an artist.
  def first_artist(ignore_notices = true) : String
    if @artist.empty?
      return "unknown"
    elsif ignore_notices
      # Filters out "conditional_dnp" and "sound_warning"
      attempted_artist_name = @artist.sort.find do |tag|
        ["conditional_dnp", "sound_warning"].none?(tag)
      end

      # If none is found it will return the first tag.
      return attempted_artist_name || @artist[0]
    else
      return @artist[0]
    end
  end
end

# Keep in mind that these are not the same as Flags.
class PostFlags
  include JSON::Serializable

  property pending :       Bool
  property flagged :       Bool
  property note_locked :   Bool
  property status_locked : Bool
  property rating_locked : Bool
  property deleted :       Bool
end

class PostRelationships
  include JSON::Serializable

  property parent_id :           UInt32?
  property has_children :        Bool
  property has_active_children : Bool
  property children :            Array(UInt32)
end