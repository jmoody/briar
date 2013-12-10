module Briar
  module TextView
    def text_view_exists? (view_id)
      !query("textView marked:'#{view_id}'").empty?
    end

    def wait_for_text_view(view_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but did not see '#{view_id}'"
      wait_for(:timeout => timeout,
               :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
               :post_timeout => BRIAR_WAIT_STEP_PAUSE,
               :timeout_message => msg) do
        text_view_exists? view_id
      end
    end

    def wait_for_text_view_to_disappear(view_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds for '#{view_id}' to disappear but it is still visible"
      options = {:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg}
      wait_for(options) do
        not text_view_exists? view_id
      end
    end

    def should_see_text_view (view_id, timeout=BRIAR_WAIT_TIMEOUT)
      wait_for_text_view(view_id, timeout)
    end

    def should_not_see_text_view (view_id, timeout=BRIAR_WAIT_TIMEOUT)
      wait_for_text_view_to_disappear(view_id, timeout)
    end

    def should_see_text_view_with_text(view_id, text=@text_entered_by_keyboard)
      should_see_text_view view_id
      actual = query("textView marked:'#{view_id}'", :text).first
      unless text.eql?(actual)
        screenshot_and_raise "i expected to see '#{text}' in text view '#{view_id}' but found '#{actual}'"
      end
    end
  end
end
