


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


    def should_see_keyboard
      res = element_exists('keyboardAutomatic')
      unless res
        screenshot_and_raise 'Expected keyboard to be visible.'
      end
    end

    def should_not_see_keyboard
      res = element_exists('keyboardAutomatic')
      if res
        screenshot_and_raise 'Expected keyboard to not be visible.'
      end
    end

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
