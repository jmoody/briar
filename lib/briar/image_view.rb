require 'calabash-cucumber'

module Briar
  module ImageView
    def image_view_exists? name
      alpha = query("imageView marked:'#{name}'", :alpha).first
      if alpha.nil?
        false
      else
        alpha.to_i != 0
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
