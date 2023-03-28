# frozen_string_literal: true
require 'selenium-webdriver'
require_relative 'base_search'
require_relative 'base_results'

class BingSearch < BaseSearch
  @@cookie_consent = "bnp_btn_reject"
  @@search_button= "search_icon"
  @@search_field= "sb_form_q"

  def initialize
    super(@@search_field,@@search_button,@@cookie_consent)
  end

  def get_search_button(driver)
    driver.find_element(:id,self.search_button)
  end

  def get_search_field(driver)
    driver.find_element(:id,self.search_field)
  end

end

class BingSearchResults < BaseResults
  @@next_page_button_locator ="//*[@id=\"b_results\"]//a[@title='Next page']"
  @@results_locator="//*[@id=\"b_results\"]/li[@class='b_algo']" #//*[@id="b_results"]/li[@class='b_algo']
  @@result_header_locator =".//h2/a"
  @@result_url_locator=".//div[@class='b_attribution']/cite"
  @@result_title_locator=".//h2/a"
  @@result_description_locator=".//p"
  @@top_result_locator="//*[@id=\"b_results\"]/li/div[@class='b_algo_group']" #//*[@id="b_results"]/li/div[@class='b_algo_group']
  @@top_result_description_locator=".//div[1]/div/div/div/p[@class='b_paractl']"


  def initialize
    super(@@next_page_button_locator, @@results_locator, @@result_header_locator,
          @@result_url_locator, @@result_title_locator, @@result_description_locator)
  end

  def next_page(driver)
    driver.find_element(:xpath, @next_page_button_locator).click
  end

  def get_all_results(driver)
    super(driver).push(*driver.find_elements(:xpath, @@top_result_locator))
  end

  def get_url(r)
    r.find_element(:xpath, @result_url_locator).text
  end

  def get_description(r)
    begin
      return_value = super
    rescue Selenium::WebDriver::Error::NoSuchElementError
      puts "This is top result and has a different Description locator!"
      return_value = r.find_element(:xpath, @@top_result_description_locator).text
    ensure
      return return_value
    end
  end
end
