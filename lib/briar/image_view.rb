module Briar
  module ImageView
    def image_view_exists?(iv_id)
      query_str = "imageView marked:'#{iv_id}'"
      exists = !query(query_str).empty?
      if exists
        alpha = query(query_str, :alpha).first.to_i
        hidden = query(query_str, :isHidden).first.to_i
        alpha > 0 and hidden == 0
      end
    end

    def should_see_image_view(iv_id, timeout=BRIAR_WAIT_TIMEOUT)
      wait_for_image_view iv_id, timeout
    end

    def should_not_see_image_view(iv_id, timeout=BRIAR_WAIT_TIMEOUT)
      wait_for_image_view_to_disappear iv_id, timeout
    end

    def wait_for_image_view(iv_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but did not see image view marked: '#{iv_id}'"
      options = {:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg}
      wait_for(options) do
        image_view_exists? iv_id
      end
    end

    def wait_for_image_view_to_disappear(iv_id, timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but i still see image view marked: '#{iv_id}'"
      options = {:timeout => timeout,
                 :retry_frequency => BRIAR_WAIT_RETRY_FREQ,
                 :post_timeout => BRIAR_WAIT_STEP_PAUSE,
                 :timeout_message => msg}
      wait_for(options) do
        not image_view_exists? iv_id
      end
    end
  end
end
