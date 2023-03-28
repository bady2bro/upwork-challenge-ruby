# frozen_string_literal: true
require 'selenium-webdriver'
require_relative 'base_search'
require_relative 'base_results'

class GoogleSearch < BaseSearch
  @@cookie_consent= "W0wltc"
  @@search_button="btnK"
  @@search_field="q"

  def initialize
    super(@@search_field,@@search_button,@@cookie_consent)
  end
end

# Second "class" for the result page
class GoogleSearchResults < BaseResults
  @@next_page_button_locator = "pnnext"
  @@results_locator="//*[@id=\"rso\"]//div[@jscontroller='SC7lYd']"
  @@result_header_locator =".//a/div/div/span"
  @@result_url_locator=".//div[@class=\"yuRUbf\"]/a"
  @@result_title_locator=".//a/h3"
  @@result_description_locator=".//div[@data-snf='nke7rc']/div"

  def initialize
    super(@@next_page_button_locator, @@results_locator, @@result_header_locator,
          @@result_url_locator, @@result_title_locator,@@result_description_locator)
  end

end
