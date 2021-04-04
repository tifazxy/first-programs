require 'open-uri'
require 'nokogiri'

DOMAIN = 'https://www.oxfordlearnersdictionaries.com'
DOWNLOAD_PATH = '/home/me/audio/'

def download_resource(audio_map)
  audio_map.each_pair { |key, value|
    # puts key
    # puts value
    File.open(DOWNLOAD_PATH + key,"wb") do |file|
      file.write URI.open(value).read 
    end
  }
end

def read_dom()
  audio = Hash.new
  File.open('test_dom.html') do |input|
    document = Nokogiri::HTML.parse(input.read)
    tags = document.xpath("//div")
    # tag = tags.map { |t| t[:"data-src-mp3"] }
  
    tags.each do |tag|
      unless tag[:"data-src-mp3"].nil?
        %r|([^/]+$)| =~ tag[:"data-src-mp3"]
        audio[$1] = DOMAIN + tag[:"data-src-mp3"] 
      end
    end
  end
  download_resource(audio)
end

read_dom

