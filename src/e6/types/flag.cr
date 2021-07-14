require "json"

# A representation of a Flag. Not the same as PostFlags.
class Flag
  include JSON::Serializable

  property id :          UInt32
  property created_at :  String
  property post_id :     UInt32
  property reason :      String
  property creator_id :  UInt32?
  property is_resolved : Bool?
  property updated_at :  String?
  property is_deletion : Bool
  property category :    String
end