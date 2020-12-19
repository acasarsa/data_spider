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
  # @start_urls = ["https://www.fantasypros.com/nfl/rankings/half-point-ppr-flex.php"] # for flex
  @start_urls = ["https://www.fantasypros.com/nfl/rankings/dynasty-overall.php"] # for dynasty overall ppr

  @@rankings = []

  def parse(response, url:, data: {})
    sleep 5
    parse_page
    @@rankings
  end

  def parse_page
    response = browser.current_response
    
    # get ranking table
    ranking_table = response.css('#ranking-table > tbody > tr')
    # get all player cells // contains name, team, injury status
    # player_cells = response.css('div.player-cell__td')

    # create json array of objects {player_name: 'name', team: 'team', status: 'q/d/ir etc'}
    ranking_table.each do |player|
      # binding.pry
      # grab player info & remove trailing whitespace + '()' while accounting for 3 word names and a status // if there weren't '( )' to split on would need to add in more steps // like spliting at capital letters or substrings
      name_team_status = player.children[2].inner_text.strip.split(/[()]/).each { |el| el.strip! } 
      info = name_team_status

      name = info.slice(0)
      team = info.slice(1)
      if !info[2] 
        status = ''
      else 
        status = info.slice(2)
      end

      position = player.children[3].inner_text.tr('0-9','')
      bye_week = player.children[4].inner_text
      age = player.children[5].inner_text

      player = {name: name, team: team, status: status, pos: position, bye_week: bye_week, age: age}

      
      @@rankings << player
    end  

    File.open("tmp/rankings.json","w") do |f|
      f.write(JSON.pretty_generate(@@rankings))
    end

    # save_to 'tmp/rankings.json', @@rankings, format: :pretty_json # throws an error 
  end
  
end

FantasyPros.crawl!