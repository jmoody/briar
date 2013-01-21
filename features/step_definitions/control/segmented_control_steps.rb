include Briar::Control::Segmented_Control

Then /^I should see segmented control "([^"]*)" with titles "([^"]*)"$/ do |control_name, titles|
  @control_name = control_name
  should_see_view control_name
  tokens = titles.split(",")
  tokens.each do |token|
    token.strip!
  end
  idx = index_of_control_with_name control_name
  if idx
    actual_titles = query("segmentedControl index:#{idx} child segment child segmentLabel", :text).reverse
    counter = 0
    tokens.zip(actual_titles).each do |expected, actual|
      unless actual.eql? expected
        screenshot_and_raise "when inspecting #{control_name} i expected title: #{expected} but found: #{actual} at index #{counter}"
      end
      counter = counter + 1
    end
  else
    screenshot_and_raise "could not find segmented control with name #{control_name}"
  end
end

Then /^I touch segment "([^"]*)" in segmented control "([^"]*)"$/ do |segment_name, control_name|
  @segment_name = segment_name
  @control_name = control_name
  idx = index_of_control_with_name control_name
  if idx
    touch("segmentedControl index:#{idx} child segment child segmentLabel marked:'#{segment_name}'")
    wait_for_animation
  else
    screenshot_and_raise "could not find segmented control with name #{control_name}"
  end
end


Then /^I should see segment "([^"]*)" in segmented control "([^"]*)" (is|is not) selected$/ do |segment_name, control_name, selectedness|
  @segment_name = segment_name
  @control_name = control_name
  control_idx = index_of_control_with_name control_name
  if control_idx
    segment_idx = index_of_segment_with_name_in_control_with_name(segment_name, control_name)
    if segment_idx
      selected_arr = query("segmentedControl index:#{control_idx} child segment", :isSelected).reverse
      res = selected_arr[segment_idx]
      target = selectedness.eql?("is") ? 1 : 0
      unless res.to_i == target
        screenshot_and_raise "found segment named #{segment_name} in  #{control_name}, but it was _not_ selected"
      end
    else
      screenshot_and_raise "could not find #{segment_name} in #{control_name}"
    end
  else
    screenshot_and_raise "could not find control named #{control_name}"
  end
end

Then /^I should see the segment I touched (is|is not) selected and the "([^"]*)" should be set correctly$/ do |selectedness, label_id|
  @associated_label = label_id
  wait_for_animation
  macro %Q|I should see segment "#{@segment_name}" in segmented control "#{@control_name}" #{selectedness} selected|
  macro %Q|I should see label "#{label_id}" with text "#{@segment_name}"|
end

Then /^I touch the segment again$/ do
  macro %Q|I touch segment "#{@segment_name}" in segmented control "#{@control_name}"|
end

Then /^I should see the segment is not selected and the detail label is cleared$/ do
  macro %Q|I should see segment "#{@segment_name}" in segmented control "#{@control_name}" is not selected|
  macro %Q|I should see label "#{@associated_label}" with text ""|
end
