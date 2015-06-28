require 'open-uri'
require 'nokogiri'

module SwimVis
  class Import
    def self.from_hytek(url)
      doc = Nokogiri::HTML(open(url))
      return doc.xpath("//html/body/pre").text.split("\n")
    end
  end
end