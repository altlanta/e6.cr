require "json"

class Post
  include JSON::Serializable

  property id :            UInt32
  property created_at :    String
  property updated_at :    String | Nil
  property file :          Hash(String, String | UInt32 | Nil)
  property preview :       Hash(String, String | UInt32 | Nil)
  property sample :        Hash(String, String | UInt32 | Bool | Hash(String, String | UInt32 | Bool | Hash(String, String | UInt32 | Array(String | Nil))) | Nil)
  property score :         Hash(String, Int32)
  property tags :          Hash(String, Array(String))
  property locked_tags :   Array(String)
  property change_seq :    UInt32
  property flags :         Hash(String, Bool)
  property rating :        String
  property fav_count :     UInt32
  property sources :       Array(String)
  property pools :         Array(UInt32)
  property relationships : Hash(String, UInt32 | Bool | Array(UInt32) | Nil)
  property approver_id :   UInt32 | Nil
  property uploader_id :   UInt32
  property description :   String | Nil
  property comment_count : UInt32
  property is_favorited :  Bool
  property has_notes :     Bool
  property duration :      Float32 | Nil

  # Returns the total score calculated by the server.
  def total_score : Int32
    return score["total"]
  end

  # Returns the first artist from an alphabetically sorted array of artists.
  # *ignore_notices* ignores "contidional_dnp", "sound_warning" or any tags that do not belong to an artist.
  def first_artist(ignore_notices = true) : String
    if tags["artist"].empty?
      return "unknown"
    end

    if ignore_notices
      attempted_artist_name = tags["artist"].sort.find do |tag|
        ["conditional_dnp", "sound_warning"].none?(tag)
      end

      if attempted_artist_name
        return attempted_artist_name
      end
    end
    
    return tags["artist"][0]
  end

  # Returns an array containing each tag from each category, sorted.
  def joined_tags : Array(String)
    tags_ = Array(String).new

    @tags.each do |tag_group|
      tags_ = tags_ + tag_group[1]
    end

    tags_.sort!
    return tags_
  end
end