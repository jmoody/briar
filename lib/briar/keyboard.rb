


module Briar
  module Keyboard
    # these are not ready for prime time# the methods for setting auto correct, spell check, etc. are not ready
    UITextAutocapitalizationTypeNone = 0
    UITextAutocapitalizationTypeWords = 1
    UITextAutocapitalizationTypeSentences = 2
    UITextAutocapitalizationTypeAllCharacters = 3

    UITextAutocorrectionTypeNo = 1
    UITextAutocorrectionTypeYes = 2

    UITextSpellCheckingTypeNo = 1
    UITextSpellCheckingTypeYes = 2

    @text_entered_by_keyboard = ''

    def should_see_keyboard (timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but did not see keyboard"
      wait_for(:timeout => timeout,
               :retry_frequency => 0.2,
               :post_timeout => 0.1,
               :timeout_message => msg ) do
        element_exists('keyboardAutomatic')
      end
    end

    def should_not_see_keyboard (timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but keyboard did not disappear"
      wait_for(:timeout => timeout,
               :retry_frequency => 0.2,
               :post_timeout => 0.1,
               :timeout_message => msg ) do
        element_does_not_exist 'keyboardAutomatic'
      end
    end

    def briar_keyboard_enter_text (text)
      @text_entered_by_keyboard = keyboard_enter_text text
    end

    #def briar_keyboard_set_text (text, view_id, &do_for_each_char)
    #  unless device.ios7?
    #    warn 'this is hack for iOS 7 (playback not available yet) - use briar_keyboard_enter_text'
    #  end
    #
    #  query_str = "view marked:'#{view_id}'"
    #  accum = ''
    #  text.chars.to_a.each { |char|
    #    accum << char
    #    query(query_str, {setText:accum})
    #    do_for_each_char.call(view_id, accum)
    #    @text_entered_by_keyboard = accum
    #    sleep(0.05)
    #  }
    #end

    # is it possible to find what view the keyboard is responding to?
    def autocapitalization_type ()
      if !query('textView index:0').empty?
        query('textView index:0', :autocapitalizationType).first.to_i
      elsif !query('textField index:0').empty?
        query('textField index:0', :autocapitalizationType).first.to_i
      else
        screenshot_and_raise 'could not find a text view or text field'
      end
    end

    def set_autocapitalization (type)
      if !query('textView index:0').empty?
        query('textView index:0', [{setAutocapitalizationType:type}])
      elsif !query('textField index:0').empty?
        query('textField index:0', [{setAutocapitalizationType:type}])
      else
        screenshot_and_raise 'could not find a text view or text field'
      end
    end

    def turn_autocapitalization_off
      set_autocapitalization UITextAutocapitalizationTypeNone
    end

    def set_autocorrect (type)
      if !query('textView index:0').empty?
        query('textView index:0',  [{setAutocorrectionType:type}])
      elsif !query('textField index:0').empty?
        query('textField index:0', [{setAutocorrectionType:type}])
      else
        screenshot_and_raise 'could not find a text view or text field'
      end
    end

    def turn_autocorrect_off
      set_autocorrect UITextAutocorrectionTypeNo
    end

    def turn_spell_correct_off
      if !query('textView index:0').empty?
        query('textView index:0', [{setSpellCheckingType:UITextSpellCheckingTypeNo}])
      elsif !query('textField index:0').empty?
        query('textField index:0', [{setSpellCheckingType:UITextSpellCheckingTypeNo}])
      else
        screenshot_and_raise 'could not find a text view or text field'
      end
    end

    def briar_clear_text(view_id)
      touch("view marked:'#{view_id}'")
      wait_for_button 'Select All'
      step_pause
      touch_button_and_wait_for_view 'Select All', 'Cut'
      step_pause
      touch_button 'Cut'
      step_pause
    end

    #def is_capitalize_none (cap_type)
    #  cap_type == UITextAutocapitalizationTypeNone
    #end
    #
    #def is_capitalize_words (cap_type)
    #  cap_type == UITextAutocapitalizationTypeWords
    #end
    #
    #def is_capitalize_sentences (cap_type)
    #  cap_type == UITextAutocapitalizationTypeSentences
    #end
    #
    #def is_capitalize_all (cap_type)
    #  cap_type == UITextAutocapitalizationTypeAllCharacters
    #end
    #
    #def is_autocorrect_on (state)
    #  state == UITextAutocorrectionTypeYes
    #end
    #
    #def is_autocorrect_off (state)
    #  state == UITextAutocorrectionTypeNo
    #end
  end
end
