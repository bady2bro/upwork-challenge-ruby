require 'selenium-webdriver'
module DriverFactory
  def get_driver(browser)
    if browser.downcase == "firefox"
      Selenium::WebDriver::Firefox::Service.driver_path="C:/FirefoxDriver/geckodriver.exe"
      driver = Selenium::WebDriver.for :firefox
      driver.manage.window.maximize
    else
      Selenium::WebDriver::Chrome::Service.driver_path="C:/ChromeDriver/chromedriver_win32/chromedriver.exe"
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("start-maximized")
      options.add_option(:detach, true)
      driver = Selenium::WebDriver.for(:chrome, options: options)
    end
    driver.manage.timeouts.implicit_wait = 10
    driver
  end
end
