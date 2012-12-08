include Briar::ImageView

Then /^I should (see|not see) (?:image|a image|an image) named "([^"]*)"$/ do |visibility, name|
  if visibility.eql? "see"
    should_see_image_view name
  else
    should_not_see_image_view name
  end
end
