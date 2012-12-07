
def view_exists? (name)
  !query("view marked:'#{name}'").empty?
end

def should_see_view (name)
  unless view_exists? name
    screenshot_and_raise "no view found with name #{name}"
  end
end

def view_exists_with_text? (text)
  element_exists("view text:'#{text}'")
end


def should_see_view_after_animation (view_name)
  wait_for_animation
  should_see_view view_name
end

def should_not_see_view_after_animation (view_id)
  wait_for_animation
  if view_exists? view_id
    screenshot_and_raise "did not expect to see view '#{view_id}'"
  end
end

def should_see_view_with_text (text)
  res = view_exists_with_text? text
  unless res
    screenshot_and_raise "No view found with text #{text}"
  end
end

Then /^I should (see|not see) (?:the|) "([^\"]*)" view$/ do |visibility, name|
  if visibility.eql? "see"
    should_see_view_after_animation name
  else
    should_not_see_view_after_animation name
  end
end


def touch_view_named(name)
  touch("view marked:'#{name}'")
end




