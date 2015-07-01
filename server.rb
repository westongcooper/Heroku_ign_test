require 'sinatra'
require 'httparty'
require 'nokogiri'

class IGN
	attr_reader :html,:text
	@text = []
  def initialize
    @html = HTTParty.get('http://www.ign.com/games/reviews?platformSlug=pc&genre=action')
    doc = Nokogiri::HTML(@html)
    gameDecriptionGenre = doc.xpath("//p[@class='item-details']")
		gameNames = doc.xpath("//div[@class='item-title']")
		gameScores = doc.xpath("//span[@class='scoreBox-score']")
		@text = []
		gameScores.length.times  {|i| 
			gameDescriptionGenreTrim = gameDecriptionGenre[i].to_s.gsub(/<(.*?>)/,"").delete!("\n").squeeze.strip
			gameDescription = gameDescriptionGenreTrim.slice(gameDescriptionGenreTrim.index("-")..-1)
			gameName = gameNames[i].text.strip.squeeze
			@text <<  "#{gameName[0...gameName.index(/$/)]} = #{gameScores[i].text} / 10<br>#{gameDescription}<br><br>"
		}
	end
	def printText
		@text
	end
end
games = IGN.new

get '/' do
	games.printText.each {|text|"#{text}<br>"}
end
