#include Briar::Label

Then /^I should (see|not see) "([^"]*)" in label "([^"]*)"$/ do |visibility, text, name|
  if visibility.eql? "see"
    should_see_label_with_text(name, text)
  else
    should_not_see_label_with_text(name, text)
  end
end

Then /^I should (see|not see) label "([^"]*)" with text "([^"]*)"$/ do |visibility, name, text|
  if visibility.eql? 'see'
    should_see_label_with_text(name, text)
  else
    should_not_see_label_with_text(name, text)
  end
end

Then /^I should see an "([^"]*)" label$/ do |label_id|
  should_see_label label_id
end
