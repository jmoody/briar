def label_exists? (name)
  !query("label marked:'#{name}'").empty?
end

def should_see_label (name)
  res = label_exists? (name)
  unless res
    screenshot_and_raise "i could not find label with access id #{name}"
  end
end

def label_exists_with_text? (name, text)
  actual = query("label marked:'#{name}'", :text).first
  actual.eql? text
end

def should_see_label_with_text (name, text)
  unless label_exists_with_text?(name, text)
    actual = query("label marked:'#{name}'", :text).first
    screenshot_and_raise "i expected to see '#{text}' in label named '#{name}' but found '#{actual}'"
  end
end

def should_not_see_label_with_text (name, text)
  if label_exists_with_text?(name, text)
    screenshot_and_raise "i expected that i would not see '#{text}' in label named '#{name}'"
  end
end

Then /^I should (see|not see) "([^"]*)" in label "([^"]*)"$/ do |visibility, text, name|
  if visibility.eql? "see"
    should_see_label_with_text(name, text)
  else
    should_not_see_label_with_text(name, text)
  end
end

Then /^I should (see|not see) label "([^"]*)" with text "([^"]*)"$/ do |visibility, name, text|
  if visibility.eql? "see"
    should_see_label_with_text(name, text)
  else
    should_not_see_label_with_text(name, text)
  end
end

Then /^I should see an "([^"]*)" label$/ do |label_id|
  should_see_label label_id
end
