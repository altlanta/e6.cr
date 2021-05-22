require "json"

class Tag
  include JSON::Serializable

  property id :                      UInt32
  property name :                    String
  property post_count :              UInt32
  @[JSON::Field(key: "related_tags")]
  property related_tags_string :     String
  property related_tags_updated_at : String
  property category :                UInt8
  property is_locked :               Bool
  property created_at :              String
  property updated_at :              String

  @[JSON::Field(ignore: true)]
  property related_tags :           Array(Tuple(String, UInt32)) = Array(Tuple(String, UInt32)).new

  def after_initialize
    if @related_tags_string.size > 0 && @related_tags_string[0] != '['
      split_tags_string = @related_tags_string.split(' ')

      0.step(to: split_tags_string.size - 1, by: 2) do |i|
        if related_tags
          @related_tags << {split_tags_string[i], split_tags_string[i + 1].to_u32}
        end
      end
    end
  end
end