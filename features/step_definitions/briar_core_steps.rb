
Then /^I should (see|not see) (?:the|) "([^\"]*)" view$/ do |visibility, view_id|
  if visibility.eql? 'see'
    should_see_view view_id
  else
    should_not_see_view view_id
  end
end

Then(/^I wait for rotation animation$/) do
  2.times { step_pause }
end
