# require "housing_scraper/version"

# module HousingScraper
#   class Error < StandardError; end
#   # Your code goes here...
# end
require 'kimurai'
require "selenium-webdriver"
require 'byebug'
require 'pry'


class FantasyPros < Kimurai::Base

  @name = 'fantasyPros'
  @engine = :selenium_chrome
  # @start_urls = ["https://www.fantasypros.com/nfl/rankings/half-point-ppr-rb.php"] # for rb's
  @start_urls = ["https://www.fantasypros.com/nfl/rankings/half-point-ppr-flex.php"] # for flex

  @@rankings = []

  def parse(response, url:, data: {})
    sleep 5
    parse_page
    @@rankings
  end


  def parse_page
    response = browser.current_response
    
    # get all player cells // contains name, team, injury status
    player_cells = response.css('div.player-cell__td')

    # go through each cell and set rankings[index+1] = inner_text 
    # create json where rank is the key and player info is the value
    # player_cells.each_with_index do |cell, i|
    #   rank = i + 1
    #   player = { rank => cell.inner_text.strip }
    #   @@rankings << player
    # end    

    # create json array of objects {player_name: 'name', team: 'team', status: 'q/d/ir etc'}
    player_cells.each do |cell|
      # binding.pry
      # grab player info & remove trailing whitespace + '()' while accounting for 3 word names and a status
      # if there weren't '( )' to split on would need to add in more steps // like spliting at capital letters or substrings
      player_info_arr = cell.inner_text.strip.split(/[()]/).each { |el| el.strip! } 

      player_name = player_info_arr.slice(0)
      team = player_info_arr.slice(1)
      if !player_info_arr[2] 
        status = ''
      else 
        status = player_info_arr.slice(2)
      end

      player = {name: player_name, team: team, status: status}
      
      @@rankings << player
    end  

    File.open("tmp/rankings.json","w") do |f|
      f.write(JSON.pretty_generate(@@rankings))
    end

    # save_to 'tmp/rankings.json', @@rankings, format: :pretty_json
  end


  # [ 
    # {1: 'player info' }
      # 
    # }
    # 
    # 
  # ]
  
end

FantasyPros.crawl!