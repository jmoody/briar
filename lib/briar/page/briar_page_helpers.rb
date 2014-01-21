module Briar
  module Page
    module Helpers

      # returns +true+ if +current_page+ is an instance of +page_class+
      #
      # the +current_page+ argument defaults to the +@cp+ World variable
      def cp_is?(page_class, current_page=@cp)
        current_page.is_a?(page_class)
      end

      # raises a exception if the +current_page+ is not an instance of
      # +page_class+
      #
      # the +current_page+ argument defaults to the +@cp+ World variable
      def expect_current_page(page_class, current_page=@cp)
        unless cp_is? page_class, current_page
          screenshot_and_raise "expected current page to be '#{page_class}' but found '#{current_page}'"
        end
      end

      # raises an exception if the +current_page+ is not an instance of any of
      # +page_classes+
      #
      # the +current_page+ argument defaults to the +@cp+ World variable
      def expect_current_page_is_one_of(page_classes, current_page=@cp)
        res = page_classes.any? { |page_class| cp_is?(page_class, current_page) }
        unless res
          screenshot_and_raise "expected current page to be on of these '#{page_classes}' pages but found '#{current_page}'"
        end
      end

    end
  end
end
