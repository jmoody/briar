require 'calabash-cucumber'

module Briar
  module ImageView
    def image_view_exists? name
      query_str = "imageView marked:'#{name}'"
      exists = !query(query_str).empty?
      if exists
        alpha = query(query_str, :alpha).first.to_i
        hidden = query(query_str, :isHidden).first.to_i
        alpha > 0 and hidden == 0
      end
    end

    def should_see_image_view name
      unless image_view_exists? name
        screenshot_and_raise "i should see image view with id '#{name}'"
      end
    end

    def should_not_see_image_view name
      if image_view_exists? name
        screenshot_and_raise "i should not see an image view with id #{name}"
      end
    end
  end
end
