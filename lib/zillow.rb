# require "housing_scraper/version"

# module HousingScraper
#   class Error < StandardError; end
#   # Your code goes here...
# end
require 'kimurai'
require "selenium-webdriver"
require 'byebug'


class Zillow < Kimurai::Base

  @name = 'zillow'
  @engine = :selenium_chrome
  @start_urls = ["https://www.zillow.com/"]

  @@homes = []

  def parse(response, url:, data: {})
    sleep 5
    parse_page
    @@homes
  end

  def login(response, url:, data: {})
    email = ENV['EMAIL']
    password = ENV['PWD']
    sleep 3

    begin
      sleep 1
      browser.fill_in 'email', with: email
      sleep 1
      browser.fill_in 'password', with: password
      sleep 2
      browser.find(:xpath, '//*[@id="login-panel"]/form/div[4]/div[1]/input', wait: 1).click
    rescue Capybara::ElementNotFound
      puts "user is logged in"
    end 
  end

  def parse_page
    # request_to :login, url: 'https://www.zillow.com/user/acct/login/'
    # browser.find(:css, '[title="recaptcha challenge"]', wait: 25).click rescue break
    gatcha = browser.current_response
    sleep 25
    driver.switchTo.frame(0).click()
    puts 'gatcha'
    puts 'gatcha'
    puts 'gatcha'
    puts 'gatcha'
    puts 'gatcha'
    puts gatcha

    sleep 25
    response = browser.current_response
    puts 'response'
    puts 'response'
    puts 'response'
    puts 'response'
    puts response

    # byebug
    
    
    # File.open("tmp/homes.json","w") do |f|
    #   f.write(JSON.pretty_generate(@@homes))
    # end

    # save_to 'tmp/homes.json', @@homes, format: :pretty_json
  end


  

  # def scraper(url) 
  #   username = ENV['EMAIL']
  #   password = ENV['PWD']
    
  #   urlBase = 'https://www.zillow.com'
  #   unparsed_page = Faraday.get(url)
  #   parsed_page = Nokogiri::HTML(unparsed_page.body)
  #   page = parsed_page
  #   byebug

  # end
end

Zillow.crawl!