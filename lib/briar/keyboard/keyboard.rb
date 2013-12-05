module Briar
  module Keyboard
    # dismiss the keyboard on iPad
    # send_uia_command command:"uia.keyboard().buttons()['Hide keyboard'].tap()"

    UITextAutocapitalizationTypeNone = 0
    UITextAutocapitalizationTypeWords = 1
    UITextAutocapitalizationTypeSentences = 2
    UITextAutocapitalizationTypeAllCharacters = 3

    UITextAutocorrectionTypeYes = 0
    UITextAutocorrectionTypeNo = 1


    # might be 0 and 1?
    UITextSpellCheckingTypeNo = 1
    UITextSpellCheckingTypeYes = 2

    @text_entered_by_keyboard = ''

    def should_see_keyboard (timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but did not see keyboard"
      wait_for(:timeout => timeout,
               :retry_frequency => BRIAR_RETRY_FREQ,
               :post_timeout => BRIAR_POST_TIMEOUT,
               :timeout_message => msg) do
        element_exists('keyboardAutomatic')
      end
    end

    def should_not_see_keyboard (timeout=BRIAR_WAIT_TIMEOUT)
      msg = "waited for '#{timeout}' seconds but keyboard did not disappear"
      wait_for(:timeout => timeout,
               :retry_frequency => BRIAR_RETRY_FREQ,
               :post_timeout => BRIAR_POST_TIMEOUT,
               :timeout_message => msg) do
        element_does_not_exist 'keyboardAutomatic'
      end
    end

    def briar_keyboard_enter_text (text)
      keyboard_enter_text text
      # not ideal, but entering text by uia keyboard will never return what
      # was text was actually input to the keyboard
      @text_entered_by_keyboard = text
    end


    # is it possible to find what view the keyboard is responding to?
    def autocapitalization_type
      if !query('textView index:0').empty?
        query('textView index:0', :autocapitalizationType).first.to_i
      elsif !query('textField index:0').empty?
        query('textField index:0', :autocapitalizationType).first.to_i
      else
        screenshot_and_raise 'could not find a text view or text field'
      end
    end

    def auto_correct_type
      if !query('textView index:0').empty?
        query('textView index:0', :autocorrectionType).first.to_i
      elsif !query('textField index:0').empty?
        query('textField index:0', :autocorrectionType).first.to_i
      else
        screenshot_and_raise 'could not find a text view or text field'
      end
    end


    #noinspection RubyUnusedLocalVariable
    def briar_clear_text(view_id, timeout=5)
      deprecated('0.1.1', "will remove 'timeout' argument in a future release", :warn)
      clear_text("view marked:'#{view_id}'")

      # i really wanted this to work, but there are too many issues with the
      # touch not bringing up the the Select menu bar - for example sometimes
      # it brings up the typo correction bar.
      #wait_for_view view_id
      #step_pause
      #touch("view marked:'#{view_id}'")
      #wait_for_button 'Select All', timeout
      #step_pause
      #touch_button_and_wait_for_view 'Select All', 'Cut', timeout
      #step_pause
      #touch_button 'Cut'
      #step_pause
    end

    ### deprecated ###

    #noinspection RubyUnusedLocalVariable
    def set_autocapitalization (type)
      deprecated('0.1.1', 'does not work', :pending)
      #if !query('textView index:0').empty?
      #  query('textView index:0', [{setAutocapitalizationType: type}])
      #elsif !query('textField index:0').empty?
      #  query('textField index:0', [{setAutocapitalizationType: type}])
      #else
      #  screenshot_and_raise 'could not find a text view or text field'
      #end
    end

    def turn_autocapitalization_off
      deprecated('0.1.1', 'does not work', :pending)
      #set_autocapitalization UITextAutocapitalizationTypeNone
    end

    #noinspection RubyUnusedLocalVariable
    def set_autocorrect (type)
      deprecated('0.1.1', 'does not work', :pending)
      #if !query('textView index:0').empty?
      #  query('textView index:0', [{setAutocorrectionType: type}])
      #elsif !query('textField index:0').empty?
      #  query('textField index:0', [{setAutocorrectionType: type}])
      #else
      #  screenshot_and_raise 'could not find a text view or text field'
      #end
    end

    def turn_autocorrect_off
      deprecated('0.1.1', 'does not work', :pending)
      # set_autocorrect UITextAutocorrectionTypeNo
    end

    def turn_spell_correct_off
      deprecated('0.1.1', 'does not work', :pending)
      #if !query('textView index:0').empty?
      #  query('textView index:0', [{setSpellCheckingType: UITextSpellCheckingTypeNo}])
      #elsif !query('textField index:0').empty?
      #  query('textField index:0', [{setSpellCheckingType: UITextSpellCheckingTypeNo}])
      #else
      #  screenshot_and_raise 'could not find a text view or text field'
      #end
    end
  end
end
