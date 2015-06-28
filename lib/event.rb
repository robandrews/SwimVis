require_relative "import.rb"
require_relative "helper.rb"
require 'debugger'

module SwimVis
  class Event
    attr_accessor :url
    attr_reader :distance, :stroke, :gender, :raw_splits, :splits

    def initialize(url, gender = nil, distance = nil, stroke = nil)
      @url = url
      @gender = gender
      @distance = distance
      @stroke = stroke
      @raw_splits = get_splits_from_url(url)
      @splits = calculate_splits(@raw_splits)
    end

    def self.create(url, gender = nil, distance = nil, stroke = nil)
      self.new(url, gender, distance, stroke)
    end

    def get_splits_from_url(url = nil)
      url = @url if url.nil?
      @url = url

      arr = SwimVis::Import.from_hytek(url)
      all_splits = {}
      current_name = ""

      
      @gender, @distance, @stroke = determine_event(arr)
      @distance = @distance.to_i
    
      arr.each_with_index do |string, idx|
        next if string.empty?

        # Individual name format
        name = string.scan(/^\s*\d+\s*([a-zA-Z -]+,\s{1}\S*)/)
        # Relay name format
        name = string.scan(/([A-Za-z]+-[A-Za-z]+)/) if name.empty?

        if(name.length > 0)
          current_name = name[0][0]
          all_splits[current_name] = []
        else
          
          # haaaaaaack - reaction time has format r+0.74
          next if string.match(/[abcdefghijklmnopqstuvwxyz]/i)
        	splits = string.scan(/\s+(?!\(\d+:\d+.\d+|\d+.\d+\))(\d+:\d+.\d+|\d+.\d+)/)
      	  if(splits.length> 0)
            next unless splits[0][0].include?(".")

            next if splits[0].nil? || splits[0].first.nil?
      	  	all_splits[current_name] << SwimVis::Helpers.string_to_seconds(splits[0].first)

            next if splits[1].nil? || splits[1].first.nil?
      	  	all_splits[current_name] << SwimVis::Helpers.string_to_seconds(splits[1].first)
      	  end
        end
      end
      all_splits.select{|k, v| v.length > 0}
    end

    def calculate_splits(raw_splits)
      split_distance = @distance.to_i / @raw_splits.first[1].length
      {}.tap do |obj|
        raw_splits.each do |name, splits|
          obj[name] = []
          splits.each_with_index do |split, idx|
            last_split = idx == 0 ? 0 : splits[idx - 1]
            obj[name] << (split - last_split).round(2)
          end
        end
      end
    end

    def determine_event(arr)
      while(arr.length)
        string = arr.shift
        next if string.empty?
        res = string.scan(/^\s*event.+\b(women|men|boys|girls).+(50|100|200|400|800|1500).+(fly|back+|breast|free|im)/i)
        if res.length > 0
          return res[0]
          break
        end
      end
    end

    def splits_in_csv_string
      str = ""
      @splits.each do |race|
        str += race[0] + ","
        race[1].each do |split|
          str += split.to_s + ","
        end
        str += "\n"
      end
      str
    end
  end
end
