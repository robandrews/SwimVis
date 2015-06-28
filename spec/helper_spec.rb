require_relative "../lib/helper.rb"
require "rspec"

RSpec.describe SwimVis::Helpers do
	it "generates seconds from time string" do
		test_str = "8:25.33"
		float = SwimVis::Helpers.string_to_seconds(test_str)
		expect(float).to be(505.33)
	end
end