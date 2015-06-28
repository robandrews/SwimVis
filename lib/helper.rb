module SwimVis
  class Helpers
    def self.string_to_seconds(str)
      min, sec, milli = str.scan(/(\d*?):?(\d+)\.(\d+)/)[0]
      denom = 10**(milli.length)
      return min.to_f * 60 + sec.to_f + milli.to_f/100
    end
  end
end
