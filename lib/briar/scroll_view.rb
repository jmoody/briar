require "calabash-cucumber"

module Briar
  module ScrollView
    def exists? (expected_mark)
      (element_exists("view marked:'#{expected_mark}'") or
            element_exists("view text:'#{expected_mark}'"))
    end
  end
end
