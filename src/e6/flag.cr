require "json"

class Flag
  include JSON::Serializable

  property id :            UInt32
  property created_at :    String
  property post_id :       UInt32
  property reason :        String
  property creator_id :    UInt32 | Nil
  property is_resolved :   Bool | Nil
  property updated_at :    String | Nil
  property is_deletion :   Bool
  property category :      String
end