def should_see_keyboard
  res = element_exists("keyboardAutomatic")
  unless res
    screenshot_and_raise "Expected keyboard to be visible."
  end
end

def should_not_see_keyboard
  res = element_exists("keyboardAutomatic")
  if res
    screenshot_and_raise "Expected keyboard to not be visible."
  end
end

Then /^I should see the keyboard$/ do
  should_see_keyboard
end

Then /^I should not see the keyboard$/ do
  should_not_see_keyboard
end

#UITextAutocapitalizationTypeNone,
#UITextAutocapitalizationTypeWords,
#UITextAutocapitalizationTypeSentences,
#UITextAutocapitalizationTypeAllCharacters

# is it possible to find what view the keyboard is responding to?
def autocapitalization_type ()
  if !query("textView index:0").empty?
    query("textView index:0", :autocapitalizationType).first.to_i
  elsif !query("textField index:0").empty?
    query("textField index:0", :autocapitalizationType).first.to_i
  else
    screenshot_and_raise "could not find a text view or text field"
  end
end

def is_capitalize_none (cap_type)
  cap_type == 0
end

def is_capitalize_words (cap_type)
  cap_type == 1
end

def is_capitalize_sentences (cap_type)
  cap_type == 2
end

def is_capitalize_all (cap_type)
  cap_type == 0
end

Then /^I use the keyboard to enter "([^"]*)"$/ do |text|
  wait_for_animation
  should_see_keyboard
  @text_entered_by_keyboard = keyboard_enter_text text
end


When /^I touch the done button the keyboard disappears$/ do
  done
  should_not_see_keyboard
end
