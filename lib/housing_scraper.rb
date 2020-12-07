# require "housing_scraper/version"

# module HousingScraper
#   class Error < StandardError; end
#   # Your code goes here...
# end
require 'nokogiri'
# require 'httparty'
require 'byebug'
require 'faraday'


faves = 'https://www.zillow.com/myzillow/favorites'

def scraper(url) 
  urlBase = 'https://www.zillow.com'
  unparsed_page = Faraday.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page.body)
  page = parsed_page
  byebug

end

scraper(faves)