# require "housing_scraper/version"

# module HousingScraper
#   class Error < StandardError; end
#   # Your code goes here...
# end
require 'kimurai'
require "selenium-webdriver"
require 'byebug'


class FantasyPros < Kimurai::Base

  @name = 'fantasyPros'
  @engine = :selenium_chrome
  @start_urls = ["https://www.fantasypros.com/nfl/rankings/half-point-ppr-rb.php"]

  @@rankings = []

  def parse(response, url:, data: {})
    sleep 5
    parse_page
    @@rankings
  end

  # def login(response, url:, data: {})
  #   email = ENV['EMAIL']
  #   password = ENV['PWD']
  #   sleep 3

  #   begin
  #     sleep 1
  #     browser.fill_in 'email', with: email
  #     sleep 1
  #     browser.fill_in 'password', with: password
  #     sleep 2
  #     browser.find(:xpath, '//*[@id="login-panel"]/form/div[4]/div[1]/input', wait: 1).click
  #   rescue Capybara::ElementNotFound
  #     puts "user is logged in"
  #   end 
  # end

  def parse_page
    response = browser.current_response

    # get all player cells // contains name, team, injury status
    playerCells = response.css('div.player-cell__td')

    

    playerCells.each do |cell|
      puts cell.inner_text
    end
      # @@rankings[:player_name] = 
    

    


    



    
    # request_to :login, url: 'https://www.zillow.com/user/acct/login/'
    # browser.find(:css, '[title="recaptcha challenge"]', wait: 25).click rescue break
    # response = browser.current_response
    # console.log('rankings', @@rankings)

    # byebug

    
    
    # File.open("tmp/rankings.json","w") do |f|
    #   f.write(JSON.pretty_generate(@@rankings))
    # end

    # save_to 'tmp/rankings.json', @@rankings, format: :pretty_json
  end


  
end

FantasyPros.crawl!