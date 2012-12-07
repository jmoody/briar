def exists? (expected_mark)
  (element_exists("view marked:'#{expected_mark}'") or
        element_exists("view text:'#{expected_mark}'"))
end


Then /^I scroll (left|right|up|down) until I see "([^\"]*)" limit (\d+)$/ do |dir, name, limit|
  unless exists?(name)
    count = 0
    begin
      scroll("scrollView index:0", dir)
      sleep(STEP_PAUSE)
      count = count + 1
    end while ((not exists?(name)) and count < limit.to_i)
  end
  unless exists?(name)
    screenshot_and_raise "i scrolled '#{dir}' '#{limit}' times but did not see #{name}"
  end
end

Then /^I scroll "([^"]*)" (left|right|up|down)"$/ do |name, dir|
  swipe(dir, {:query => "view marked:'#{name}'"})
end
