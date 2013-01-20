include Briar::Keyboard

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
