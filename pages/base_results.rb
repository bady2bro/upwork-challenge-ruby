# frozen_string_literal: true
# I am new to Ruby so I didn't want to attempt an interface poorly so I only did inheritance
class BaseResults
  attr_accessor :next_page_button_locator, :results_locator, :result_header_locator, :result_url_locator,
                :result_title_locator, :result_description_locator

  def initialize(nextPageButton, results, resultHeader, resultUrl, resultTitle, resultDescription)
    @next_page_button_locator = nextPageButton
    @results_locator= results
    @result_header_locator = resultHeader
    @result_url_locator = resultUrl
    @result_title_locator = resultTitle
    @result_description_locator = resultDescription
  end

  def get_all_results(driver)
    driver.find_elements(:xpath, @results_locator)
  end

  def next_page(driver)
    driver.find_element(:id, @next_page_button_locator).click
  end

  def get_url(r)
    r.find_element(:xpath, @result_url_locator).attribute("href")
  end

  def get_title(r)
    r.find_element(:xpath, @result_title_locator).text
  end

  def get_header(r)
    r.find_element(:xpath, @result_header_locator).text
  end

  def get_description(r)
    r.find_element(:xpath, @result_description_locator).text
  end

  def parse_results(driver,return_results)
    all_results = get_all_results(driver)
    #The attributes in the DOM changed between versions and I added this if to cover for that possibility
    # it changed from @data-sokoban-feature='nke7rc' to @data-snf='nke7rc'
    if all_results.size==0
      puts "The xpath, id changed or the page didn't return results"
    else
      all_results.each { |r|
        puts "\t\tParsing element: #{get_title(r)}"
        result = Hash.new
        begin
          result[:header] = get_header(r)
        rescue Selenium::WebDriver::Error::NoSuchElementError
          puts "This is a nested element and will be skipped"
          next
        end
        result[:title] = get_title(r)
        result[:description] = get_description(r)
        url = get_url(r)
        url.chomp! "/"
        result[:url] = url
        #BING always removes trailing "/" while GOOGLE is inconsistent so I chomp it for common key
        return_results[url] = result
        #if we have 10 results already, stop parsing new results
        if return_results.size == 10
          return return_results
        end
      }
      #Separated the recursion condition and call for 2 reasons:
      #    1. clearer to read and implement
      #    2. because I didn't want to risk moving to next page after every iteration
      if return_results.size < 10
        next_page(driver)
        parse_results(driver,return_results)
      end
    end
    return_results
  end
end
