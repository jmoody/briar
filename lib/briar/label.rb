module Briar
  module Label
    def label_exists? (name)
      !query("label marked:'#{name}'").empty?
    end

    def should_see_label (name)
      res = label_exists? (name)
      unless res
        screenshot_and_raise "i could not find label with access id #{name}"
      end
    end

    def label_exists_with_text? (name, text)
      actual = query("label marked:'#{name}'", :text).first
      actual.eql? text
    end

    def should_see_label_with_text (name, text)
      unless label_exists_with_text?(name, text)
        actual = query("label marked:'#{name}'", :text).first
        screenshot_and_raise "i expected to see '#{text}' in label named '#{name}' but found '#{actual}'"
      end
    end

    def should_not_see_label_with_text (name, text)
      if label_exists_with_text?(name, text)
        screenshot_and_raise "i expected that i would not see '#{text}' in label named '#{name}'"
      end
    end

    def wait_for_label (label_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but did not see label '#{label_id}'"
      wait_for(:timeout => timeout,
               :retry_frequency => BRIAR_RETRY_FREQ,
               :post_timeout => BRIAR_POST_TIMEOUT,
               :timeout_message => msg ) do
        label_exists? label_id
      end
    end

    def touch_label (label_id, wait_for_view_id=nil)
      wait_for_label label_id
      touch("label marked:'#{label_id}'")
      if wait_for_view_id != nil
        wait_for_view wait_for_view_id
      else
        step_pause
      end
    end
  end
end
