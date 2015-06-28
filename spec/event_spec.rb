require_relative "../lib/event.rb"
require "rspec"

RSpec.describe SwimVis::Event do
	urls = [
		# relay
		"http://www.swmeets.com/Realtime/NCAA/2015/150319F014.htm",

		# ind
		"http://www.fastlanetek.com/swmeets/2015_06_18_SCSC_APSS/150618F029.htm",
		"http://www.swmeets.com/Realtime/NCAA/2015/150319F008.htm"
	]

	urls.each do |url|
		before :all do
			@event = SwimVis::Event.create(url)
		end

		it "constructs from a url" do
			expect(@event.class).to be(SwimVis::Event)
		end

		it "properly reads and formats splits" do
			expect(@event.raw_splits).not_to be(nil)
			expect(@event.raw_splits.class).to be(Hash)
			expect(@event.raw_splits.first[0].class).to be(String)
			expect(@event.raw_splits.first[1].class).to be(Array)
			expect(@event.raw_splits.first[1].first.class).to be(Float)
		end
	end
end