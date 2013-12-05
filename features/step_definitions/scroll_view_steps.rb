Then /^I scroll (left|right|up|down) until I see "([^\"]*)"$/ do |dir, marker|
  wait_poll({:until_exists => "view marked:'#{marker}'",
             :timeout => 2}) do
    scroll('scrollView index:0', dir)
  end
  unless exists? marker
    screenshot_and_raise "i scrolled '#{dir}' but did not see #{marker}"
  end
end


Then /^I scroll "([^"]*)" (left|right|up|down)"$/ do |name, dir|
  swipe(dir, {:query => "view marked:'#{name}'"})
end
