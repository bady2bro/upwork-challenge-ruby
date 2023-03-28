# frozen_string_literal: true

class BaseSearch
  #I don't know the conventions for ruby so I used attr_accessors for attributes common between engines(parent class)
  # and Class variables @@search_field_locator for engine specific values (in child class)
  attr_accessor :cookie_consent, :search_button, :search_field

  def initialize(search_field,search_button, cookie_button)
    @search_field=search_field
    @search_button=search_button
    @cookie_consent=cookie_button
  end

  def get_cookie_consent(driver)
    driver.find_element(:id,@cookie_consent)
  end

  def get_search_button(driver)
    driver.find_element(:name,@search_button)
  end

  def get_search_field(driver)
    driver.find_element(:name,@search_field)
  end

  def resolve_cookies(driver)
    puts "\tCheck if the cookie consent button is present"
    if driver.find_elements(:id,@cookie_consent).size==1
      puts "\t\tIf the button is present click it"
      get_cookie_consent(driver).click
    end
  end

  def search_for_keyword(driver, keyword)
    puts"\tWrite the keyword in the search field"
    get_search_field(driver).send_keys(keyword)
    puts "\tConfirm search"
    # The bug for firefox and the search button is happening for Ruby too
    if driver.browser.to_s == "firefox"
      get_search_field(driver).send_keys :enter
    else
      #The suggestions panel disappears while "driver.browser.to_s" is executed so I need to click the field again
      # There are 2 elements with search button name="btnK" and the first one is in the suggestions
      get_search_field(driver).click
      get_search_button(driver).click
    end
  end
end
