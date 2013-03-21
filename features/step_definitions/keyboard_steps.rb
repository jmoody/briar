
Then /^I should see the keyboard$/ do
  should_see_keyboard
end

Then /^I should not see the keyboard$/ do
  should_not_see_keyboard
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

Then /^I touch the delete key$/ do
  keyboard_enter_char 'Delete'
end

Then(/^I turn off spell checking and capitalization$/) do
  should_see_keyboard
  turn_autocapitalization_off
  turn_autocorrect_off
  turn_spell_correct_off
end
