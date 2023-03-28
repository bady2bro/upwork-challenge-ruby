require 'selenium-webdriver'
require_relative 'driver_factory'
require_relative './pages/google_search'
require_relative './pages/bing_search'

include DriverFactory

#/**
#  * This class contains the test given as homework.
#  * NOTE:
#  * 1. Tested for keywords but results will vary depending on the localization:
#  *  a. "boomerang" - passed
#  *  b. "cat" - failed because one of the BING results is "Muzeum Sztuki i Techniki Japońskiej Manggha"
#  *      that is missing "cat" from elements
#  *  c. "chloroplast" - passed
#  *  d. They still fail sometimes, so please execute at least twice until you see expected behavior
#  *  e. The number of common links varies from execution to execution
#  *      - For Firefox "chloroplast" had one common element
#  *      - For Chrome "chloroplast" had two common elements
#  *---------------------------------------------------------------
#  * 2. Implemented implicit wait 10 seconds because it is fast fix for small test. Would implement conditional wait usually.
#  * Reasons:
#  *  a. when switching from google to bing and from chrome to firefox it took longer to load the page so I added and raised wait
#  *  b. conditional wait is best, but it makes code more complicated and prone to duplication of wait code or major change to classes
#  *---------------------------------------------------------------
#  * 3. The test was implemented with driver executables in "resources" package
#  * BUT it can be executed with external chromedriver.exe and firefoxdriver.exe:
#  *  a. Supported by my Chrome(111.0.5563.111) and Firefox(111.0.1) versions.
#  *  b. Please download and extract proper chromedriver for you at desired location:
#  *      ex. C:\ChromeDriver\chromedriver_win32\chromedriver.exe
#  *      AND
#  *      change path in property webdriver.chrome.driver in DriverFactory class
#  *  c. Please download and extract proper firefoxdriver for you at location:
#  *      C:\FirefoxDriver\geckodriver.exe
#  *      AND
#  *      change path in property webdriver.gecko.driver in DriverFactory class
#  *---------------------------------------------------------------
#  * 4. Firefox has a bug that impacts the Google search button clickability: https://bugzilla.mozilla.org/show_bug.cgi?id=1374283
#  *  a. So I found a workaround with sendKey(Keys.ENTER) that works for both browsers;
#  *  b. but implemented the workaround to trigger only for Firefox;
#  *  c. I believe there was another workaround by refreshing the page, but it is bad code
#  *
#  */
def search_result_contains(keyword, result)
  for entry in result.keys
    present = false
    puts "Start validating: #{entry}"
    for element in result[entry].keys
      puts "Result contains '#{keyword}' in '#{element}': #{result[entry][element].downcase.include? keyword.downcase}"
      if !present and result[entry][element].downcase.include? keyword.downcase
        present = true
      end
    end
    #this is quick way I found to do it without another module
    raise "Result #{entry} doesn't contain #{keyword} in any element!" unless present
    puts "----------------------------------------------"
  end
end

def get_common_results(first_results, second_results)
  puts "\tGoogle Results"
  puts(*first_results.keys)
  # If you want more details on the other attributes just remove the "keys" method
  # puts(*first_results)
  puts "----------------------------------------------"
  puts "\tBing Results"
  puts(*second_results.keys)
  puts "----------------------------------------------"
  puts "\tCommon results:"
  common_results=first_results.keys & second_results.keys
  common_results.each{|x| puts x}
  #the task didn't specify an assert here but I felt it needed one
  raise "There are no common results!" unless common_results.size>0
  puts "----------------------------------------------"
end

puts "Choose Browser instance: chrome or firefox"
browser = "Firefox"
# browser="chrome"
# in case you want to change it manually I put versions for every variable. Just uncommit
# browser=gets.chomp
puts "Choose search engine: google or bing"
search_engine = "https://www.google.com"
# search_engine="https://www.#{gets.chomp}.com"
puts "Choose keyword"
# keyword = "boomerang"
# keyword = "cat"
keyword = "chloroplast"
# keyword=gets.chomp
puts "Navigate to search engine" + search_engine
puts "1. Run browser: #{browser}"
driver = get_driver(browser)
puts "2. Go to the 1st search engine: #{search_engine}"
driver.get(search_engine)
page = GoogleSearch.new
puts "3. Clear cookies"
page.resolve_cookies(driver)
puts "4. Search using the keyword: #{keyword}"
page.search_for_keyword(driver, keyword)
puts "5. Parse the first 10 search result items (e.g. url, title, short description) and store parsed info as structured data of any chosen by you type "
page = GoogleSearchResults.new
puts "6. Make sure at least one attribute of each item from parsed search results contains #{keyword}"
puts "7. Log in stdout which search results items and their attributes contain <keyword> and which do not."
first_engine_results = page.parse_results(driver, Hash.new)
search_result_contains(keyword, first_engine_results)
search_engine = "https://www.bing.com"
# search_engine="https://www.#{gets.chomp}.com"
puts "8. Repeat steps #3 - #7 for the 2nd search engine: #{search_engine}"
puts "2. Go to the 2nd search engine: #{search_engine}"
driver.get(search_engine)
page = BingSearch.new
puts "3. Clear cookies"
page.resolve_cookies(driver)
puts "4. Search using the keyword: #{keyword}"
page.search_for_keyword(driver, keyword)
puts "5. Parse the first 10 search result items (e.g. url, title, short description) and store parsed info as structured data of any chosen by you type "
page = BingSearchResults.new
puts "6. Make sure at least one attribute of each item from parsed search results contains #{keyword}"
puts "7. Log in stdout which search results items and their attributes contain #{keyword} and which do not."
second_engine_results=page.parse_results(driver, Hash.new)
search_result_contains(keyword, page.parse_results(driver, Hash.new))
puts "9. Compare stored results for both engines and list out the most popular items (the ones which were found in both search engines)"
get_common_results(first_engine_results, second_engine_results)






