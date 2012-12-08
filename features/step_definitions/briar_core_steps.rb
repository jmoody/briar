include Briar::Core

Then /^I should (see|not see) (?:the|) "([^\"]*)" view$/ do |visibility, view_id|
  if visibility.eql? "see"
    should_see_view_after_animation view_id
  else
    should_not_see_view_after_animation view_id
  end
end
